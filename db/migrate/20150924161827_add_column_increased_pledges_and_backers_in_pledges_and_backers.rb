class AddColumnIncreasedPledgesAndBackersInPledgesAndBackers < ActiveRecord::Migration
  def up
      add_column :pledged_backers, :increase_pledges, :integer
      add_column :pledged_backers, :increase_backers, :integer
  end

  def down
    remove_column :pledged_backers, :increase_pledges
    remove_column :pledged_backers, :increase_backers
  end
end
