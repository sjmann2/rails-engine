require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should have_many(:invoice_items)}
    it { should have_many(:items).through(:invoice_items)}

  end

  describe 'validations' do
    it { should(validate_presence_of(:status)) }
  end

  describe 'class methods' do
    describe 'empty_invoices' do
      let! (:customer) { Customer.create!(first_name: 'Sid', last_name: 'Mann')}
      let! (:merchant) { create(:merchant)}
      let! (:invoice_1) { Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'shipped')}
      let! (:invoice_2) { Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'shipped')}

      let! (:item_1) { create(:item)}
      let! (:item_2) { create(:item)}

      let! (:invoice_item_1) { InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 10.99)}
      let! (:invoice_item_2) { InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 10.99)}
      let! (:invoice_item_3) { InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_2.id, quantity: 1, unit_price: 10.99)}
#it should select invoice 2 but not invoice 1

      it 'returns all invoice records associated with an item that do not have ' do
        expect(Invoice.empty_invoices([invoice_1.id, invoice_2.id])).to eq([invoice_2.id])
      end
    end
  end
end