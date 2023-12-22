class AddStatusToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :payed, :boolean
  end
end
