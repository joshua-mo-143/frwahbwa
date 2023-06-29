# frozen_string_literal: true

require_relative 'utils'
require_relative 'scrape'

settings = Settings.new(
  output_type: 'csv',
  run_type: 'once'
)

process_argv(settings)

if settings.run_type == 'cron'
  scrape_as_task(settings.output_type)
else
  scrape(settings.output_type)
end
