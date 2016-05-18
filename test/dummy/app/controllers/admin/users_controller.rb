class Admin::UsersController < ModelController
  cruds_express_roller model: User, includes:[:articles], hide: [:created_at], lock: [:id]
  cruds_express_entries :user_list
  before_action :prepare_cruds_express
  around_action :respond_curds_express

  def user_list
    User.includes(:articles).all
  end

end
