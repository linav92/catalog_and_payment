class Order < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :product, optional: true
  belongs_to :payment, optional: true
end
