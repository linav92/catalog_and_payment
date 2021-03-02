class AddFisicoToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :fisico, :integer
  end
end
