class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  validates_presence_of :name
  validates_presence_of :description
  validates :unit_price, numericality: {greater_than: 0}     

  def self.item_by_name(name_params)
    where("name ILIKE ?", "%#{name_params}%").order(:name).first
  end

  def self.min_price(price_params)
    where("unit_price >= ?", price_params).order(:name).first
  end

  def self.max_price(price_params)
    where("unit_price <= ?", price_params).order(:name).first
  end
  
  def self.min_and_max_price(min_price, max_price)
    where("unit_price between ? and ?", min_price, max_price).order(:name).first
  end
end
