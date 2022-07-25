require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user1 = users(:user1)
    @user2 = users(:user2)
    @fav1 = favourite_lists(:fav1)
    @fav2 = favourite_lists(:fav2)
  end

  # test "visiting the index" do
  #   visit users_url
  #   assert_selector "h1", text: "Users"
  # end

  # test "creating a User" do
  #   visit users_url
  #   click_on "New User"

  #   fill_in "Address", with: @user.address
  #   fill_in "Birthdate", with: @user.birthdate
  #   fill_in "Email", with: @user.email
  #   fill_in "Gender", with: @user.gender
  #   fill_in "Name", with: @user.name
  #   fill_in "Password digest", with: @user.password_digest
  #   fill_in "Phone", with: @user.phone
  #   fill_in "Username", with: @user.username
  #   click_on "Create User"

  #   assert_text "User was successfully created"
  #   click_on "Back"
  # end

  # test "updating a User" do
  #   visit users_url
  #   click_on "Edit", match: :first

  #   fill_in "Address", with: @user.address
  #   fill_in "Birthdate", with: @user.birthdate
  #   fill_in "Email", with: @user.email
  #   fill_in "Gender", with: @user.gender
  #   fill_in "Name", with: @user.name
  #   fill_in "Password digest", with: @user.password_digest
  #   fill_in "Phone", with: @user.phone
  #   fill_in "Username", with: @user.username
  #   click_on "Update User"

  #   assert_text "User was successfully updated"
  #   click_on "Back"
  # end

  # test "destroying a User" do
  #   visit users_url
  #   page.accept_confirm do
  #     click_on "Destroy", match: :first
  #   end

  #   assert_text "User was successfully destroyed"
  # end

  test "register success" do
    visit main_path
    click_on "Register"
    fill_in "Username", with: "p3"
    fill_in "Password *", with: "123"
    fill_in "Password confirmation", with: "123"
    fill_in "Email", with: "p3"
    fill_in "Address", with: "poom"
    fill_in "Phone", with: "456"
    fill_in "Gender", with: "male"
    click_on "OK"
    assert_text "User was successfully created."
  end

  test "register fail" do
    visit main_path
    click_on "Register"
    fill_in "Username", with: "p3"
    fill_in "Password *", with: "123"
    fill_in "Password confirmation", with: "111"
    fill_in "Email", with: "p3"
    fill_in "Address", with: "poom"
    fill_in "Phone", with: "456"
    fill_in "Gender", with: "male"
    click_on "OK"
    assert_text "Password confirmation doesn't match Password"
  end

  test "login_fail" do
    visit main_path
    fill_in "Username", with: 'p1'
    fill_in "Password", with: '111'
    click_on "Login"
    assert_text "Username Invalid username or password !!."
  end

  test "login_success" do
    visit main_path
    fill_in "Username", with: 'p2'
    fill_in "Password", with: '456'
    click_on "Login"
    assert_text "User was successfully login."
  end

  test "add_fav" do
    visit main_path
    fill_in "Username", with: 'p1'
    fill_in "Password", with: '123'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "follow"
    assert_text "You has been add favourite"
  end

  test "unadd_fav" do
    visit main_path
    fill_in "Username", with: 'p2'
    fill_in "Password", with: '456'
    click_on "Login"
    assert_text "User was successfully login."
    click_on "follow"
    click_on "unfollow"
    assert_text "You has been unadd favourite"
  end

end
