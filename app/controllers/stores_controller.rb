class StoresController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[ login ]
  before_action :set_store, only: %i[ show edit update destroy ]
  before_action :logged_in, only: %i[ edit update destroy store order_history]
  before_action :lock_access, only: %i[ edit index ]
  # GET /stores or /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1 or /stores/1.json
  def show
    @user_id = session[:user_id]
    @store_id = params[:id]
    @score = @store.calculate_score(@store_id)
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores or /stores.json
  def create
    @store = Store.new(store_params)

    respond_to do |format|
      if @store.save
        format.html { redirect_to store_login_path, notice: "Store was successfully created." }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1 or /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: "Store was successfully updated." }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def login
    @store = Store.new(store_params)
    respond_to do |format|
      if @store.validate_login != false
        session[:store_id] = @store.id
        format.html { redirect_to "/store", notice: "User was successfully login." }
      else
        session[:store_id] = nil
        format.html { render :store_login, status: :unprocessable_entity, notice: "Please login."}
      end
    end
  end

  def store_login
    session[:store_id] = nil
    session[:user_id] = nil
    @store = Store.new()
  end

  def logged_in
    if(get_session && session[:store_id])
      return true
    else
      respond_to do |format|
        format.html { redirect_to store_login_path, notice: "Please login." }
        format.json { render :show, status: :created, location: @store }
      end
    end
  end

  def store
    @store = Store.find(get_session)
    @add_tag = Tag.new
  end

  def review
    if (session[:user_id])
      @store = Store.find(params[:store_id])
      @review = Rate.new
    else
      redirect_to main_path, notice: "Please login."
    end
  end

  def rate_store
    @review = Rate.new(review_params)
    @store = Store.find(params[:store_id])
    @review.user_id = session[:user_id]
    @review.store_id = params[:store_id]
    if @review.save
      redirect_to request.referrer, notice: "review has been send"
    else
      redirect_to request.referrer, notice: "review error"
    end
  end

  def add_tag
    @add_tag = Tag.new(tag_params)
    @item_id = params[:item_id]
    @store = Store.find(session[:store_id])
    @add_tag.item_id = @item_id
    duplicate = Tag.where(item_id: @item_id).find_by(name: @add_tag.name)
    if @add_tag.name != "" && !duplicate && @add_tag.save
      redirect_to "/store", notice: "add tag success"
    else
      redirect_to "/store", notice: "add tag fails"
    end
  end

  def add_stock
    @quantity = quantity_stock_params[:quantity]
    @item = Item.find(params[:item_id])
    @item.quantity = @item.quantity + @quantity.to_i
    if @item.save
      redirect_to request.referrer, notice: "add stock quantity success"
    else
      redirect_to request.referrer, notice: "add stock quantity fails"
    end
  end

  def remove_stock
    @quantity = quantity_stock_params[:quantity]
    @item = Item.find(params[:item_id])
    @item.quantity = @item.quantity - @quantity.to_i
    if @item.save
      redirect_to request.referrer, notice: "remove stock quantity success"
    else
      redirect_to request.referrer, notice: "remove stock quantity fails"
    end
  end

  def get_session
    return session[:store_id]
  end

  def order_history
    @store_id = get_session
    sql = <<-SQL "SELECT O.* FROM items I, order_line_items O WHERE I.id == O.item_id and I.store_id == #{@store_id} ORDER BY O.created_at DESC" 
    SQL
    @records_array = ActiveRecord::Base.connection.execute(sql)
  end

  # DELETE /stores/1 or /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: "Store was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_item
    @item_id = params[:item_id]
    @item = Item.find(@item_id)
    # OrderLineItem.where(item_id: @item.id).each do |item|
    #   item.destroy
    # end
    Tag.where(item_id: @item.id).each do |item|
      item.destroy
    end
    @item.destroy
    redirect_to request.referrer
  end

  def lock_access
    respond_to do |format|
      format.html { redirect_to main_path, notice: "You are not allow to access." }
      format.json { render :show, status: :created, location: @store }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def store_params
      params.require(:store).permit(:name, :password, :password_confirmation, :address)
    end

    def review_params
      params.require(:rate).permit(:rate_score, :comment)
    end

    def tag_params
      params.require(:tag).permit(:name)
    end

    def quantity_stock_params
      params.require(:item).permit(:quantity)
    end
end
