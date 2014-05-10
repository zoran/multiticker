require_relative "../test_helper"
require_relative "../../app/broadcaster"

module Bittracktor
  module MultiTicker
    describe Broadcaster do

      before do
        @broadcaster = build(:broadcaster)
        @receiver    = build(:receiver)
        @channel     = "broadcaster_test_channel"
        @msg         = "broadcaster_test_message"
      end

      describe " [FUNCTIONAL] publishing a message" do
        it "must return a number" do
          response = @broadcaster.publish(@channel, @msg)
          sleep 0.2
          response.to_s.must_match(a_number)
        end
      end

      describe " [FUNCTIONAL] publishing a message with having a listening receiver" do
        it "must return 1" do
          thr_rec = Thread.new { @receiver.listen(@channel) }
          sleep 0.5
          @broadcaster.publish(@channel, @msg).to_s.must_match(a_number)
          thr_rec.kill
        end
      end

      def a_number
        /\A[-+]?[0-9]*\.?[0-9]+\Z/
      end

    end

  end
end
