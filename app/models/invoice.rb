class Invoice < ApplicationRecord
  validates_presence_of :status
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items, dependent: :destroy

  def self.empty_invoices(invoice_ids)
    # I want to look at the invoice item for these invoice ids, check how many invoice items this id is on
    joins(:invoice_items).where(id: invoice_ids).having("count(invoice_items) = 0").group(:id).pluck(:id)
  end
end