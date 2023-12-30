class ItemsController < ApplicationController
	before_action :authenticate_user!
	load_and_authorize_resource except: [:calculateprice, :paid_item, :set_taken]

	rescue_from CanCan::AccessDenied do |exception|
    	redirect_to root_url, :alert => exception.message
  	end

  	def new
  		@shopping = Shopping.find(params[:shopping_id])
	    @item = @shopping.items.new
	    logger.debug @item.shopping_id
	    authorize! :create, @item
  	end

	def create
		@shopping = Shopping.find(params[:shopping_id])
		@item = @shopping.items.create(item_params)
		logger.debug @item.shopping_id
		#@item.set_total(@item.unit_price * @item.quantity)
		#@item.total_price = @item.quantity * @item.unit_price
		respond_to do |format|
			if @item.update(item_params)
				@shopping.total_price = @shopping.total
				@shopping.save
				format.html { redirect_to edit_shopping_path(@shopping), notice: 'Articolo creato con successo.' }
	        	format.json { render action: 'edit', controller: 'shoppings', status: :created, location: edit_shopping_path(@shopping) }
	        	# added:
	       		format.json { render action: 'edit', controller: 'shoppings', status: :created, location: edit_shopping_path(@shopping) }
	      	else
	        	format.html { render action: 'new' }
	        	format.json { render json: @item.errors, status: :unprocessable_entity }
	        	# added:
	        	format.js   { render json: @item.errors, status: :unprocessable_entity }
	      	end
      	end
		#redirect_to edit_shopping_path(@shopping)
	end

	def edit
		@item = Item.find(params[:id])
		authorize! :update, @item
		@shopping = Shopping.find(@item.shopping_id)
		respond_to do |format|
			format.js
		end
	end

	def update
	    @item = Item.find(params[:id])
	    @shopping = Shopping.find(params[:shopping_id])
	    #@item.set_total(item_params[:unit_price], item_params[:quantity])
	    if @item.update(item_params)
	    	@shopping.total_price = @shopping.total
	    	@shopping.save
	      	redirect_to edit_shopping_path(@shopping)
	    else
	      render :edit, status: :unprocessable_entity
	    end
	end

	def destroy
    	@item = Item.find(params[:id])
    	authorize! :destroy, @item
    	@shopping = Shopping.find(@item.shopping_id)
    	@item.destroy

    	redirect_to edit_shopping_path(@shopping), status: :see_other
  	end

	def remove
		@item = Item.find(params[:my][:id])
		authorize! :destroy, @item
		@item.destroy
		@shopping =Shopping.find(@item.shopping_id)
		@shopping.total_price = @shopping.total
		respond_to do |format|
			format.html
			format.js
		end
	end

	def calculateprice
		@item = Item.find(params[:my][:id])
		#authorize! :update, @item
		@k = params[:my][:k]
		@op = params[:my][:op]
		if @op == "sum"
			@item.update_attribute :quantity, @item.quantity + @k.to_i
		else
			if @item.quantity > 1
				@item.update_attribute :quantity, @item.quantity - @k.to_i
			end
		end
		@item.update_attribute :total_price, @item.quantity * @item.unit_price
		@shopping =Shopping.find(@item.shopping_id)
		@shopping.total_price = @shopping.total
		respond_to do |format|
			format.js 
		end
	end

	def paid_item
		@item = Item.find(params[:id])
		#authorize! :update, @item
		if @item.payed?
			@item.update_attribute :payed, false
		else
			@item.update_attribute :payed, true
		end
		@shopping =Shopping.find(@item.shopping_id)
		@paid_items = @shopping.items.where(:payed => true)
		@result_total_price = @paid_items.sum(:total_price)
		respond_to do |format|
			format.js 
		end
	end

	def set_taken
		@item_id = params[:id]
		@taken = params[:taken]
		@item = Item.find(@item_id)
		@item.taken = @taken
		if @item.save
			respond_to do |format|
				format.js 
			end
		else
			format.json { render action: 'edit', controller: 'shoppings', status: :unprocessable_entity }
		end
	end

	private
	def item_params
		params.require(:item).permit(:name, :quantity, :unit_price, :total_price, :payed, :taken)
	end
end
