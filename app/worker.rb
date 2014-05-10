require "workers"
require_relative "broadcaster"
require_relative "db_writer"

# Required by sidekiq which otherwise wouldn't be able to find
# the serialized model Bittracktor::MultiTicker::Btce f.i.
require_relative "models/btce"
require_relative "models/bitstamp"

module Bittracktor
  module MultiTicker
    class Worker

      def initialize(workers_amount, interval, platform_name, request, response)
        pool            = Workers::Pool.new(size: workers_amount)
        @scheduler      ||= Workers::Scheduler.new(pool: pool)
        @interval       = interval
        @broadcaster    = Broadcaster.new
        @platform_name  = platform_name
        @request        = request
        @response       = response
        @task_timer     = nil
      end

      def run_task
        @task_timer = Workers::PeriodicTimer.new(@interval, logger: nil, scheduler: @scheduler) do
          @response.raw = @request.get
          @broadcaster.publish(@platform_name, @response.raw)
          write_to_db(JSON.parse(@response.raw))
        end
      end

      def stop_task
        @task_timer.cancel
      end

    private

      def write_to_db(data)
        require_model(@platform_name)
        platform_model = Object.
            const_get("Bittracktor::MultiTicker").
            const_get(@platform_name.capitalize)

        Bittracktor::MultiTicker::DbWriter.
            delay(retry: false, queue: "default").
            create(platform_model, @platform_name, data)
      end

      def require_model(platform_name)
        require_relative "../app/models/#{platform_name}"
      end

    end
  end
end

