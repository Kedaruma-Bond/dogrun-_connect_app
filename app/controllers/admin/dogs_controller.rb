class Admin::DogsController < Admin::BaseController
  include Pagy::Backend
  before_action :set_dog, only: %i[show edit update]
  before_action :check_grand_admin, only: %i[edit update]
  before_action :set_q, only: %i[index search]

  def index
    @pagy, @dogs = pagy(@dogs)
  end

  def show
    if !current_user.grand_admin?
      @registration_number = RegistrationNumber.where(dog: @dog).find_by(dogrun_place: current_user.dogrun_place)
      return if @registration_number.nil?
      
      @registration_number.update!(acknowledge: true)
    end
  end

  def edit
    session[:previous_url] = request.referer 
  end

  def update
    if @dog.update(dog_params)
      if session[:previous_url].nil?
        redirect_to admin_dogs_path, success: t('defaults.update_successfully')
      else
        redirect_to session[:previous_url], success: t('defaults.update_successfully')
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    @pagy, @dogs_results = pagy(@q.result)
  end

  private

    def dog_params
      params.require(:dog).permit(
        :thumbnail, :name, :breed, :castration,
        :public, :owner_comment, :sex, :weight, :birthday,
        :mixed_vaccination_certificate, :rabies_vaccination_certificate,
        :license_plate, :date_of_mixed_vaccination, :date_of_rabies_vaccination,
        :registration_prefecture_code, :registration_municipality, :municipal_registration_number
      )
    end

    def set_q
      if current_user.grand_admin?
        @dogs = Dog.with_attached_thumbnail.with_attached_rabies_vaccination_certificate.with_attached_mixed_vaccination_certificate.includes([:user]).order(id: :desc)
      else
        @dogs = Dog.dogrun_place_id(current_user.dogrun_place_id).with_attached_thumbnail.with_attached_rabies_vaccination_certificate.with_attached_mixed_vaccination_certificate.with_attached_license_plate
      end

      @q = @dogs.ransack(params[:q])
    end
    
    def set_dog
      @dog = Dog.find(params[:id])
    end
end
