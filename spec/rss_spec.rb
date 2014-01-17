require 'spec_helper'



module BetfairResults
  describe RSS do
    before(:each) do
      @betfair_rss = RSS.find_results_for({:sport_id => 7, :country_id => 9999})
    end

    describe "#outright_winners" do

      it "returns an array of result objects" do
        @betfair_rss.outright_winners.each {|item| expect(item).to be_a_kind_of(Result)}
      end

      describe "result objects" do

        it "responds to winner" do
          @betfair_rss.outright_winners.each {|item| expect(item).to respond_to(:name)}
        end

        it "responds to race time" do
          @betfair_rss.outright_winners.each {|item| expect(item).to respond_to(:venue)}
        end
      end
    end
  end
end