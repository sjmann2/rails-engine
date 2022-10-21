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
    describe 'delete_empty_invoices' do
      let! (:customer) { Customer.create!(first_name: 'Sid', last_name: 'Mann')}
      let! (:merchant) { create(:merchant)}
      let! (:invoice_1) { Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'shipped')}
      let! (:invoice_2) { Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'shipped')}
      let! (:invoice_3) { Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'shipped')}
      let! (:invoice_4) { Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'shipped')}
      let! (:invoice_5) { Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'shipped')}

      let! (:item_1) { create(:item)}
      let! (:item_2) { create(:item)}
      let! (:item_3) { create(:item)}
      let! (:item_4) { create(:item)}

      let! (:invoice_item_1) { InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 10.99)}
      let! (:invoice_item_2) { InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 12.99)}
      let! (:invoice_item_4) { InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_3.id, quantity: 1, unit_price: 20.99)}
      let! (:invoice_item_5) { InvoiceItem.create!(item_id: item_4.id, invoice_id: invoice_4.id, quantity: 1, unit_price: 19.99)}

      it 'destroys all invoice records that do not have any items on them' do
        expect(Invoice.delete_empty_invoices([invoice_1.id, invoice_2.id])).to eq([invoice_2])
        expect(Invoice.delete_empty_invoices([invoice_1.id, invoice_3.id])).to eq([])
        expect(Invoice.delete_empty_invoices([invoice_4.id, invoice_5.id])).to eq([invoice_5])
      end
    end
  end
end