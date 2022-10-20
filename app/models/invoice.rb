class Invoice < ApplicationRecord
  validates_presence_of :status
  has_many :invoice_items
  has_many :items, through: :invoice_items
end