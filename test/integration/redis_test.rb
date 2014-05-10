require_relative '../test_helper'

module Bittracktor
  module MultiTicker
    describe Redis do

      before do
        @redis = REDIS_CONN
      end

      after do
        @redis.quit
      end

      describe ' [INTEGRATION] Ping Redis' do
        it 'must return PONG' do
          @redis.ping.must_equal('PONG')
        end
      end

    end
  end
end
