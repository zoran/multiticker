require_relative "../test_helper"
require_relative "../../app/receiver"

module Bittracktor
  module MultiTicker
    describe Receiver do

      before do
        #VCR.insert_cassette('receiver_spec')

        @broadcaster = build(:broadcaster)
        @receiver    = build(:receiver)
        @channel     = "receiver_test_channel"
        @msg         = "receiver_test_message"
      end

      after do
        #VCR.eject_cassette
      end

      describe " [FUNCTIONAL] listening to a broadcaster (redis) station" do
        it "must return a message" do
          @broadcaster.publish(@channel, @msg)
          sleep 0.2
          thr_rec = Thread.new { @receiver.listen(@channel).must_equal(@msg) }
          thr_rec.kill
        end
      end

    end
  end
end
