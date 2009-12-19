class AddImagesCountToNewsletters < ActiveRecord::Migration
  def self.up
    add_column :newsletters, :images_count, :integer
  end

  def self.down
    remove_column :newsletters, :images_count
  end
end
