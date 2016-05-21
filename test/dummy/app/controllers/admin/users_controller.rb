class Admin::UsersController < ModelController
  crud_express role: :model, model: User, collection: :list, includes: {:articles => {:label => :title}}, hide: [:created_at],
  filters: [[:first_name, :last_name], :email]

  def list
    User.all.page(params[:page])
  end
end
