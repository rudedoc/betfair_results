require 'spec_helper'
module BetfairResults
  describe RSS do
    before(:each) do
      @betfair_rss = RSS.find_results_for({:sport_id => 7, :country_id => 2})
    end

    describe "#outright_winners" do

      it "shows me" do
        puts @betfair_rss.outright_winners
      end

      it "returns an array of result objects" do
        @betfair_rss.outright_winners.each { |item| expect(item).to be_a_kind_of(Result) }
      end

      describe "result objects" do

        it "responds to #name" do
          @betfair_rss.outright_winners.each { |item| expect(item).to respond_to(:name) }
        end

        it "responds to #venue" do
          @betfair_rss.outright_winners.each { |item| expect(item).to respond_to(:venue) }
        end

        it "responds to #scheduled_off_time with Time object" do
          @betfair_rss.outright_winners.each { |item|
            expect(item).to respond_to(:scheduled_off_time)
            expect(item.scheduled_off_time).to be_a_kind_of(Time)
          }
        end
      end
    end
  end
end