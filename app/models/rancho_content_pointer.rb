

class RanchoContentPointer < ActiveRecord::Base
  has_many :rancho_indexes
  has_many :rancho_words, :through => :rancho_indexes



end
