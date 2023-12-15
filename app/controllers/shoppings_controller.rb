class ShoppingsController < ApplicationController
  def index
    @shoppings = nil
    @date_start = params[:date_start]
    @date_end = params[:date_end]
    @period = params[:period]
    if @period.present?
      logger.debug "Period: #{@period}"
      if @period == '1'
        logger.debug "Tutte"
        @shoppings = Shopping.all.order(date_shopping: :asc)
      elsif @period == '2'
        logger.debug "Ultimi 7 giorni"
        @date_end = Date.today
        @date_start = @date_end - 7
        @shoppings = Shopping.where(:date_shopping => @date_start..@date_end).order(date_shopping: :asc)
      elsif @period == '3'
        logger.debug "Ultimi 30 giorni"
        @date_end = Date.today
        @date_start = @date_end - 30
        @shoppings = Shopping.where(:date_shopping => @date_start..@date_end).order(date_shopping: :asc)
      end
    elsif @date_start.present? && @date_end.present?
      logger.debug "Date: #{@date_start} - #{@date_end}"
      @shoppings = Shopping.where(:date_shopping => @date_start..@date_end).order(date_shopping: :asc)
    else
      logger.debug "No parametri"
      @shoppings = Shopping.all.order(date_shopping: :asc)
    end
    @result_total_price = @shoppings.sum(:total_price)
  end

  def search
    @shoppings = nil
    @today = Date.today
    @period = params[:ddl_period]
    logger.debug "Period: #{@period}"
    if @period == '1'
      logger.debug "Tutte"
      @shoppings = Shopping.all.order(date_shopping: :asc)
    elsif @period == '2'
      logger.debug "Ultimi 7 giorni"
      @sevenDaysBefore = @today - 7
      logger.debug "Data iniziale: #{@sevenDaysBefore}"
      logger.debug "Data finale: #{@today}"
      @shoppings = Shopping.where(:date_shopping => @sevenDaysBefore..@today).order(date_shopping: :asc).order(date_shopping: :asc).order(date_shopping: :asc)
    else
      logger.debug "Ultimi 30 giorni"
      @thirtyDaysBefore = @today - 30
      logger.debug "Data iniziale: #{@thirtyDaysBefore}"
      logger.debug "Data finale: #{@today}"
      @shoppings = Shopping.where(:date_shopping => @thirtyDaysBefore..@today).order(date_shopping: :asc).order(date_shopping: :asc)
    end
    @result_total_price = @shoppings.sum(:total_price)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def search_by_dates
    @shoppings = nil
    @date_start = params[:date_start]
    @date_end = params[:date_end]
    logger.debug "Date Start: #{@date_start}"
    logger.debug "Date End: #{@date_end}"
    @shoppings = Shopping.where(:date_shopping => @date_start..@date_end).order(date_shopping: :asc)
    @result_total_price = @shoppings.sum(:total_price)
    respond_to do |format|
      format.html
      format.js
    end
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
    @item = @shopping.items.new
  end

  def update
    @shopping = Shopping.find(params[:id])

    if @shopping.update(shopping_params)
      redirect_to @shopping
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
