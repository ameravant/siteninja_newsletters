class AddNoNewslettersToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :no_newsletters, :boolean, :default => false
  end

  def self.down
    remove_column :people, :no_newsletters
  end
end
