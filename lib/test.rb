# frozen_string_literal: true

require "mechanize"
require "csv"
require "date"
require_relative "sqlite"

array = []
mechanize = Mechanize.new

puts "Starting web scrape..."

begin
  page = mechanize.get("https://www.amazon.co.uk/s?k=raspberry+pi&page=1")
rescue Mechanize::ResponseCodeError => e
  puts "Error occurred when trying to scrape: #{e.message}"
  puts "The scraper will try again in another 10 seconds."
  sleep(10)
else
  search = page.search("//div[@data-component-type='s-search-result']")

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
  write_to_db(array)
end
