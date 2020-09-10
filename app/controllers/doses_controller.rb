# Possible actions in DosesController:
# create new dose for a given cocktail, delete dose
class DosesController < ApplicationController
  def new
    @cocktail = Cocktail.find(params[:cocktail_id])
    @dose = Dose.new
  end

  def create

    dose = Dose.new(dose_params)
    dose.cocktail = Cocktail.find(params[:cocktail_id])
    dose.save!

    redirect_to cocktails_path
  end

  def destroy
    dose = Dose.find(params[:id])
    dose.destroy

    redirect_to cocktails_path
  end

  private

  def dose_params
    params.require(:dose).permit(:description, :ingredient_id)
  end
end
