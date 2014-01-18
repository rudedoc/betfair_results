require 'spec_helper'
module BetfairResults
  describe RSS do
    before(:all) do
      @betfair_rss = RSS.find_results_for({:sport_id => 7, :country_id => 1})
    end

    describe "#method_missing" do
      it "get_horse_racing_US" do
        puts RSS.get_horse_racing_US.outright_winners.each { |item| expect(item).to be_a_kind_of(Result) }
      end

      it "get_horse_racing_UK_IRE" do
        puts RSS.get_horse_racing_UK_IRE.outright_winners.each { |item| expect(item).to be_a_kind_of(Result) }
      end

    end


    describe "#outright_winners" do
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