class ItemsController < ApplicationController
  	def new
  		@shopping = Shopping.find(params[:shopping_id])
	    @item = @shopping.items.new
  	end

	def create
		@shopping = Shopping.find(params[:shopping_id])
		@item = @shopping.items.create(item_params)
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
		@shopping = Shopping.find(@item.shopping_id)
		#respond_to do |format|
		#	format.js
		#end
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

	def remove
		@item = Item.find(params[:my][:id])
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
		  format.js {render 'calculateprice'}
		end
	end

	private
	def item_params
		params.require(:item).permit(:name, :quantity, :unit_price, :total_price)
	end
end
