class CreateNewsletters < ActiveRecord::Migration
  def self.up
    create_table :newsletters do |t|
      t.string :subject
      t.text :body
    end
  end

  def self.down
    drop_table :newsletters
  end
end
