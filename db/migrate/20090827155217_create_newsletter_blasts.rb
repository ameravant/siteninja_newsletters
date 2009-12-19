class CreateNewsletterBlasts < ActiveRecord::Migration
  def self.up
    create_table :newsletter_blasts do |t|
      t.integer :newsletter_id
      t.integer :recipient_count
      t.timestamps
    end
  end

  def self.down
    drop_table :newsletter_blasts
  end
end
