
class Lukup
  def search(for_text,lat,lng,rad)  
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
	     @lat_val=lat
	     @lng_val=lng
	     @rad_val=rad
	     @rad_val=1 if (@rad_val==nil)
       @search_words.empty? ? [] : rank()
  end

  def rank
    merge_rankings(frequency_ranking, word_distance_ranking , geo_distance_ranking) 
  end
    
  def frequency_ranking
    freq_sql= "select ri0.rancho_content_pointer_id, count(ri0.rancho_content_pointer_id) as count #{@common_select} order by count desc"
    puts "Here is the query for frequency ranking \n #{freq_sql} \n"
    list = RanchoIndex.find_by_sql(freq_sql)
    rank = {}

    list.size.times { |i| rank[list[i].rancho_content_pointer_id.to_s] = list[i].count.to_f/list[0].count.to_f }

    return rank
  end  
  
  def word_distance_ranking
   return {} if @search_words.size == 1
    dist, total = [], []
    @search_words.each_with_index { |w, index| total << "ri#{index}.position" }
    total.size.times { |index| dist << "abs(#{total[index]} - #{total[index + 1]})" unless index == total.size - 1 }
    dist_sql = "select ri0.rancho_content_pointer_id, (#{dist.join(' + ')}) as dist #{@common_select} order by dist asc"
    puts "Here is the query for word distance ranking \n #{dist_sql} \n"
    list = RanchoWord.find_by_sql(dist_sql)
    rank = Hash.new
    list.size.times { |i| rank[list[i].rancho_content_pointer_id.to_s] = list[0].dist.to_f/list[i].dist.to_f }
    #p rank
    return rank
  end     
  
  def geo_distance_ranking
    geo_sql= "SELECT ri0.rancho_content_pointer_id, ( 3959 * acos( cos( radians( #{@lat_val} ) ) * cos( radians( ri0.lat ) ) * cos( radians( ri0.lng ) - radians( #{@lng_val} ) ) + sin( radians( #{@lat_val} ) ) * sin( radians( ri0.lat ) ) ) ) AS distance  #{@common_select} HAVING distance < #{@rad_val} ORDER BY distance ASC"
	  puts "Here is the query for geodistance ranking \n #{geo_sql} \n"
	  dist = RanchoIndex.find_by_sql(geo_sql)
	  geo = {}
	  geo_dist = []
  	dist.size.times { |i| geo_dist << 1.0 / dist[i].distance.to_f }
 	  rank = {}
  	dist.size.times { |i| rank[dist[i].rancho_content_pointer_id.to_s] = geo_dist[i].to_f/	geo_dist[0].to_f }
	  #p rank
	  rank.each { |key, val|  rank[key] = val*2 }	
	  #p rank
  	return rank
  end
  
  def merge_rankings(*rankings)
    r = {}
    rankings.each { |ranking| r.merge!(ranking) { |key, oldval, newval| oldval + newval} }
    r.sort {|a,b| b[1]<=>a[1]}    
  end
end
