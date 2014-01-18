require "betfair_results/version"
require 'feedzirra'
require 'chronic'

module BetfairResults
  class RSS
    attr_reader :sport_id, :country_id

    private_class_method :new

    RSS_CODES = {
        :bandy => {:sport_id => 998919},
        :basketball => {:sportID => 7522},
        :bowls => {:sport_id => 998918},
        :cricket => {:sport_id => 4},
        :financial_bets => {:sport_id => 6231},
        :floorball => {:sport_id => 998920},
        :golf => {:sport_id => 3},
        :greyhound_racing => {:sport_id => 4339},
        :handball => {:sport_id => 468328},
        :hockey => {:sport_id => 7523},
        :horse_racing_other => {:sport_id => 7, :country_id => 9999},
        :horse_racing_UK_IRE => {:sport_id => 7, :country_id => 1},
        :horse_racing_US => {:sport_id => 7, :country_id => 2},
        :ice_hockey => {:sport_id => 7524},
        :rugby_union => {:sport_id => 5},
        :snooker => {:sport_id => 6422},
        :soccer => {:sport_id => 1},
        :special_bets => {:sport_id => 10},
        :volleyball => {:sport_id => 998917},
        :winter_sports => {:sport_id => 451485}
    }

    REGEX_LIST = {:horse_racing => Regexp.union([
                                                    /TO BE PLACED/,
                                                    /Match Bets/,
                                                    /Reverse Forecast /,
                                                    /Forecast Betting /,
                                                    /Will Racing Go Ahead?/,
                                                    /(W\/O)/,
                                                    /Daily Win Dist Odds/
                                                ])}

    def self.find_results_for(codes_hash)
      new(codes_hash)
    end

    def outright_winners
      feed.entries.collect do |entry|
        Result.new(clean_summary_string(entry.summary),
                   get_date_time(entry.title),
                   get_venue_string(entry.title)) if !entry.title.match(REGEX_LIST[:horse_racing])
      end.compact
    end

    private

    def self.method_missing(meth, *args, &block)
      key = meth.to_s.split("get_")[1].to_sym
      if meth.to_s =~ /^get_(.+)$/ && RSS_CODES[key]
        find_results_for(RSS_CODES[key])
      else
        super
      end
    end

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
