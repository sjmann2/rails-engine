require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to(:invoice)}
    it { should belong_to(:item)}
  end

  describe 'validations' do
    it { should validate_presence_of(:item_id) }
    it { should validate_presence_of(:invoice_id) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
  end

  describe 'class methods' do
    describe 'find_invoice_items' do
      it 'returns all invoice items for the given item id' do
        customer = Customer.create!(first_name: 'Barbara', last_name: 'Walters')
        merchant = create(:merchant)
        
        invoice_1 = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'shipped')
        invoice_2 = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id, status: 'shipped')

        item_1 = create(:item)
        item_2 = create(:item)

        invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 12.99)
        invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 19.99)
        invoice_item_3 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_2.id, quantity: 1, unit_price: 10.99)

        expect(InvoiceItem.find_invoice_items(item_1)).to eq([invoice_item_1, invoice_item_3])
      end
    end
  end
end