require "application_system_test_case"

class ItemsTest < ApplicationSystemTestCase
  setup do
    # @item = items(:one)
    # @bucket1 = buckets(:bucket1)
  end

#   test "visiting the index" do
#     visit items_url
#     assert_selector "h1", text: "Items"
#   end

#   test "creating a Item" do
#     visit items_url
#     click_on "New Item"

#     fill_in "Description", with: @item.description
#     fill_in "Name", with: @item.name
#     fill_in "Price", with: @item.price
#     click_on "Create Item"

#     assert_text "Item was successfully created"
#     click_on "Back"
#   end

#   test "updating a Item" do
#     visit items_url
#     click_on "Edit", match: :first

#     fill_in "Description", with: @item.description
#     fill_in "Name", with: @item.name
#     fill_in "Price", with: @item.price
#     click_on "Update Item"

#     assert_text "Item was successfully updated"
#     click_on "Back"
#   end

#   test "destroying a Item" do
#     visit items_url
#     page.accept_confirm do
#       click_on "Destroy", match: :first
#     end

#     assert_text "Item was successfully destroyed"

  test "adding item" do
    visit store_login_path
    fill_in "Name", with: 's1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "Add item"
    fill_in "Name", with: 'eggs'
    fill_in "Price", with: '20'
    fill_in "Quantity", with: '5'
    fill_in "Description", with: 'fresh eggs'
    click_on "OK"
    assert_text "Item was successfully created."
  end

  test "adding stock" do
    visit store_login_path
    fill_in "Name", with: 's1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "Add item"
    fill_in "Name", with: 'eggs'
    fill_in "Price", with: '20'
    fill_in "Quantity", with: '5'
    fill_in "Description", with: 'fresh eggs'
    click_on "OK"
    assert_text "Item was successfully created."
    click_on "+"
    fill_in "Quantity", with: '2'
    click_on "Update"
    assert_text "add stock quantity success"
    assert_text "7"
  end

  test "remove stock" do
    visit store_login_path
    fill_in "Name", with: 's1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "Add item"
    fill_in "Name", with: 'eggs'
    fill_in "Price", with: '20'
    fill_in "Quantity", with: '5'
    fill_in "Description", with: 'fresh eggs'
    click_on "OK"
    assert_text "Item was successfully created."
    click_on "-"
    fill_in "Quantity", with: '2'
    click_on "Remove"
    assert_text "remove stock quantity success"
    assert_text "3"
  end

  test "edit stock" do
    visit store_login_path
    fill_in "Name", with: 's1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "Add item"
    fill_in "Name", with: 'eggs'
    fill_in "Price", with: '20'
    fill_in "Quantity", with: '5'
    fill_in "Description", with: 'fresh eggs'
    click_on "OK"
    assert_text "Item was successfully created."
    click_on "edit"
    fill_in "Name", with: 'chicken'
    click_on "OK"
    assert_text "Item was successfully updated."
    assert_text "chicken"
  end

  test "buy stock" do
    visit store_login_path
    fill_in "Name", with: 's1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "Add item"
    fill_in "Name", with: 'eggs'
    fill_in "Price", with: '20'
    fill_in "Quantity", with: '5'
    fill_in "Description", with: 'fresh eggs'
    click_on "OK"
    assert_text "Item was successfully created."
    click_on "logout"
    visit main_path
    fill_in "Username", with: 'p1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "+"
    fill_in "Quantity", with: '2'
    click_on "Update"
    click_on "Cart"
    click_on "pay"
    assert_text "total price: 40.0 baht"
    click_on "confirm"
    click_on "History"
    assert_text "1"
    click_on "see"
    assert_text "eggs"
    click_on "logout"
    visit store_login_path
    fill_in "Name", with: 's1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "History"
    assert_text "1"
    assert_text "eggs"
    assert_text "2"
    assert_text "40.0"
  end

  test "add more in cart" do
    visit store_login_path
    fill_in "Name", with: 's1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "Add item"
    fill_in "Name", with: 'eggs'
    fill_in "Price", with: '20'
    fill_in "Quantity", with: '5'
    fill_in "Description", with: 'fresh eggs'
    click_on "OK"
    assert_text "Item was successfully created."
    click_on "logout"
    visit main_path
    fill_in "Username", with: 'p1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "+"
    fill_in "Quantity", with: '2'
    click_on "Update"
    click_on "Cart"
    click_on "+"
    fill_in "Quantity", with: '1'
    click_on "Update"
    assert_text "item has been added"
    assert_text "3"
  end

  test "remove in cart" do
    visit store_login_path
    fill_in "Name", with: 's1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "Add item"
    fill_in "Name", with: 'eggs'
    fill_in "Price", with: '20'
    fill_in "Quantity", with: '5'
    fill_in "Description", with: 'fresh eggs'
    click_on "OK"
    assert_text "Item was successfully created."
    click_on "logout"
    visit main_path
    fill_in "Username", with: 'p1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "+"
    fill_in "Quantity", with: '2'
    click_on "Update"
    click_on "Cart"
    click_on "-"
    fill_in "Quantity", with: '1'
    click_on "Remove"
    assert_text "item has decrease"
    assert_text "1"
  end

  test "decrease item equal stock" do
    visit store_login_path
    fill_in "Name", with: 's1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "Add item"
    fill_in "Name", with: 'eggs'
    fill_in "Price", with: '20'
    fill_in "Quantity", with: '5'
    fill_in "Description", with: 'fresh eggs'
    click_on "OK"
    assert_text "Item was successfully created."
    click_on "logout"
    visit main_path
    fill_in "Username", with: 'p1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "+"
    fill_in "Quantity", with: '4'
    click_on "Update"
    click_on "logout"
    visit main_path
    fill_in "Username", with: 'p2'
    fill_in "Password", with: '456'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "+"
    fill_in "Quantity", with: '4'
    click_on "Update"
    click_on "Cart"
    click_on "pay"
    assert_text "total price: 80.0 baht"
    click_on "confirm"
    click_on "History"
    click_on "see"
    assert_text "eggs"
    click_on "logout"
    visit main_path
    fill_in "Username", with: 'p1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "Cart"
    assert_text "eggs"
    assert_text "1"
    click_on "pay"
    assert_text "total price: 20.0 baht"
    click_on "confirm"
    click_on "History"
    click_on "see"
    assert_text "eggs"
  end
end
