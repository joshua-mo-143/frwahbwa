# frozen_string_literal: true

require "optparse"

Product = Struct.new(:name, :price, :old_price, :link, :created_at, keyword_init: true)
Settings = Struct.new(:output_type, :run_type, keyword_init: true) do
  def edit_output_type(type)
    self.output_type = type
  end

  def edit_run_type(type)
    self.run_type = type
  end
end

def process_argv(settings)
  options = {}

  OptionParser.new do |opts|
    opts.banner = "Usage: ruby lib/main.rb [options]"

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      options[:verbose] = v
    end

    opts.on("-c", "--cron", "Run as a scheduled task") do |_v|
      settings.edit_run_type("cron")
    end

    opts.on("--sqlite", "Save the results into a SQLite database") do |_v|
      settings.edit_output_type("sqlite")
    end
  end.parse!
end
