class Item < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price

  def self.find_by_merchant(merchant_id)
    where(merchant_id: merchant_id)
  end
end
