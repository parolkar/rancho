#require 'stemmer'
class Lukup

  
  def search(for_text)
    # do the basic work here and then call rank
  end

  def rank
    merge_rankings(frequency_ranking, word_distance_ranking, geo_distance_ranking)
  end
    
  def frequency_ranking
   return {}
  end  
  
  def word_distance_ranking
    return {}
  end
  
  def merge_rankings(*rankings)
    r = {}
    rankings.each { |ranking| r.merge!(ranking) { |key, oldval, newval| oldval + newval} }
    r.sort {|a,b| b[1]<=>a[1]}    
  end
end
