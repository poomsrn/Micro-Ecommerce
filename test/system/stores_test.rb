require "application_system_test_case"

class StoresTest < ApplicationSystemTestCase
  setup do
    @store1 = stores(:store1)
  end

  # test "visiting the index" do
  #   visit stores_url
  #   assert_selector "h1", text: "Stores"
  # end

  # test "creating a Store" do
  #   visit stores_url
  #   click_on "New Store"

  #   fill_in "Address", with: @store.address
  #   fill_in "Joindate", with: @store.joinDate
  #   fill_in "Name", with: @store.name
  #   fill_in "Password digest", with: @store.password_digest
  #   click_on "Create Store"

  #   assert_text "Store was successfully created"
  #   click_on "Back"
  # end

  # test "updating a Store" do
  #   visit stores_url
  #   click_on "Edit", match: :first

  #   fill_in "Address", with: @store.address
  #   fill_in "Joindate", with: @store.joinDate
  #   fill_in "Name", with: @store.name
  #   fill_in "Password digest", with: @store.password_digest
  #   click_on "Update Store"

  #   assert_text "Store was successfully updated"
  #   click_on "Back"
  # end

  # test "destroying a Store" do
  #   visit stores_url
  #   page.accept_confirm do
  #     click_on "Destroy", match: :first
  #   end

  #   assert_text "Store was successfully destroyed"
  # end

  test "register success" do
    visit store_login_path
    click_on "Register"
    fill_in "Name", with: "s3"
    fill_in "Password *", with: "123"
    fill_in "Password confirmation", with: "123"
    fill_in "Address", with: "new york"
    click_on "OK"
    assert_text "Store was successfully created."
  end

  test "register fail" do
    visit store_login_path
    click_on "Register"
    fill_in "Name", with: "s3"
    fill_in "Password *", with: "123"
    fill_in "Password confirmation", with: "111"
    fill_in "Address", with: "new york"
    click_on "OK"
    assert_text "Password confirmation doesn't match Password"
  end

  test "login_fail" do
    visit store_login_path
    fill_in "Name", with: 's1'
    fill_in "Password", with: '111'
    click_on "Login"
    assert_text "Name Invalid name or password !!."
  end

  test "login_success" do
    visit store_login_path
    fill_in "Name", with: 's1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
  end

  test "review store" do
    visit main_path
    fill_in "Username", with: 'p1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "review"
    fill_in "Rate score", with: '4'
    fill_in "Comment", with: 'good service'
    click_on "send" 
    assert_text "review has been send"
    assert_text "core: 4.0"
    visit "/stores/#{@store1.id}"
    assert_text "Score: 4.0"
    assert_text "good service"
  end

end
