require 'redis'

module Bittracktor
  module MultiTicker
    class Broadcaster

      attr_reader :station

      def initialize
        @station = REDIS_CONN
      end

      def publish(channel, msg)
        transmission_reception = @station.publish(channel, msg)

        #TODO is it really required to rpush?
        #if transmission_reception == 1
          transmission_reception
        #else
        #  @station.rpush(channel, msg)
        #end
      end

    end
  end
end
