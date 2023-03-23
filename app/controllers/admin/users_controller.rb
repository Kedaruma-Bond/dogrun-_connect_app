class Admin::UsersController < Admin::BaseController
  include Pagy::Backend
  before_action :check_grand_admin
  before_action :dogrun_places_set, only: %i[new create]
  before_action :agreement_set, only: %i[new]
  before_action :user_params, only: %i[create]
  before_action :set_q, only: %i[index search]
  before_action :set_user, only: %i[edit update destroy deactivation activation]

  def index
    @pagy, @users = pagy(@users)
  end

  def new
    @user = User.new
  end

  def create
    @user =  User.new(user_params)
    if @user.save
      UserMailer.admin_user_registration_success(@user).deliver_now
      redirect_to admin_users_path, success: t('.admin_user_create')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { 
        if request.referer.nil?
          redirect_to admin_users_path, success: t('defaults.destroy_successfully'), status: :see_other
        else
          redirect_to request.referer, success: t('defaults.destroy_successfully'), status: :see_other
        end
      }
      format.json { head :no_content }
    end
  end

  def search
    @pagy, @users_results = pagy(@q.result)
  end

  def deactivation
    @user.update!(deactivation: true)
    respond_to do |format|
      format.html { 
        if request.referer.nil?
          redirect_to admin_users_path, success: t('.account_frozen') 
        else
          redirect_to request.referer, success: t('.account_frozen') 
        end
        }
      format.json { head :no_content }
    end
  end

  def activation
    @user.update!(deactivation: false)
    respond_to do |format|
      format.html {
        if request.referer.nil?
          redirect_to admin_users_path, success: t('.account_activated') 
        else
          redirect_to request.referer, success: t('.account_activated') 
        end
      }
      format.json { head :no_content }
    end
  end

  private

    def set_q
      @users = User.all.eager_load(:dogs).order(id: :desc)
      @q = @users.ransack(params[:q])
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :name, :email, :deactivation, :password, :password_confirmation, 
        :role, :dogrun_place_id, :agreement, 
      )
    end

    def agreement_set
      params[:agreement] = true
    end

    def dogrun_places_set
      @dogrun_places = DogrunPlace.all
    end
end
