class AddColumnPartialDataInProject < ActiveRecord::Migration
  def up
    add_column :projects, :partial_data, :boolean, :default => false
  end

  def down
    remove_column :projects, :partial_data
  end
end
