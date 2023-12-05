class Item < ApplicationRecord
  belongs_to :shopping

  validates :name, presence: true

  before_save :set_total

  def set_total
    self.total_price = self.unit_price * self.quantity
  end
end
