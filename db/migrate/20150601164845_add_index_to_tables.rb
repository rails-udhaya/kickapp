class AddIndexToTables < ActiveRecord::Migration
  def change
    
      add_index :creators, :reference_creator_id , :name=>'reference_creator_id_ix'
      add_index :projects, :reference_project_id , :name=>'reference_project_id_ix'
      add_index :projects, :creator_id , :name=>'creator_id_ix'
      add_index :projects, :state , :name=>'state_ix'
      add_index :projects, :platform_from , :name=>'platform_from_ix'
      add_index :pledged_backers, :project_id, :name=>'project_id_ix'
      add_index :projects, [:reference_project_id, :platform_from]
      add_index :projects, [:state, :platform_from]

  end
end

