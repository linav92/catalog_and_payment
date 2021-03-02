class Order < ApplicationRecord
  belongs_to :client, optional: true
  belongs_to :product, optional: true
  has_many :method_payments
  has_many :payments, through: :method_payments

  validate :there_can_be_only_one

  private

  # def there_can_be_only_one
  #   if existing_digital + existing_fisico != 1
  #      return unless errors.add(:base, "Can only have one owner")
  #   end
  # end

  # def existing_digital
  #   product.digital.present? ? 1 : 0
  # end

  # def existing_fisico
  # end

end
