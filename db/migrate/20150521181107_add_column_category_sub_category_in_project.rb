class AddColumnCategorySubCategoryInProject < ActiveRecord::Migration
  def up
       add_column :projects, :category, :string
      add_column :projects, :sub_category, :string
  end

  def down
      remove_column :projects, :category
      remove_column :projects, :sub_category
  end
end
