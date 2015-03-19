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
      #spawn do 
        send_blast(@blast)
      #end
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
    #spawn do
      contacts = contacts_for_blast(blast)
      log = Logger.new("#{RAILS_ROOT}/log/newsletter-blast-errors-#{path_safe(Time.now.to_s)}.log")
      log2 = Logger.new("#{RAILS_ROOT}/log/newsletter-blast-#{path_safe(Time.now.to_s)}.log")
      unsendable = 0
      contacts.each do |contact|
        if contact.active && !contact.no_newsletters
          begin
            contact.first_name = "NotProvided" if contact.first_name.blank?
            contact.last_name = "NotProvided" if contact.last_name.blank?
            PostOffice.deliver_newsletter(blast.newsletter, contact.first_name, contact.email, contact.id, blast.id, @settings) unless contact.no_newsletters
            log2.info "#{contact.name}, #{contact.email}, #{contact.id}:\n#{$!}"
          rescue
            log.info "The following error occurred delivery to #{contact.name}, #{contact.email}, #{contact.id}:\n#{$!}"
          end
        else
          unsendable += 1
        end
      end
      blast.update_attributes(:recipient_count => contacts.size - unsendable)
    #end
  end
  
  def authorization
    authorize(@permissions['newsletter_blasts'], "Newsletter Blasts")
  end

  handle_asynchronously :send_blast
end
