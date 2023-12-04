class CreateShoppings < ActiveRecord::Migration[7.1]
  def change
    create_table :shoppings do |t|
      t.date :date_shopping

      t.timestamps
    end
  end
end
