class LongerStrings < ActiveRecord::Migration[8.0]
  def change
    change_column :comments, :content, :text

    change_column :posts, :title, :text
    change_column :posts, :content, :text

    change_column :users, :email, :text
  end
end
