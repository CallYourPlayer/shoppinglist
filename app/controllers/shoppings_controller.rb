class ShoppingsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource except: [:search, :search_by_dates]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def index
    @shoppings = Shopping.where(:user_id => current_user.id).order(date_shopping: :asc)
    @result_total_price = @shoppings.sum(:total_price)
  end

  def search
    @shoppings = nil
    @errMsg = ''
    logger.debug "Dentro Search"
    @period = params[:period]
    if @period.present?
      logger.debug "Period: #{@period}"
      if @period == '1'
        logger.debug "Tutte"
        @shoppings = Shopping.where(:user_id => current_user.id).order(date_shopping: :asc)
      elsif @period == '2'
        logger.debug "Ultimi 7 giorni"
        @date_end = Date.today
        @date_start = @date_end - 7
        @shoppings = Shopping.where(:user_id => current_user.id).where(:date_shopping => @date_start..@date_end).order(date_shopping: :asc)
      elsif @period == '3'
        logger.debug "Ultimi 30 giorni"
        @date_end = Date.today
        @date_start = @date_end - 30
        @shoppings = Shopping.where(:user_id => current_user.id).where(:date_shopping => @date_start..@date_end).order(date_shopping: :asc)
      end
    else
      logger.debug "No parametri"
      @shoppings = Shopping.where(:user_id => current_user.id).order(date_shopping: :asc)
    end
    @result_total_price = @shoppings.sum(:total_price)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def search_by_dates
    @shoppings = nil
    @errMsg = ''
    @result_total_price = 0
    @date_start = params[:date_start]
    @date_end = params[:date_end]
    logger.debug "Date Start: #{@date_start}"
    logger.debug "Date End: #{@date_end}"
    if @date_start > @date_end
      @errMsg = 'La data iniziale non può essere maggiore della data finale'
    elsif @date_start == '' || @date_end == ''
      @errMsg = 'Specificare date inziale e finale della ricerca'
    else
      @shoppings = Shopping.where(:user_id => current_user.id).where(:date_shopping => @date_start..@date_end).order(date_shopping: :asc)
      @result_total_price = @shoppings.sum(:total_price)
      #authorize! :read, @shoppings
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  def show
    @shopping = Shopping.find(params[:id])
    authorize! :read, @shopping
  end

  def new
    @shopping = Shopping.new
    authorize! :create, @shopping
    @shopping.date_shopping = Time.now
    @shopping.status='nuovo'
    @shopping.user_id = current_user.id
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
    authorize! :update, @shopping
    @item = @shopping.items.new
    @paid_items = @shopping.items.where(:payed => true)
    @result_total_price = @paid_items.sum(:total_price)
  end

  def update
    @shopping = Shopping.find(params[:id])
    #@shopping.user_id = current_user.id
    if @shopping.update(shopping_params)
      if @shopping.status = 'pagato'
        @shopping.items.update_all(payed: true)
      end
      redirect_to @shopping
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shopping = Shopping.find(params[:id])
    authorize! :destroy, @shopping
    @shopping.destroy

    redirect_to root_path, status: :see_other
  end

  def archive
    @shopping = Shopping.find(params[:my][:id])
    authorize! :update, @shopping
    @shopping.status = "pagato"
    if @shopping.save
      redirect_to @shopping
    else
      render :new, status: :unprocessable_entity
    end
  end

  private 
  def shopping_params
    params.require(:shopping).permit(:date_shopping, :total_price, :status, :user_id)
  end
end
