class Reon::DogRegistrationController < Reon::DogrunPlaceController
  before_action :set_new_post, only: %i[new confirm]
  before_action :dog_registration_params, only: :confirm
  before_action :check_not_guest

  def form_selection
    @confirmation = I18n.t('local.dog_registrations.form_selection.confirmation', registration_card: I18n.t('reon.registration_card'))
  end
  
  def have_registration_card
    session[:card_flg] = true
    redirect_to  send(@dog_registration_path)
  end

  def not_have_registration_card
    session[:card_flg] = false
    redirect_to  send(@dog_registration_path)
  end

  def new
    @registration_number_hint = I18n.t('local.dog_registrations.new.registration_number_hint', registration_card: I18n.t('reon.registration_card'))
    session.delete(:dog_registration_form)
    @dog_registration = DogRegistration.new
  end

  def confirm
    @dog_registration = DogRegistration.new(dog_registration_params)
    if @dog_registration.valid?
      session[:dog_registration_form] = dog_registration_params
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create
    @dog_registration = DogRegistration.new(session[:dog_registration_form].to_hash)
    if params[:back]
      render :new, status: :unprocessable_entity
      return
    end

    if @dog_registration.save
      session.delete(:dog_registration_form)
      session.delete(:card_flg)
      redirect_to send(@top_path), success: t('local.dog_registrations.dog_registration')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def dog_registration_params
    params.require(:dog_registration).permit(
      :name, :castration, :public,
      :registration_number, :agreement
    ).merge(
      user_id: current_user.id,
      dogrun_place_id: @dogrun_place.id
    )
  end
end
