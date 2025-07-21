class CreateReactions < ActiveRecord::Migration[8.0]
  def change
    create_table :reactions do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :rection

      t.timestamps
    end
  end
end
