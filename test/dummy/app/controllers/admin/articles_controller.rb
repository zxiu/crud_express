class Admin::ArticlesController < ModelController
  crud_express role: :model, model: Article, collection: :list,
    includes: {user: {label: :first_name}, :tags => {label: :name}}, filters: [:title]

  def list
    Article.all.page(params[:page])
  end

end
