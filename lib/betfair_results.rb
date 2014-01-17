require "betfair_results/version"
require 'feedzirra'

module BetfairResults
  class RSS

    attr_reader :sport_id, :country_id
    REGEX_LIST = [/TO BE PLACED/,
                  /Match Bets/,
                  /Reverse Forecast /,
                  /Forecast Betting /,
                  /Will Racing Go Ahead?/,
                  /(W\/O)/,
                  /Daily Win Dist Odds/]

    def initialize(codes_hash)
      @sport_id = codes_hash[:sport_id]
      @country_id = codes_hash[:country_id]
    end

    def self.find_results_for(codes_hash)
      new(codes_hash)
    end

    def feed
      Feedzirra::Feed.fetch_and_parse("http://rss.betfair.com/RSS.aspx?format=rss&sportID=#{sport_id}&countryID=#{country_id}")
    end

    def outright_winners
      #TODO: Nasty
      names = []
      feed.entries.each do |entry|
        title = entry.title
        winner_name = entry.summary if title !~ /TO BE PLACED/ && title !~ /Match Bets/ && title !~ /Reverse Forecast / && title !~ /Forecast Betting / && title !~ /(W\/O)/ && title !~ /Daily Win Dist Odds/ && title !~ /Will Racing Go Ahead?/
        winner_name.gsub(/\s+/, "") if winner_name != nil
        names << winner_name.split(': ')[1].inspect if winner_name != nil
      end
    end
  end
end
