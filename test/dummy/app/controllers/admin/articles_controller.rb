class Admin::ArticlesController < ModelController
  crud_express role: :model, model: Article, collection: :list, includes: {user: {label: :first_name}, :tags => {label: :name}}
  around_action :respond_crud_express

  def list
    Article.includes(:tags).all
  end

end
