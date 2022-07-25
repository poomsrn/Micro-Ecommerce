class CreateFavouriteListHasStores < ActiveRecord::Migration[6.1]
  def change
    create_table :favourite_list_has_stores do |t|
      t.references :favourite_list, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
