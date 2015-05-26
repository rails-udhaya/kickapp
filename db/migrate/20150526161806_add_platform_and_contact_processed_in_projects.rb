class AddPlatformAndContactProcessedInProjects < ActiveRecord::Migration
  def up
    add_column :projects, :platform_from, :string
    add_column :projects, :contact_is_processed, :boolean
  end

  def down
        remove_column :projects, :platform_from
        remove_column :projects, :contact_is_processed
  end
end


