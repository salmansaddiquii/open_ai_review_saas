class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.string :content
      t.datetime :review_date
      t.string :response_content
      t.datetime :response_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
