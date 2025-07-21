class EmailTitleString < ActiveRecord::Migration[8.0]
  def change
    change_column :posts, :title, :string
    change_column :users, :email, :string
  end
end
