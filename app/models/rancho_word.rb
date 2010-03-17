class RanchoWord < ActiveRecord::Base
  has_many :rancho_indexes
  has_many :rancho_content_pointer, :through => :rancho_indexes


end
