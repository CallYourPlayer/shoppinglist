class ShoppingsController < ApplicationController
  def index
    @shoppings = Shopping.all
  end

  def show
    @shopping = Shopping.find(params[:id])
  end

  def new
    @shopping = Shopping.new
    @shopping.date_shopping = Time.now
    @shopping.status='nuovo'
    if @shopping.save
      redirect_to edit_shopping_path(@shopping)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create 
    @shopping = Shopping.new
    @shopping.date_shopping = Time.now
    @shopping.status='nuovo'
    if @shopping.save
      redirect_to @shopping
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @shopping = Shopping.find(params[:id])
    #@item = @shopping.items.new
  end

  def update
    @shopping = Shopping.find(params[:id])

    if @shopping.update(shopping_params)
      redirect_to @shoppings
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shopping = Shopping.find(params[:id])
    @shopping.destroy

    redirect_to root_path, status: :see_other
  end

  def archive
    @shopping = Shopping.find(params[:my][:id])
    @shopping.status = "pagato"
    if @shopping.save
      redirect_to @shopping
    else
      render :new, status: :unprocessable_entity
    end
  end

  private 
  def shopping_params
    params.require(:shopping).permit(:date_shopping, :total_price, :status)
  end
end
