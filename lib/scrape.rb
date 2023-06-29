# frozen_string_literal: true

require "mechanize"
require "csv"
require "date"
require_relative "sqlite"

def scrape(output_type)
  array = []
  pagenum = 1
  mechanize = Mechanize.new

  puts "Starting web scrape..."

  begin
    loop do
      page = mechanize.get("https://www.amazon.co.uk/s?k=raspberry+pi&page=#{pagenum}")
    rescue Mechanize::ResponseCodeError => e
      puts "Error occurred when trying to scrape: #{e.message}"
      puts "The scraper will try again in another 20 seconds."
      sleep(20)
    else
      puts "Parsing page #{pagenum} of Amazon Raspberry Pi results..."

      pagenum += 1

      search = page.search("//div[@data-component-type='s-search-result']")

      break if search.empty?

      search.each do |x|
        prices = x.css("span.a-price > span.a-offscreen").map { |price| price.text.strip }

        product = Product.new(
          name: x.css("h2 > a").text.strip,
          price: prices[0],
          old_price: prices[1],
          link: x.css("h2 > a").map do |link|
            "https://amazon.co.uk#{link["href"].strip}"
          end,
          created_at: Date.today.to_s,
        )

        array.push(product)
      end

      sleep(20)
    end
    write_to_csv(array) if output_type == "csv"
    write_to_db(array) if output_type == "sqlite"
  end
end

def scrape_as_task(output_type)
  loop do
    time = Time.new
    timestring = "#{time.hour}:#{format("%02d", time.min)}:#{time.sec}"

    scrape(output_type) if timestring == "11:05:30"

    sleep(1)
  end
end

def write_to_csv(data)
  puts "Creating CSV file..."

  CSV.open("results.csv", "wb") do |csv|
    data.each do |row|
      csv << row
    end
  end

  puts "Parsing finished! You can see the results in results.csv."
end
