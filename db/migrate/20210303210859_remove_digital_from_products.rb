class RemoveDigitalFromProducts < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :digital, :interger
    remove_column :products, :fisico, :interger
  end
end
