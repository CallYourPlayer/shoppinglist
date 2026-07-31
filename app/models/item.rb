class Item < ApplicationRecord
  belongs_to :shopping

  validates :name, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :set_total
  after_save :sync_shopping_total
  after_destroy :sync_shopping_total

  def set_total
    self.total_price = unit_price * quantity
  end

  private

  # Keeps the denormalized shopping.total_price in sync after any change,
  # so callers can never leave it stale.
  def sync_shopping_total
    return if shopping.nil? || shopping.destroyed?

    shopping.update_column(:total_price, shopping.total)
  end
end
