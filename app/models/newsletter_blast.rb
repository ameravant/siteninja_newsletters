class NewsletterBlast < ActiveRecord::Base
  belongs_to :newsletter, :foreign_key => "newsletter_id"
  has_and_belongs_to_many :person_groups
  named_scope :last_ten, :limit => "10", :order => "created_at desc"

end
