require_relative "../test_helper"
require_relative "../../app/pair"

module Bittracktor
  module MultiTicker
    describe Pair do

      before do
        @pair = build(:pair)
      end

      describe " [FUNCTIONAL] New Pair instance" do
        it "must return the instance class" do
          @pair.class.must_equal(Bittracktor::MultiTicker::Pair)
        end
      end

    end
  end
end