class RemoveUnwantedFieldsFromProject < ActiveRecord::Migration
  def up
    remove_column :projects, :slug
    remove_column :projects, :blurb
    remove_column :projects, :country
    remove_column :projects, :country_short_name
    remove_column :projects, :country_long_name
    remove_column :projects, :rewards
    remove_column :projects, :video
    remove_column :projects, :embed
    remove_column :projects, :friends
    remove_column :projects, :comments_count
    remove_column :projects, :updates_count
    remove_column :projects, :is_started
    remove_column :projects, :is_backing
    remove_column :projects, :project_updated_at
  end

  def down
      add_column :projects, :slug, :string
      add_column :projects, :blurb, :string
      add_column :projects, :country, :string
      add_column :projects, :country_short_name, :string
      add_column :projects, :country_long_name, :string
      add_column :projects, :rewards, :string
      add_column :projects, :project_updated_at, :string

      add_column :projects, :video, :text
      add_column :projects, :embed, :text
      add_column :projects, :friends, :text
     
      add_column :projects, :comments_count, :integer
      add_column :projects, :updates_count, :integer


      add_column :projects, :is_started, :boolean
      add_column :projects, :is_backing, :boolean
  end
end

 
