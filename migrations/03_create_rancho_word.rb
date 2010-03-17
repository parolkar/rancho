class CreateRanchoWord < ActiveRecord::Migration
  def self.up
    create_table :rancho_words do |t|
      t.string :stem

      t.timestamps
    end
    add_index :rancho_words, :stem
  end

  def self.down
    drop_table :rancho_words
  end
end
