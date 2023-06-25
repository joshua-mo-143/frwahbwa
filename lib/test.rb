# frozen_string_literal: true

require 'mechanize'
require 'csv'
require 'date'
require_relative 'utils'

array = []
pagenum = 1

mechanize = Mechanize.new

page = mechanize.get("https://www.google.com")

search = page.search("//div[@data-component-type='s-search-result']")

pp search
