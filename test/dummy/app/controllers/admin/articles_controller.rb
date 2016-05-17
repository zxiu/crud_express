class Admin::ArticlesController < ModelController
  cruds_express_roller model: Article
  cruds_express_entries :article_list
  before_action :prepare_cruds_express
  around_action :respond_curds_express
  def article_list
    Article.all
  end

end
