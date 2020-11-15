class Product < ApplicationRecord
  validates :title, :user_id, presence: true
  validates :price, numericality: {
    greater_than_or_equal_to: 0
  }, presence: true

  belongs_to :user

  scope :filter_by_title, lambda { |keyword|
    where('lower(title) LIKE ?', "%#{keyword.downcase}%")
  }

  scope :above_or_equal_to_price, lambda { |price|
    where('price >= ?', price)
  }

  scope :below_or_equal_to_price, lambda { |price|
    where('price <= ?', price)
  }

  scope :order_by_updated_at, lambda {
    order(:updated_at)
  }

  def self.search(params = {})
    products = if params[:product_ids].present?
                 Product.where(id: params[:product_ids])
               else
                 Product.all
               end

    products = products.filter_by_title(params[:keyword]) if params[:keyword]

    products = products.above_or_equal_to_price(params [:min_price].to_f) if params[:min_price]

    products = products.below_or_equal_to_price(params [:max_price].to_f) if params[:max_price]

    products = products.order_by_updated_at if params[:recent]

    products
  end
end
