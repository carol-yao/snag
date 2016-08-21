class Result < ActiveRecord::Base

require 'indico'
require 'net/http'
require 'json'

# base_uri 'reddit.com'
# model vars
Indico.api_key = "dd5e35044234093be537186e304d0531"

  def self.get_tweets(term = "#banks OR #finance OR #investment OR #banking OR #accounts OR #stocks OR #assets OR #reinvest OR #invest OR #bank OR #money")
    Result.delete_all

    client = Twitter::REST::Client.new do |config|
      config.consumer_key    = "vYjNKR8TyCYEfJpDM1Dro4aiM"
      config.consumer_secret = "CJhHRTELfXXr2Ud2nGcc3hPeQTiUx6dfQ0CAEGO6LGRRoHQdmf"
    end

    tweet_array = []

    client.search(term, geocode: "43.6521,79.3832,1000mi").each do |tweet|

      puts check_for_keywords(tweet.text)
      puts filter_emotions(tweet.text)

      if check_for_keywords(tweet.text) && (filter_emotions(tweet.text))
        tweet_array << {message: tweet.text, date: tweet.created_at, username: tweet.user.name}
      end
    end

    puts tweet_array
    save_relevent_messages(tweet_array)
  end

  def self.get_subreddit
    uri = URI.parse("https://www.reddit.com/r/personalfinance.json")
    params = { :limit => 100, :page => 3 }
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)
    puts res.body if res.is_a?(Net::HTTPSuccess)
    # response = Net::HTTP.post_form(uri, {"search" => "invest"})
  end

  def self.check_for_keywords(string)
    # get result from indico

    begin
      result = Indico.keywords(string, {version: 2})
    rescue
      puts "could not parse that (keywords)"
    else
      puts 'end'
      puts result

      # get keywords
      keywords = ["banks", "finance", "bank", "TFSA", "RRSP", "Spousal RRSP", "RRIF", "Spousal RRIF", "GRSP", "RESP", "Corporate", "LIRA", "Joint", "Portfolio rebalancing", "Tax loss harvesting",
                  "Reinvesting dividends", "Compound interest"]

      # return true if the keyword exists, else return false
      result.each do |key, value|
        if keywords.include?(key)
          return true
        end
      end
      return false
    end
  end

  def self.add_text_tags(string)
    begin
      result = Indico.text_tags(string, {top_n: 1})
      puts result
    rescue
      puts "No valid text tag"
    else
      return result.keys.join("")
    end
  end

  def self.check_for_politics(string)
    # get result from indico
    begin
      result = Indico.political(string)
    rescue
      puts "could not parse that (politics)"
    else
      if result["liberal"]
        return true
      end
      return false
    end
  end

  def self.filter_emotions(string)

    keywords = ["anger", "fear", "sadness"]

    begin
      result = Indico.emotion(string, {top_n: 3});
    rescue
      puts "could not parse that (emotions)"
    else
      result.each do |k, v|
        until keywords.include?(k) do
          puts result
          return false
        end
      end
      puts result
      return true
    end
  end


  def self.save_relevent_messages(messages)

    messages.each do |x|

      text_tags = add_text_tags(x[:message])
      Result.create(message: x[:message], date: x[:date], username: x[:username], text_tags: text_tags)
      puts 'stored'

    end
  end

end
