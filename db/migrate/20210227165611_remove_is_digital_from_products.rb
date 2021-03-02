class RemoveIsDigitalFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :is_digital, :boolean
  end
end
