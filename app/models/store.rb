class Store < ApplicationRecord
	has_many :items
	has_many :order_line_items, through: :item
	validates :name,uniqueness:true
	validates :name,:password,presence:true
	has_secure_password
	validates_confirmation_of :password

	validate :validate_login, on: [:login]
	def validate_login
		@store = Store.find_by(name:self.name)
		if (@store && @store.authenticate(self.password))
			return self.id = @store.id
		else
			errors.add(:name,message:"Invalid name or password !!.")
			errors.add(:password,message:"Invalid name or password !!.")
			return false
		end
	end

	def calculate_score(store_id)
	    total = 0
	    count = 0
	    Rate.where(store_id: store_id).each do |review|
	      count += 1
	      total += review.rate_score
	    end
	    if count == 0 
	    	return 0
	    else
	    return (total.to_f/count.to_f).round(2)
		end
  	end
end
