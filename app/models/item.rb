class Item < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price     

  def self.find_one_item(name_params)
    where("name ILIKE ?", "%#{name_params}%").order(:name).first
  end
end
