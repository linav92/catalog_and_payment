class AddMethodPaymentsRefToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :method_payment_id, :int
    add_foreign_key :orders,:method_payments, column: :method_payment_id, foreign_key: true
  # add_reference :orders, :method_payment, null: false, foreign_key: truez
  end
end
