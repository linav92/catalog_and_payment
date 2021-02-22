class AddPriceToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :price, :decimal
  end
end
