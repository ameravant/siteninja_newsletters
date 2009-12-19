class Admin::EmailsController < AdminController
  # This does not control newsletters or blasts, but is used for the 
  # activerecord mailer (ar_mailer), which uses this model/table for
  # sending queued emails.

  def index
    @emails = Email.find :all, :order => 'created_on'
  end
  
  def destroy
    @email = Email.find params[:id]
    @email.destroy
    respond_to :js
  end
  
  def clear
    Email.destroy_all
    flash[:notice] = "Queue cleared."
    redirect_to admin_emails_path
  end

end
