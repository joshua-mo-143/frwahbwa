# frozen_string_literal: true

task default: %w[run]

task :run do
  ruby 'lib/main.rb'
end

task :check do
  rubocop app inspect 'lib'
end
