class Admin::ArticlesController < ModelController
  crud_express_roller model: Article, includes: {user: {label: :first_name}, :tags => {label: :name}}
  crud_express_collection :article_list
  before_action :prepare_crud_express
  around_action :respond_crud_express
  def article_list
    Article.includes(:tags).all
  end

end
