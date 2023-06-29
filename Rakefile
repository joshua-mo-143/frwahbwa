# frozen_string_literal: true

task default: %w[run]

task :run do
  ruby 'lib/main.rb'
end

task :sql do
  ruby 'lib/main.rb --sqlite'
end

task :cron do
  ruby 'lib/main.rb --cron'
end

task :test do
  ruby 'lib/test.rb'
end
