class OpportunitiesController < ApplicationController
  before_action :find_opportunity, only: [:show, :edit, :update, :destroy]
  before_action :find_organization, only: [:new, :edit]
  before_action :find_user, only: [:new, :edit, :update, :show]
  before_action :volunteer_match, only: [:show, :edit, :update]
  before_action :find_opportunity_organization, only: [:update, :show]
  before_action :user_present?

  def index
    if current_user.has_opportunities?
      @opportunities = current_user.opportunities
    else
      flash[:notice] = "You have no opportunities."
      redirect_to new_opportunity_path
    end
  end

  def new
    if @user.organizations.present?
      @opportunity = Opportunity.new
    else
      flash[:notice] = "Please Create an Organization Before Creating an Opportunity"
      redirect_to '/organizations/new'
    end
  end

  def create
    @organization = Organization.find(params[:opportunity][:organization_id])
    @opportunity = @organization.opportunities.new(opportunity_params)

    if @opportunity.save
      flash[:notice] = "You have created #{@opportunity.name}."
      redirect_to organization_opportunity_path(@organization, @opportunity)
    else
      render :new
    end
  end

  def show
    if @opportunity.organization.user != @user
      redirect_to '/'
    end
    @opportunities = @organization.opportunities if @organization.opportunities.present?
  end

  def edit
    if @opportunity.organization.user != @user
      redirect_to '/'
    end
  end

  def update
    if @opportunity.update(opportunity_params)
      update_status
      flash[:notice] = "You have edited #{@opportunity.name}."
      redirect_to organization_opportunity_path(@organization, @opportunity)
    else
      render :edit
    end
  end

  def destroy
    flash[:notice] = "You have deleted #{@opportunity.name}."
    @opportunity.destroy
    redirect_to opportunities_path
  end

  private

    def find_opportunity
      @opportunity = Opportunity.find(params[:id])
    end

    def find_organization
      if params[:organization_id].present?
        @organization = Organization.find(params[:organization_id])
      end
    end

    def find_opportunity_organization
      @organization = Organization.find(@opportunity.organization_id)
    end

    def update_status
      if @opportunity.volunteer.present? && @opportunity.status == "open"
        @opportunity.update(status: "assigned")
      elsif params[:opportunity][:status] == "completed" && params[:opportunity][:volunteer_id] != ""
        @opportunity.update(status: "completed")
      elsif params[:opportunity][:volunteer_id] == ""
        @opportunity.update(status: "open")
      end
    end

    def find_user
      @user = current_user
    end

    def volunteer_match
      @volunteers = @opportunity.opportunity_match
    end

    def opportunity_params
      params.require(:opportunity).permit(:name, :organization_id, :volunteer_id, :status, :day)
    end
end
