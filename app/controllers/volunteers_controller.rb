class VolunteersController < ApplicationController

  def index
    @volunteers = Volunteer.all
  end

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.create(volunteer_params)
    redirect_to volunteer_path(@volunteer)
  end

  def show
    @volunteer = Volunteer.find(params[:id])
    @opportunities = @volunteer.opportunities
    # binding.pry
  end

  def edit
    @volunteer = Volunteer.find(params[:id])
  end

  def update
    @volunteer = Volunteer.find(params[:id])
    @volunteer.update(volunteer_params)
    flash[:notice] = "You have edited #{@volunteer.name}."
    redirect_to volunteer_path(@volunteer)
  end

  def destroy
    @volunteer = Volunteer.find(params[:id])
    @volunteer.destroy
    flash[:notice] = "You have deleted #{@volunteer.name}."
    redirect_to volunteers_path
  end

  private

    def volunteer_params
      params.require(:volunteer).permit(:name,
      availability_attributes: [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday])
    end
end
