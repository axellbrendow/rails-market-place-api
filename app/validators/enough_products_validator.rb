class EnoughProductsValidator < ActiveModel::Validator
  # @param order [Order]
  def validate(order)
    order.placements.each do |placement|
      product = placement.product
      if placement.quantity > product.quantity
        order.errors[product.title.to_s] << "Is out of stock, just #{product.quantity} left"
      end
    end
  end
end
