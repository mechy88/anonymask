class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.string :content
      t.integer :status

      t.timestamps
    end
  end
end
