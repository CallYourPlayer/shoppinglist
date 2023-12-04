class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.text :name
      t.integer :quantity
      t.float :unit_price
      t.float :total_price
      t.references :shopping, null: false, foreign_key: true

      t.timestamps
    end
  end
end
