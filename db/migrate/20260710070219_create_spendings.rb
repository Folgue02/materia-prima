class CreateSpendings < ActiveRecord::Migration[8.1]
  def change
    create_table :spendings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :food_fund, null: false, foreign_key: true
      t.decimal :amount, null: false, precision: 10, scale: 2
      t.string :description

      t.timestamps
    end
  end
end
