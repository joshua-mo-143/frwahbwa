# frozen_string_literal: true

require "mechanize"
require "csv"
require "date"
require_relative "sqlite"

def scrape(output_type: String)
  array = []
  pagenum = 1
  mechanize = Mechanize.new

  puts "Starting web scrape..."

  loop do
    page = mechanize.get("https://www.amazon.co.uk/s?k=raspberry+pi&page=#{pagenum}")
  rescue Mechanize::ResponseCodeError => e
    puts "Error occurred when trying to scrape: #{e.message}"
    puts "The scraper will try again in another 20 seconds."
    sleep(20)
  else
    puts "Getting page #{pagenum} of Amazon Raspberry Pi results. Parsing..."

    pagenum += 1

    search = page.search("//div[@data-component-type='s-search-result']")

    break if search.empty?

    search.each do |x|
      product = create_product(x)

      array.push(product)
    end

    sleep(20)
  end
  write_to_csv(array) if output_type == "csv"
  write_to_db(array) if output_type == "sqlite"
end

def scrape_as_task(output_type)
  loop do
    time = Time.new
    timestring = "#{time.hour}:#{format("%02d", time.min)}"

    scrape(output_type) if timestring == "00:00"

    sleep(1)
  end
end

def write_to_csv(data: Array[Product])
  puts "Creating CSV file..."

  CSV.open("results.csv", "wb") do |csv|
    data.each do |row|
      csv << row
    end
  end

  puts "Parsing finished! You can see the results in results.csv."
end

def create_product(data: Array[Nokogiri::XML::Node])
  prices = data.css("span.a-price > span.a-offscreen").map { |price| price.text.strip }

  Product.new(
    name: x.css("h2 > a").text.strip,
    price: prices[0],
    old_price: prices[1],
    link: x.css("h2 > a").map do |link|
      "https://amazon.co.uk#{link["href"].strip}"
    end,
    created_at: Date.today.to_s,
  )
end
