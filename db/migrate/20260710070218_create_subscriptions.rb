class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :food_fund, null: false, foreign_key: true

      t.timestamps
    end
  end
end
