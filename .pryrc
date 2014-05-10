require "hirb"
require_relative "app"

Pry.config.print = proc do |output, value|
  Hirb::View.view_or_page_output(value) || Pry::DEFAULT_PRINT.call(output, value)
end

Pry.config.hooks.add_hook(:when_started, :say_hi) do
  puts "Using Ruby version #{RUBY_VERSION}"
end

Hirb.enable
