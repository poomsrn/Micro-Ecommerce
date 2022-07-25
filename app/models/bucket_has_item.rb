class BucketHasItem < ApplicationRecord
  belongs_to :bucket
  belongs_to :item

  has_many :items

end
