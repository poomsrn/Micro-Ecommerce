class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[ login add_favourite unadd_favourite ]
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :logged_in, only: %i[ show  bucket feed favourite_list order_history order_line_item]
  before_action :lock_access, only: %i[ edit index ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def search
    @items = Item.where("name LIKE ?","%"+params[:q]+"%")
    @stores = Store.where("name LIKE ?","%"+params[:q]+"%")
    if get_session
      @user = User.find(get_session)
    else
      redirect_to main_path
    end
  end

  # def login_first
  #   if !(get_session && get_session == @user.i
  #   session[:user_id] = nil
  # end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        Bucket.create(user_id: @user.id)
        FavouriteList.create(user_id: @user.id)
        format.html { redirect_to main_path, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def login
    @user = User.new(user_params)
    respond_to do |format|
      if @user.validate_login != false
        session[:user_id] = @user.id
        format.html { redirect_to feed_path, notice: "User was successfully login." }
      else
        session[:user_id] = nil
        format.html { render :main, status: :unprocessable_entity, notice: "Please login."}
      end
    end
  end

  def main
    session[:user_id] = nil
    session[:store_id] = nil
    @user = User.new()
  end

  def logged_in
    if(get_session)
      return true
    else
      respond_to do |format|
        format.html { redirect_to main_path, notice: "Please login." }
        format.json { render :show, status: :created, location: @user }
      end
    end
  end

  def get_session
    return session[:user_id]
  end

  def feed
    @add_to_cart = BucketHasItem.new
    if get_session
      @user = User.find(get_session)
    else
      redirect_to main_path
    end
  end

  def payment
    @make_order = Order.create(user_id: get_session)
    @make_order.save
    @bucket = Bucket.find_by(user_id: get_session)
    @itemsInBucket = @bucket.get_bucket_item(get_session)
    @itemsInBucket.each do |item|
      @quantity = BucketHasItem.find_by(bucket_id: @bucket.id,item_id: item.id).quantity
      if @quantity > Item.find(item.id).quantity
        @quantity = Item.find(item.id).quantity
      end
      OrderLineItem.create(order_id: @make_order.id, item_id: item.id, quantity: @quantity, soldPrice: item.price*@quantity)
      @remove_item = Item.find(item.id)
      @remove_item.quantity = @remove_item.quantity - @quantity
      @remove_item.save
    end
    BucketHasItem.where(bucket_id: @bucket.id).each do |item|
      item.destroy
    end
    redirect_to request.referrer
  end

  def bucket
    @bucket = Bucket.find_by(user_id: get_session)
    @itemsInBucket = @bucket.get_bucket_item(get_session)
    @user_id = get_session
  end

  def add_to_cart
    @quantity = add_to_bucket_params[:quantity]
    if @quantity.to_i > 0
      if !BucketHasItem.find_by(bucket_id: Bucket.find_by(user_id: get_session).id,item_id: params[:item_id])
        @addToCart = BucketHasItem.create(bucket_id: Bucket.find_by(user_id: get_session).id,item_id: params[:item_id], quantity: @quantity)
      else
         @addToCart = BucketHasItem.find_by(bucket_id: Bucket.find_by(user_id: get_session),item_id: params[:item_id])
         @addToCart.quantity = @addToCart.quantity + @quantity.to_i
      end
      if @addToCart.save
        redirect_to request.referrer, notice: "item has been added"
      else
        redirect_to request.referrer, notice: "fails to added item"
      end
    else
      redirect_to request.referrer, notice: "fails to added item"
    end
  end

  def remove_from_cart
    @quantity = add_to_bucket_params[:quantity]
    @itemBucket = BucketHasItem.find_by(bucket_id: Bucket.find_by(user_id: get_session),item_id: params[:item_id])
    if @itemBucket.quantity-@quantity.to_i == 0
      @itemBucket.destroy
    else
      @itemBucket.quantity = @itemBucket.quantity-@quantity.to_i
      @itemBucket.save
    end
    redirect_to request.referrer, notice: "item has decrease"
  end

  # def update_to_cart
  #   @updateToCart = BucketHasItem.find_by(bucket_id: Bucket.find_by(user_id: get_session),item_id: params[:item_id])
  #   @quantity = add_to_bucket_params
  #   @updateToCart.quantity = @updateToCart.quantity + add_to_bucket_params[:quantity].to_i
  #   if @updateToCart.save
  #     redirect_to request.referrer
  #   else
  #     redirect_to main_path
  #   end
  # end

  def favourite_list
    @favourite_list = FavouriteList.find_by(user_id: get_session)
    @storesInFavouriteList = @favourite_list.get_favourite_list_stores(get_session)
    @user_id = get_session
  end

  def add_favourite
    @addFavourite = FavouriteListHasStore.create(favourite_list_id: FavouriteList.find_by(user_id: get_session).id, store_id: params[:store_id])
    if @addFavourite.save
      redirect_to request.referrer, notice: "You has been add favourite"
    else
      redirect_to main_path
    end
  end

  def unadd_favourite
    FavouriteListHasStore.find_by(favourite_list_id: FavouriteList.find_by(user_id: get_session), store_id: params[:store_id]).destroy
    redirect_to request.referrer, notice: "You has been unadd favourite"
  end

  def lock_access
    respond_to do |format|
      format.html { redirect_to main_path, notice: "You are not allow to access." }
    end
  end

  def order_history
    @user_id = get_session
    @order_id = Order.where(user_id: @user_id).pluck("id")
    @orders = []
    @order_id.each do |id|
      @orders.push(Order.find_by(id:id))
    end
  end

  def order_line_item
    @order = Order.find(params[:order_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :email, :name, :address, :phone, :gender, :birthdate)
    end

    def add_to_bucket_params
      params.require(:bucket_has_item).permit(:quantity)
    end
end
