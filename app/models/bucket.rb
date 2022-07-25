class Bucket < ApplicationRecord
  belongs_to :user
  has_many :bucket_has_items
  has_many :item

  def get_bucket_item(session)
    item_id = BucketHasItem.where(bucket_id: Bucket.find_by(user_id: session).id).pluck("item_id")
    items = []
    item_id.each do |id|
      items.push(Item.find(id))
    end
    return items
  end
end
