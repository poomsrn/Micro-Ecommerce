class User < ApplicationRecord
	validates :email,:username,uniqueness:true
	validates :email,:username,:password,presence:true
	has_secure_password
	validates_confirmation_of :password
	has_many :orders
	has_many :ratings
	has_one :bucket
	has_one :favourite_list

	validate :validate_login, on: [:login]
	def validate_login
		@user = User.find_by(username:self.username)
		if (@user && @user.authenticate(self.password))
			return self.id = @user.id
		else
			errors.add(:username,message:"Invalid username or password !!.")
			errors.add(:password,message:"Invalid username or password !!.")
			return false
		end
	end
end
