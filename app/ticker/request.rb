module Bittracktor
  module MultiTicker
    class Request

      def initialize(url)
        @url = url
      end

      def get
        Net::HTTP.get(URI.parse "#{@url}")
      end

    end
  end
end