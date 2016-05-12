class Admin::UsersController < AdminController
  cruds_express_model User, cruds: [:create, :update, :destroy, :show], controller: 'admin/users',
    permit: [:first_name, :last_name, :email, :birthday, :gender], hide: []
  cruds_express_model User, cruds: :read, source: :user_list

  cruds_express_model Article, cruds: [:create, :update, :destroy, :show], controller: 'admin/articles',
    permit: [:title, :content], hide: []
  cruds_express_model User, cruds: :read, source: :article_list

  #
  # def index
  #   # @user_list = list
  #   # @cruds_helper = self.class
  # end

  def user_list
    User.all
  end

  def article_list
    Article.all
  end


end
