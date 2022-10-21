class Invoice < ApplicationRecord
  validates_presence_of :status
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items, dependent: :destroy

  def self.delete_empty_invoices(invoice_ids)
    left_joins(:invoice_items).where(id: invoice_ids).having("count(invoice_items) = 0").group(:id).destroy_all
  end
end