class Order < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :product, optional: true
  belongs_to :payment, optional: true

  validate :there_can_be_only_one

  private

  def there_can_be_only_one
    if existing_client + existing_product + existing_payment != 1
       errors.add(:base, "Can only have one owner")
    end
  end

  def existing_client
    client.present? ? 1 : 0
  end

  def existing_product
    product.present? ? 1 : 0
  end

  def existing_payment
    payment.present? ? 1 : 0
  end
end
