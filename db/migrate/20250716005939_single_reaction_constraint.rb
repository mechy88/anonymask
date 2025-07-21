class SingleReactionConstraint < ActiveRecord::Migration[8.0]
  def change
    add_index :reactions, [ :user_id, :post_id ], unique: true
  end
end
