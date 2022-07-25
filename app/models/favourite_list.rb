class FavouriteList < ApplicationRecord
  belongs_to :user
  def get_favourite_list_stores(session)
    store_id = FavouriteListHasStore.where(favourite_list_id: FavouriteList.find_by(user_id: session).id).pluck("store_id")
    stores = []
    store_id.each do |id|
      stores.push(Store.find(id))
    end
    return stores
  end
end
