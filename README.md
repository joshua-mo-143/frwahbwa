### Ruby Amazon Scraper

This is a simple Amazon results scraper, written in Ruby. Pagination is supported.

Currently it's set to scrape Raspberry Pi prices, but you can change it by adding your own strings.

Outputs to csv by default, but work is being done to support SQLite/PostgresQL instances.

### How to Use

You'll need Ruby installed, as well as the `bundle` gem.

Simply run the following to get started:

```sh
  bundle install
  rake
```

### Dependencies

- mechanize: The whole point of this program (getting some web scraped results).

- csv: Save things to CSV.

- rufo: Formatting.

- rake: It's Makefile, for Ruby.

- rubocop: Ruby linting.