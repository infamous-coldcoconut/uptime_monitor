class AddUniqueIndicesToSites < ActiveRecord::Migration[8.1]
  def change
    add_index :sites, :url, unique: true
    add_index :sites, :name, unique: true
  end
end
