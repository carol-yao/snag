class Result < ActiveRecord::Base

require 'indico'

def filter_by_keywords
  Indico.api_key = '70fa9c87529dc0cd4e5dc150938f744e'
  result = Indico.keywords("These banks are terrible", {version: 2});
  console.log(result);
end

def self.filter_emotions(message)
  Indico.api_key = '70fa9c87529dc0cd4e5dc150938f744e'
  result = Indico.emotion(message, {top_n: 1});
  puts result;

    if (result(value)) > 0.3)
      return true;
    end
  end

end
