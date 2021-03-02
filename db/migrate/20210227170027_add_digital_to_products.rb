class AddDigitalToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :digital, :integer
  end
end
