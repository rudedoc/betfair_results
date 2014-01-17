require "betfair_results/version"
require 'feedzirra'
require 'chronic'

module BetfairResults
  class RSS
    attr_reader :sport_id, :country_id
    REGEX_LIST = Regexp.union([/TO BE PLACED/,
                               /Match Bets/,
                               /Reverse Forecast /,
                               /Forecast Betting /,
                               /Will Racing Go Ahead?/,
                               /(W\/O)/,
                               /Daily Win Dist Odds/])

    def self.find_results_for(codes_hash)
      new(codes_hash)
    end

    def outright_winners
      feed.entries.collect do |entry|
        Result.new(clean_summary_string(entry.summary), get_date_time(entry.title), get_venue_string(entry.title)) if !entry.title.match(REGEX_LIST)
      end.compact
    end

    private

    def initialize(codes_hash)
      @sport_id = codes_hash[:sport_id]
      @country_id = codes_hash[:country_id]
    end

    def feed
      Feedzirra::Feed.fetch_and_parse("http://rss.betfair.com/RSS.aspx?format=rss&sportID=#{sport_id}&countryID=#{country_id}")
    end

    def get_date_time(string)
      Chronic.parse(string.match(/\w{3,}\s\w{3,}\s\-\s([01]?[0-9]|2[0-3]):[0-5][0-9]/).to_s.gsub(/\-\s/, ""))
    end

    def get_venue_string(string)
      string.match(/^\D+/).to_s.split("/ ")[1].strip
    end

    def clean_summary_string(string)
      string.gsub(/\s+/, "")
      string.split(': ')[1].downcase.lstrip
    end
  end

  Result = Struct.new(:name, :scheduled_off_time, :venue)
end
