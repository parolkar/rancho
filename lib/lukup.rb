
class Lukup

  
  def search(for_text)  
        words_conditions = []
        for_text.stemmed_words.each { |param| words_conditions << "stem = '#{param}'" }
        word_sql = "select * from rancho_words where #{words_conditions.join(" or ")}"
        @search_words = RanchoWord.find_by_sql(word_sql)
        tables, joins, ids = [], [], []
        @search_words.each_with_index { |w, index|
          tables << "rancho_indices ri#{index}"
          joins << "ri#{index}.rancho_content_pointer_id = ri#{index+1}.rancho_content_pointer_id"
          ids << "ri#{index}.rancho_word_id = #{w.id}"
        }
        joins.pop
        @common_select = "from #{tables.join(', ')} where #{(joins + ids).join(' and ')} group by ri0.rancho_content_pointer_id"
        @search_words.empty? ? [] : rank()
  end

  def rank
    merge_rankings(frequency_ranking, word_distance_ranking, geo_distance_ranking)
  end
    
  def frequency_ranking
    freq_sql= "select ri0.rancho_content_pointer_id, count(ri0.rancho_content_pointer_id) as count #{@common_select} order by count desc"
    puts "Here is the query for frequency ranking \n #{freq_sql} \n"
    list = RanchoIndex.find_by_sql(freq_sql)
    rank = {}
    list.size.times { |i| rank[list[i].rancho_content_pointer_id] = list[i].count.to_f/list[0].count.to_f }
    return rank
  end  
  
  def word_distance_ranking
    return {}
  end     
  
  def geo_distance_ranking
    return {}
  end
  
  def merge_rankings(*rankings)
    r = {}
    rankings.each { |ranking| r.merge!(ranking) { |key, oldval, newval| oldval + newval} }
    r.sort {|a,b| b[1]<=>a[1]}    
  end
end
