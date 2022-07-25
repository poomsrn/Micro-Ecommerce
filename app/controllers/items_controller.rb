class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :lock_access, only: %i[ index destroy]
  before_action :logged_in, only: %i[ show edit new update]
  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
    @store = Store.find(session[:store_id])
    if !@store.items.find_by(id: params[:id])
      redirect_to main_path, notice: "You are not allow access"
    end
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
    @item.store_id = session[:store_id]
    respond_to do |format|
      if @item.save
        format.html { redirect_to "/store", notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to "/store", notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def logged_in
    if(session[:store_id])
      return true
    else
      respond_to do |format|
        format.html { redirect_to main_path, notice: "Please login." }
        format.json { render :show, status: :created, location: @post }
      end
    end
  end

  def lock_access
    respond_to do |format|
      format.html { redirect_to main_path, notice: "You are not allow to access." }
      format.json { render :show, status: :created, location: @post }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :price, :quantity,:description, :avatar)
    end
end
