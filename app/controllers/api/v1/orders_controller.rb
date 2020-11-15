class Api::V1::OrdersController < ApplicationController
  before_action :check_login, only: %i[index show create]

  def index
    render json: OrderSerializer.new(current_user.orders).serializable_hash
  end

  def show
    order = current_user.orders.find(params[:id])
    options = { include: [:products] }
    render json: OrderSerializer.new(order, options).serializable_hash
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def create
    order = current_user.orders.build(order_params)

    # if order.save
    order.save
    OrderMailer.send_confirmation(order).deliver
    render json: order, status: :created
    # else
    #   render json: { errors: order.errors }, status: :unprocessable_entity
    # end
  end

  private

  def order_params
    # params.require(:order).require(:product_ids)
    params.require(:order).permit(:product_ids)
  end
end
