class Admin::DogrunPlacesController < Admin::BaseController
  before_action :check_grand_admin, except: %i[show edit update]
  before_action :correct_admin_user, only: %i[show edit update]
  before_action :dogrun_place_params, only: %i[create update]
  
  def index
    @dogrun_places = DogrunPlace.with_attached_logo.includes([:dogrun_place_facility_relations], [:facilities]).order(created_at: :desc)
    @facilities = Facility.all
  end

  def show
    @dogrun_place = DogrunPlace.find(params[:id])
  end

  def new
    @dogrun_place = DogrunPlace.new
  end

  def create
    @dogrun_place = DogrunPlace.new(dogrun_place_params)
    if @dogrun_place.save
      redirect_to admin_dogrun_places_path, success: t('.create_success')
      return
    end
    render :new, status: :unprocessable_entity
  end

  def edit
    @dogrun_place = DogrunPlace.find(params[:id])
  end

  def update
    @dogrun_place = DogrunPlace.find(params[:id])
    if @dogrun_place.update(dogrun_place_params)
      case current_user.name
      when 'grand_admin'
        redirect_to admin_dogrun_places_path, success: t('defaults.update_successfully')
      else
        redirect_to admin_dogrun_place_path(@dogrun_place), success: t('defaults.update_successfully')
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def dogrun_place_params
    params.require(:dogrun_place).permit(
      :name, :description, :usage_fee, :prefecture_code, :logo,
      :address, :opening_time, :closing_time, :web_site, :site_area,
      :facebook_id, :instagram_id, :twitter_id, facility_ids: []
    )
  end

end
