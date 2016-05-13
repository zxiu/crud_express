class AdminController < ApplicationController
  # respond_to :html, :js
  cruds_express_roller :admin
  # before_action :init_locals
  before_action :prepare_cruds_express

  add_model User, controller: 'admin/users'
  add_model Article, controller: 'admin/articles'


  # before_action :all_user, only: [:index, :create, :update, :destroy]
  # before_action :set_user, only: [:edit, :update, :destroy]
  #
  # cruds_express_model User, cruds: [:create, :update, :destroy, :show], controller: 'admin',
  #   permit: [:first_name, :last_name, :email, :birthday, :gender], hide: [:created_at]
  # cruds_express_model User, cruds: :read, source: :user_list
  #
  # cruds_express_model Article, cruds: [:create, :update, :destroy, :show], controller: 'admin',
  #   permit: [:title, :content], hide: []
  # cruds_express_model Article, cruds: :read, source: :article_list
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
  # def user_list
  #   User.all
  # end

end
