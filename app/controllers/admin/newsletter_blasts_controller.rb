class Admin::NewsletterBlastsController < AdminController
  before_filter :authorization
  add_breadcrumb "Newsletters", "admin_newsletters_path"
  
  def index
    @newsletter = Newsletter.find(params[:newsletter_id], :include => "newsletter_blasts")
    @blasts = @newsletter.newsletter_blasts
  end
  
  def new
    @newsletter_blast = NewsletterBlast.new
    @newsletter = Newsletter.find(params[:newsletter_id])
    @groups = PersonGroup.all
  end
  
  def create
    @blast = NewsletterBlast.new(params[:newsletter_blast])
    @blast.newsletter_id = params[:newsletter_id]
    params[:newsletter_blast][:person_group_ids] ||= []
    if @blast.save
      flash[:notice] = "Newsletters are being sent"
      spawn do 
        send_blast(@blast)
      end
      redirect_to admin_newsletters_path
    else
      render :new
    end
  end

  private
  
  def contacts_for_blast(blast)#could do some good sql here to make this efficient
    blast.person_groups.collect(&:people).flatten.uniq
  end
  
  def send_blast(blast)
    contacts = contacts_for_blast(blast)
    contacts.each do |contact|
      PostOffice.deliver_newsletter(blast.newsletter, contact.first_name, contact.email, contact.id, blast.id, @settings) unless contact.no_newsletters
    end
    blast.update_attributes(:recipient_count => contacts.size)
  end
  
  def authorization
    authorize(@permissions['newsletter_blasts'], "Newsletter Blasts")
  end
  
end