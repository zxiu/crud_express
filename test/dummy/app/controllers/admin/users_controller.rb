class Admin::UsersController < ModelController
  # crud_express
  crud_express_role model: User, includes: {:articles => {:label => :title}}, hide: [:created_at], lock: [:id]
  crud_express_collection :user_list
  # before_action :prepare_crud_express
  around_action :respond_crud_express

  def user_list
    User.includes(:articles).all
    # User.all
  end

end
