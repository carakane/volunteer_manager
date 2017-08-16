class OrganizationsController < ApplicationController

  def index
    # binding.pry
    # current_user.organizations
    if current_user.has_organizations?
      @organizations = current_user.organizations
    else
      flash[:notice] = "You have no organizations."
      redirect_to new_organization_path
    end
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = current_user.organizations.create(organization_params)
    redirect_to organization_path(@organization)
  end

  def show
    @organization = Organization.find(params[:id])
  end

  private

      def organization_params
        params.require(:organization).permit(:name)
      end
end