require 'spec_helper'



module BetfairResults
  describe RSS do
    before(:each) do
      @betfair_rss = RSS.find_results_for({sport_id: 7, country_id: 9999})
    end

    it "shows me" do
       puts @betfair_rss.outright_winners
    end


  end

end