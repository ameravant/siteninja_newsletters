class PostOffice < ActionMailer::Base
  SMTP_SETTINGS = {
    :address => "smtp.sendgrid.net",
    :port => 587,
    :enable_starttls_auto => true,
    :authentication => :login,
    :domain => $CMS_CONFIG['website']['domain'],
    :user_name => $MASTER_CONFIG['site_settings']['sendgrid_username'],
    :password => $MASTER_CONFIG['site_settings']['sendgrid_password'],
  }
  
  def newsletter(newsletter, name, email, contact_id, blast_id, settings, website_name)
    setup_email(email, "#{website_name} <#{Setting.first.inquiry_notification_email}>", newsletter.subject, "#{website_name} <#{Setting.first.inquiry_notification_email}>")
    body :name => name, :email => email,:newsletter => newsletter, 
    :contact_id => contact_id, :blast_id => blast_id, :settings => settings
  end
  #handle_asynchronously :newsletter#, :run_at => Proc.new { 2.seconds.from_now }
    
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