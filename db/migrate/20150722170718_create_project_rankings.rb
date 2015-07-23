class CreateProjectRankings < ActiveRecord::Migration
  def change
    create_table :project_rankings do |t|
      t.string :reference_project_id, :ks_discover_query, :ranking, :name
      t.text :kickstart_project_url
      t.timestamps
    end
  end
end
