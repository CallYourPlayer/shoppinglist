class AddUserToShoppings < ActiveRecord::Migration[7.1]
  def change
    add_column :shoppings, :user_id, :integer
  end
end
