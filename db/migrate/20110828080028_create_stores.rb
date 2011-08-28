class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name, :null => false
      t.string :address, :null => false
      t.string :latitude, :null => false
      t.string :longitude, :null => false
      t.string :picture

      t.timestamps
    end
  end
end
