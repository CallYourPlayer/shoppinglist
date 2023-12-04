class AddStatusToShoppings < ActiveRecord::Migration[7.1]
  def change
    add_column :shoppings, :status, :string
  end
end
