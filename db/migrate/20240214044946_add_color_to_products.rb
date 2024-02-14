class AddColorToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :color, :string
  end
end
