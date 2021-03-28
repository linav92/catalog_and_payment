class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
   #@order = Order.new(order_params)
   
   @order= Order.new()
   @product = Product.find(params[:product_id])
   @order.number=params[:number]
   @order.product_id = @product.id
   @order.payment_id =

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def pago
    @data = params[:order]
  end

  def met_pago
    @data = params

    p "AQYUUii",@data
    @order = Order.new
    @order.number = params[:number]
    @order.client_id = 1
    @order.product_id = params[:product_id]
    @order.payment_id = params[:payment_id]
    @order.method_payment_id = params[:method_id]
    @order.save()

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully success." }
    
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:number,  :product_id)
    end
end
