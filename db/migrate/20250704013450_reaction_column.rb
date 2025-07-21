class ReactionColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :reactions, :rection, :reaction
  end
end
