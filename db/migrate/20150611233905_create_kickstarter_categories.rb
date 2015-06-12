class CreateKickstarterCategories < ActiveRecord::Migration
  def change
    create_table :kickstarter_categories do |t|
      t.text :category_url
      t.boolean :is_processed, :default => false
      t.timestamps
    end
  end
end
