class CreateRanchoContentPointer < ActiveRecord::Migration
  def self.up
    create_table :rancho_content_pointers do |t|
      t.integer :content_id
      t.string  :content_type       
      t.timestamps
    end
    add_index :rancho_content_pointers, :content_id   
    add_index :rancho_content_pointers, :content_type 
  end

  def self.down
    drop_table :rancho_content_pointers
  end
end
