ENV["RACK_ENV"] = "test"

require "simplecov"
require "minitest/reporters"
require "minitest/capybara"
require "minitest/autorun"
require "minitest/spec"
require "minitest/unit"
require "factory_girl"
require "json"
require "sequel"
require "database_cleaner"
require "vcr"

if ENV["COVERAGE"]
  SimpleCov.start do
    coverage_dir  "test/coverage"

    add_filter    "lib/tasks"
    add_filter    "config"
    add_filter    "test"

    add_group     "Exchange", "/app/exchange"
    add_group     "Pair",     "/app/pair"
    add_group     "Ticker",   "/app/ticker"
    add_group     "Models",   "/app/models"
    add_group     "Libs",     "/lib"
  end
end

VCR.configure do |c|
  c.cassette_library_dir = "test/cassettes"
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

DatabaseCleaner.strategy = :transaction

class MiniTest::Test
  include FactoryGirl::Syntax::Methods
end

class MiniTest::Spec
  include FactoryGirl::Syntax::Methods

  before :each do
    DatabaseCleaner.start if respond_to?("Bittracktor::MultiTicker::Base.db")
  end

  after :each do
    DatabaseCleaner.clean if respond_to?("Bittracktor::MultiTicker::Base.db")
  end
end

Minitest::Reporters.use! [ Minitest::Reporters::SpecReporter.new ]

Dir.glob("#{__dir__}/factories/**/*.rb", &method(:require))
FactoryGirl.reload

