class Admin::AuthorisedEmailDomainsController < AdminController
  def index
    @authorised_email_domains = AuthorisedEmailDomain.all
  end

  def new
    @authorised_email_domain = AuthorisedEmailDomain.new
  end

  def create
    @authorised_email_domain = AuthorisedEmailDomain.new(authorised_email_params)

    if @authorised_email_domain.save
      redirect_to admin_authorised_email_domains_path, notice: "#{@authorised_email_domain.name} authorised"
    else
      render :new
    end
  end

private

  def authorised_email_params
    params.require(:authorised_email_domain).permit(:name)
  end
end