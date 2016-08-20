class Result < ActiveRecord::Base

require 'indico'

def filter_by_keywords
  Indico.api_key = ENV['figaro_api_key']
  result = Indico.keywords("These banks are terrible", {version: 2});
  console.log(result);
end

def filter_emotions
  Indico.api_key = ENV['figaro_api_key']
  result = Indico.emotions("I hate banks", {version: 2});
  console.log(result);
end

end
