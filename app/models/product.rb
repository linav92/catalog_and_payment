class Product < ApplicationRecord
    has_many :orders
    has_many :product_digitals
    has_many :product_fisicos

    
end
