class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :max_reviews_per_month

      t.timestamps
    end
  end
end
