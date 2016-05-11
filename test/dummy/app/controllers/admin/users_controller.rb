class Admin::UsersController < AdminController
  cruds_express_controller User, controller: 'admin/users'
  # cruds_express_model model: User, cruds :create, action: :create, controller: 'admin/users', method: :post
  cruds_express_model User, cruds: [:create, :update, :destroy, :show]
  cruds_express_model User, cruds: :read, source: :list
  cruds_express_column User, permit: [:first_name, :last_name, :email, :birthday, :gender], hide: []

  cruds_express_controller Article, controller: 'admin/articles'
  # cruds_express_model model: User, cruds :create, action: :create, controller: 'admin/users', method: :post
  cruds_express_model Article, cruds: [:create, :update, :destroy, :show]
  cruds_express_model Article, cruds: :read, source: :list
  cruds_express_column Article, permit: [:first_name, :last_name, :email, :birthday, :gender], hide: []

  #
  # def index
  #   # @user_list = list
  #   # @cruds_helper = self.class
  # end

  def list
    User.all
  end



end
