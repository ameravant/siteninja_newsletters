class PostOffice < ActionMailer::Base
  def newsletter(newsletter, name, email, contact_id, blast_id, settings)
    setup_email(email, settings.newsletter_from_email, newsletter.subject)
    body :name => name, :email => email,:newsletter => newsletter, 
    :contact_id => contact_id, :blast_id => blast_id, :settings => settings
  end
    
  private
    
  def setup_email(email_to, email_from, subject, reply_to=nil, content_type='text/html')
    recipients   email_to.strip
    from         email_from.strip
    headers      'Reply-to' => (reply_to ? reply_to.strip : email_from.strip)
    subject      subject.strip
    sent_on      Time.now
    content_type content_type
  end
end