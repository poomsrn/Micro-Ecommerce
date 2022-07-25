# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
p1 = User.create(username: "p1",password: "123", email: "p1", name: "p1", address: "p1", phone: "123",gender: "male")
p1.save
p2 = User.create(username: "p2",password: "123", email: "p2", name: "p2", address: "p2", phone: "123",gender: "male")
p2.save

Store.destroy_all
s1 = Store.create(name: "s1",password: "123", address: "ss")
s1.save
s2 = Store.create(name: "s2",password: "123", address: "ss")
s2.save

Item.destroy_all
i1 = Item.create(name: "eggs",price: 120, quantity: 2,description: "fresh eegs", store_id: s1.id)
i1.save
i2 = Item.create(name: "melon",price: 130, quantity: 3, description: "sweet melon", store_id: s2.id)
i2.save
i3 = Item.create(name: "meat",price: 140, quantity: 1, description: "tender meat", store_id: s1.id)
i3.save
i4 = Item.create(name: "ipad",price: 570, quantity: 5, description: "cheap genuine 100%", store_id: s2.id)
i4.save
i5 = Item.create(name: "water",price: 200, quantity: 2, description: "water", store_id: s1.id)
i5.save

Bucket.destroy_all
h1 = Bucket.create(user_id: User.first.id)
h1.save
h2 = Bucket.create(user_id: User.second.id)
h2.save

BucketHasItem.destroy_all
bi1 = BucketHasItem.create(bucket_id: Bucket.first.id, item_id: Item.first.id, quantity: 1)
bi1.save
bi2 = BucketHasItem.create(bucket_id: Bucket.first.id, item_id: Item.second.id, quantity: 2)
bi2.save

FavouriteList.destroy_all
fl1 = FavouriteList.create(user_id: User.first.id)
fl1.save
fl2 = FavouriteList.create(user_id: User.second.id)
fl2.save

FavouriteListHasStore.destroy_all
flh1 = FavouriteListHasStore.create(favourite_list_id: FavouriteList.first.id, store_id: Store.first.id)
flh1.save
flh2 = FavouriteListHasStore.create(favourite_list_id: FavouriteList.first.id, store_id: Store.second.id)
flh2.save

Tag.destroy_all
t1 = Tag.create(item_id: Item.first.id, name: "food")
t1.save
t2 = Tag.create(item_id: Item.second.id, name: "food")
t2.save
t3 = Tag.create(item_id: Item.third.id, name: "food")
t3.save
t4 = Tag.create(item_id: Item.fourth.id, name: "electronic")
t4.save
t5 = Tag.create(item_id: Item.fifth.id, name: "food")
t5.save

Rate.destroy_all
r1 = Rate.create(user_id: User.first.id, store_id: Store.first.id, rate_score: 3, comment: "bad service")
r1.save
r2 = Rate.create(user_id: User.second.id, store_id: Store.first.id, rate_score: 4, comment: "fast deliver")
r2.save