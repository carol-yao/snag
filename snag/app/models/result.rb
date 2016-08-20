class Result < ActiveRecord::Base

require 'indico'

# model vars
Indico.api_key = "dd5e35044234093be537186e304d0531"
keywords = ["banks", "terrible", "finance"]

  def self.check_for_keywords(string)
    # get result from indico
    result = Indico.keywords(string, {version: 2})
    puts result

    # return true if the keyword exists, else return false
    result.each do |key, value|
      if keywords.include?(key) && value > 0.5
        return true
      end
    end
    return false
  end

  def self.check_for_politics(string)
    # get result from indico
    result = Indico.political(string)
    puts result

    if result["liberal"] > 0.3
      return true
    end
    return false
  end

  def self.filter_emotions(message)
    result = Indico.emotion(message, {top_n: 1});
    puts result;
  end


  def save_relevent_messages(messages)
    messages.each do |x|
      Result.new(message: x.message, date: x.date, username: x.username)
    end
  end

  def self.get_tweets(term)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key    = Figaro.env.twitter_key
      config.consumer_secret = Figaro.env.twitter_secret
    end

    client.search(term, geocode: "43.6521,79.3832,1000mi").each do |tweet|
      # puts tweet.text
    end
  end


end
