class ChangePricesToDecimal < ActiveRecord::Migration[7.1]
  def up
    change_column :items, :unit_price, :decimal, precision: 10, scale: 2, default: 0
    change_column :items, :total_price, :decimal, precision: 10, scale: 2, default: 0
    change_column :items, :quantity, :integer, default: 1
    change_column :shoppings, :total_price, :decimal, precision: 10, scale: 2, default: 0
  end

  def down
    change_column :items, :unit_price, :float
    change_column :items, :total_price, :float
    change_column :items, :quantity, :integer
    change_column :shoppings, :total_price, :float
  end
end
