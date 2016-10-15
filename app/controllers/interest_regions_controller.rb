class InterestRegionsController < AuthenticatedUserController
  onboard :regions_of_interest, with: [:survey, :save_survey]

  def survey
    @regions = Region.order(name: :asc)
    @interest_regions = InterestRegionsSurvey.new(account: current_account)
  end

  def save_survey
    @interest_regions = InterestRegionsSurvey.new(account: current_account)
    # not supposed to be invalid
    @interest_regions.update!(interest_regions_survey_params)
    redirect_to onboarding_survey_path
  end

  private

  def interest_regions_survey_params
    if params.has_key?(:interest_regions_survey)
      params.require(:interest_regions_survey).permit(regions: [:region_id, :selected])
    else # if user doesn't select anything
      {}
    end
  end
end