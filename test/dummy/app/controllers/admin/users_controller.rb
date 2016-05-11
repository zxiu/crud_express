class Admin::UsersController < AdminController
  attr_accessor :user_list

  cruds_express_controller controller: 'admin/users'
  # cruds_express_model model: User, cruds :create, action: :create, controller: 'admin/users', method: :post
  cruds_express_model model: User, cruds: :create, action: :create
  cruds_express_model model: User, cruds: :read, action: :index, source: :list
  cruds_express_model model: User, cruds: :update, action: :update
  cruds_express_model model: User, cruds: :destroy, action: :destroy
  cruds_express_column model: User, permit: [:first_name, :last_name, :email, :birthday, :gender], hide: []

  def index
    # @user_list = list
    # @cruds_helper = self.class
  end

  def list
    User.all
  end



end
