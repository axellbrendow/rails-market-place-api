class Product < ApplicationRecord
  validates :title, :user_id, presence: true
  validates :price, numericality: {
    greater_than_or_equal_to: 0
  }, presence: true

  belongs_to :user

  scope :filter_by_title, lambda { |keyword|
    where('lower(title) LIKE ?', "%#{keyword.downcase}%")
  }
end
