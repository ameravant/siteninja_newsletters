class Admin::NewslettersController < AdminController
  before_filter :authorization
  add_breadcrumb "Newsletters", "admin_newsletters_path"

  def index
    @newsletters = Newsletter.all(:order => "ID DESC")
    @latest_blasts = NewsletterBlast.last_ten
  end
  
  def new
    @newsletter = Newsletter.new
  end
  
  def create
    @newsletter = Newsletter.new(params[:newsletter])
    if @newsletter.save
      redirect_to admin_newsletters_url
      flash[:notice] = "Created newsletter"
    else
      render :new
    end
  end
  
  def update
    @newsletter = Newsletter.find(params[:id])
    if @newsletter.update_attributes(params[:newsletter])
      redirect_to admin_newsletters_url
      flash[:notice] = "Your changes have been saved"
    else
      render :edit, :id => @newsletter
    end
  end
  
  def edit
    @groups = PersonGroup.all
    @newsletter = Newsletter.find(params[:id])
    @newsletter_blast = NewsletterBlast.new
  end
  
  private
  
  def authorization
    authorize(@permissions['newsletters'], "Newsletters")
  end
  
end