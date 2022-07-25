class CreateBucketHasItems < ActiveRecord::Migration[6.1]
  def change
    create_table :bucket_has_items do |t|
      t.references :bucket, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :quantity
      t.timestamps
    end
  end
end
