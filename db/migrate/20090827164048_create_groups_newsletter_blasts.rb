class CreateGroupsNewsletterBlasts < ActiveRecord::Migration
  def self.up
    create_table :newsletter_blasts_person_groups, :id => false do |t|
      t.integer :person_group_id
      t.integer :newsletter_blast_id
    end
  end

  def self.down
    drop_table :newsletter_blasts_person_groups 
  end
end
