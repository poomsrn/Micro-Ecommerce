class FavouriteListHasStore < ApplicationRecord
  belongs_to :favourite_list
  belongs_to :store
end
