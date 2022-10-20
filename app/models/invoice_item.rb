class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity
  validates_presence_of :unit_price
  validates_presence_of :item_id
  validates_presence_of :invoice_id
  belongs_to :invoice
  belongs_to :item

  def self.find_invoice_items(item_id)
    where(item_id: item_id)
  end
end