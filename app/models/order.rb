class Order < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :product, optional: true
  has_many :method_payments
  has_many :payments, through: :method_payments

end
