require 'stemmer'
class Indexer
 def self.index(content)
   content_string = content.body
   content_string.stemmed_words.each_with_index { |w, l|
      rw= RanchoWord.find_or_create_by_stem(w)
      rcp = RanchoContentPointer.find_or_create_by_content_id_and_content_type(content.id, content.class.to_s )
      ri = RanchoIndex.new
      ri.rancho_content_pointer = rcp
      ri.rancho_word = rw
      ri.position = l
      ri.lat = content.location.lat
      ri.lng = content.location.lng
      ri.save
      
   }
   

 end 
end
