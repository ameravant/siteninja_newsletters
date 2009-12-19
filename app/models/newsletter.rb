class Newsletter < ActiveRecord::Base
  has_many :newsletter_blasts
  has_many :images, :as => :viewable, :dependent => :destroy
  
  def last_blast_time
    self.newsletter_blasts.last.created_at.to_s(:long_ordinal)
  end
  
  def title
    self.subject
  end
end