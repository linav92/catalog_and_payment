class CreateMethodPayments < ActiveRecord::Migration[6.0]
  def change
    create_table :method_payments do |t|
      t.string :description
      t.references :payment, null: false, foreign_key: true
      t.timestamps
    end
  end
end
