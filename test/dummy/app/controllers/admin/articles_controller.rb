class Admin::ArticlesController < ModelController
  cruds_express_roller :model
  cruds_express_entries :article_list
  before_action :prepare_cruds_express

  def article_list
    Article.all
  end

end
