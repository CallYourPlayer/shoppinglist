class AddTakenToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :taken, :boolean
  end
end
