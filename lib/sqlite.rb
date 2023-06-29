# frozen_string_literal: true

require "sqlite3"
require_relative "utils"

def write_to_db(data: Array[Product])
  let filename = "results.db"

  check_db_exists(filename)

  db = SQLite3::Database.open filename

  data.each do |row|
    puts "Executing insert..."
    db.execute "INSERT INTO products (name, price, old_price, link, created_at) VALUES (?, ?, ?, ?, ?)",
               row.name,
               row.price,
               row.old_price,
               row.link,
               row.created_at
  end
end

def check_db_exists(filename)
  return if File.exist?(filename)

  puts "Didn't find a database! Creating a new one..."
  db = SQLite3::Database.new "results.db"

  db.execute "create table products (
	id integer primary key autoincrement,
	name varchar,
	price varchar,
	old_price varchar,
	link varchar,
	created_at varchar
);"
  puts "Created migrations"
end
