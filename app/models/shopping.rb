class Shopping < ApplicationRecord
	has_many :items, dependent: :destroy

	VALID_STATUSES = ['nuovo', 'pagato']

  	validates :status, inclusion: { in: VALID_STATUSES }

	def archived?
		status == 'pagato'
	end

	def total
		self.items.sum(:total_price)
  	end

  	def self.by_dates(date_start, date_end)
  		Shopping.where(:date_shopping => @date_start..@date_end).order(date_shopping: :asc)
  	end
end
