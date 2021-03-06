require 'bundler/setup'
Bundler.setup

require 'cubits'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after do
    Cubits.reset
  end
end

