class AddClassesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :yogaclass, :integer, default: 0
    add_column :users, :enddate, :datetime
    add_column :users, :name, :string
  end
end
