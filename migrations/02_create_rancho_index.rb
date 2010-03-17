class CreateRanchoIndex < ActiveRecord::Migration
  def self.up
    create_table :rancho_indexes do |t|
      t.references :rancho_content_pointer
      t.references :rancho_word
      t.integer :position       
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10

      #t.timestamps
    end
    add_index :rancho_indexes, :rancho_content_pointer_id
    add_index :rancho_indexes, :rancho_word_id
    add_index :rancho_indexes, [:rancho_word_id, :rancho_content_pointer_id]
  end

  def self.down
    drop_table :rancho_indexes
  end
end
