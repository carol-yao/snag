class Result < ActiveRecord::Base

require 'indico'

def filter_by_keywords
  Indico.api_key = ENV['figaro_api_key']
  result = Indico.keywords("These banks are terrible", {version: 2});
  console.log(result);
end

  def self.get_tweets(term)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key    = Figaro.env.twitter_key
      config.consumer_secret = Figaro.env.twitter_secret
    end

    client.search(term).each do |tweet|
      puts tweet.text
    end
  end

end
