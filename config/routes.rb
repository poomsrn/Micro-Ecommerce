Rails.application.routes.draw do
  resources :items
  resources :stores
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "main" ,to: "users#main"
  post "main" ,to: "users#login"
  get "store_login" ,to: "stores#store_login"
  post "store_login" ,to: "stores#login"
  get "register" ,to: "users#new"
  get "register_for_store", to: "stores#new"
  get "feed", to: "users#feed"
  get "store", to: "stores#store"
  get "bucket", to: "users#bucket"
  get "favourite_list", to: "users#favourite_list"
  get "order_history", to: "users#order_history"
  get "order_history_store", to: "stores#order_history"
  get "order_line_item/:order_id", to: "users#order_line_item"
  get "review/:store_id", to: "stores#review"
  get "search", to: "users#search"
  post "order_line_item/:order_id", to: "users#order_line_item"
  post "add_favourite/:store_id", to: "users#add_favourite"
  post "unadd_favourite/:store_id", to: "users#unadd_favourite"
  post "add_to_cart/:item_id", to: "users#add_to_cart"
  post "remove_from_cart/:item_id", to: "users#remove_from_cart"
  post "payment", to: "users#payment"
  post "add_item/:store_id", to: "items#add_item"
  post "add_stock/:item_id", to: "stores#add_stock"
  post "remove_stock/:item_id", to: "stores#remove_stock"
  post "rate_store/:store_id", to: "stores#rate_store"
  post "add_tag/:item_id", to: "stores#add_tag"
  post "delete_item/:item_id", to: "stores#delete_item"
  # patch "update_to_cart/:item_id", to: "users#update_to_cart"
end
