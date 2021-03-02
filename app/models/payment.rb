class Payment < ApplicationRecord
    has_many :method_payments
    has_many :orders, through: :method_payments
end
