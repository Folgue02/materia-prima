class CreateFoodFunds < ActiveRecord::Migration[8.1]
  def change
    create_table :food_funds do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
