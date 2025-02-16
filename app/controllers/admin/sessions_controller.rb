class Admin::SessionsController < Admin::BaseController
  layout 'admin_login'
  skip_before_action :require_login, :is_account_deactivated?, only: %i[new create]
  skip_before_action :check_admin, only: %i[new create]


  def new; end

  def create
    @user = login(params[:session][:email], params[:session][:password])

    if @user
      if @user.grand_admin?
        redirect_to admin_grand_admin_index_path, success: t('.admin_login')
      else
        redirect_to admin_root_path, success: t('.admin_login')
      end
    else
      flash.now[:error] = t('.login_fail')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to '/admin/login', success: t('.logout'), status: :see_other
  end
end
