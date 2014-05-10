require_relative "../test_helper"
require_relative "../../app"

module Bittracktor
  module MultiTicker
    describe App do

      before do
        @app = App.new!
      end

      describe " [FUNCTIONAL] New App instance" do
        it "must return the instance class" do
          @app.class.must_equal(Bittracktor::MultiTicker::App)
        end
      end

    end
  end
end
