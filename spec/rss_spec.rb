require 'spec_helper'



module BetfairResults
  describe RSS do
    before(:each) do
      @betfair_rss = RSS.find_results_for({sport_id: 7, country_id: 1})
    end


    it "should get data from BetFair" do
      expect(@betfair_rss.feed).to be_a_kind_of(Feedzirra::Parser::RSS)
    end

    it "shows me" do
       @betfair_rss.outright_winners
    end


  end

end