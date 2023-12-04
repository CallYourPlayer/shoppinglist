class AddTotalPriceToShoppings < ActiveRecord::Migration[7.1]
  def change
    add_column :shoppings, :total_price, :float
  end
end
