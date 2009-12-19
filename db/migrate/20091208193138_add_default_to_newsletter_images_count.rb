class AddDefaultToNewsletterImagesCount < ActiveRecord::Migration
  def self.up
    change_column :newsletters, :images_count, :integer, :default => "0"
  end

  def self.down
    change_column :newsletters, :images_count, :integer
  end
end
