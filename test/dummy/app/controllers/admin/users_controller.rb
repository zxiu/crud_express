class Admin::UsersController < ModelController
  cruds_express_roller :model, User
  cruds_express_entries :user_list
  before_action :prepare_cruds_express
  around_action :respond_curds_express

  def user_list
    User.all.hide_columns(:created_at)
  end

end
