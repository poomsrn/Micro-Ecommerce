class Item < ApplicationRecord
	has_many :bucket_has_items
	has_many :favourite_list
	has_many :tags
	belongs_to :store
	has_many :order_line_items
	has_one_attached :avatar
	after_commit :add_default_avatar, on: %i[create update]

	def show_tag(item_id)
  		tag_name = []
  		Tag.where(item_id: item_id).each do |tag|
  			tag_name.push(tag.name)
  		end
  		return tag_name.join(", ")
  	end

  	private
  	def add_default_avatar
  		unless avatar.attached?
  			avatar.attach(
  				io: File.open(
  					Rails.root.join(
  						'app', 'assets', 'images', 'no-image.jpg'
  						)
  					),filename: 'no-image.jpg',
  					content_type: 'image/jpg'
  				)
  			
  		end
  	end
end
