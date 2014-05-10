require_relative "request"
require_relative "response"
require_relative "../../app/worker"

module Bittracktor
  module MultiTicker
    class Ticker

      attr_reader :url, :interval, :worker

      # Default interval is relatively high which avoids getting banned by CloudFlare f.i.
      # Change it in the exchanges settings, app/exchange/btce.yml f.i.
      def initialize(url: nil, interval: 10, platform_name: platform_name)
        request         = Request.new(url)
        response        = Response.new
        workers_amount  = 1
        @worker         = Worker.new(workers_amount, interval, platform_name, request, response)
      end

      class << self
        def all
          ObjectSpace.each_object(self).to_a
        end
      end

      def start
        @worker.run_task
      end

      def stop
        @worker.stop_task
      end

    end
  end
end
