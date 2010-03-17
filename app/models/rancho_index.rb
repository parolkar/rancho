class RanchoIndex < ActiveRecord::Base
  belongs_to :rancho_content_pointer
  belongs_to :rancho_word
end
