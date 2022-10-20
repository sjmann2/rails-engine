class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items

  def self.search_by_name(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end
end