# frozen_string_literal: true

require 'mechanize'
require 'csv'
require 'date'
require_relative 'utils'

array = []
pagenum = 1

mechanize = Mechanize.new

begin
loop do
  page = mechanize.get("https://www.amazon.co.uk/s?k=raspberry+pi&page=#{pagenum}")
  rescue Mechanize::ResponseCodeError => e
    p e.message
    sleep(20)
  else 

  puts "Parsing page #{pagenum} of Amazon Raspberry Pi results..."
    
  pagenum += 1

  search = page.search("//div[@data-component-type='s-search-result']")
    
    if search.length() == 0 then break end

  search.each do |x|
    prices = x.css('span.a-price > span.a-offscreen').map { |price| price.text.strip }

    product = Product.new(
      name: x.css('h2 > a').text.strip,
      price: prices[0],
      old_price: prices[1],
      link: x.css('h2 > a').map do |link|
        "https://amazon.co.uk#{link['href'].strip}"
      end,
      created_at: Date.today
    )

    array.push(product)
  end

  sleep(20)
end

p 'Creating CSV file...'
  
  CSV.open('results.csv', 'wb') do |csv|
    array.each do |row|
      csv << row
    end
  end

p 'Parsing finished! You can see the results in results.csv.'
end