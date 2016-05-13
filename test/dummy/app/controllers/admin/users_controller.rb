class Admin::UsersController < ModelController
  cruds_express_roller :model
  cruds_express_entries :user_list
  before_action :prepare_cruds_express


  # before_action :all_user, only: [:index, :create, :update, :destroy]
  # before_action :set_user, only: [:edit, :update, :destroy]
  #
  # cruds_express_model User, cruds: [:create, :update, :destroy, :show], controller: 'admin/users',
  #   permit: [:first_name, :last_name, :email, :birthday, :gender], hide: [:created_at]
  # cruds_express_model User, cruds: :read, source: :user_list
  #
  # cruds_express_model Article, cruds: [:create, :update, :destroy, :show], controller: 'admin/articles',
  #   permit: [:title, :content], hide: []
  # cruds_express_model Article, cruds: :read, source: :article_list

  #
  # def index
  #   # @user_list = list
  #   # @cruds_helper = self.class
  # end
  #
  # def all_user
  #   @entries = User.all
  #   @controller = self
  # end
  #
  # def set_user
  #   @controller = self
  # end
  #
  # def article_list
  #   Article.all
  # end
  #

  def user_list
    User.all
  end


end
