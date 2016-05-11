module CrudExpress
  extend ActiveSupport::Concern
end

ActiveSupport.on_load(:active_record) do
  require 'cruds_express/helpers/controller_helper'
  require 'cruds_express/models/base_extension'
  require 'cruds_express/models/relation_extension'
  ::ActionController::Base.send :include, CrudExpress::Helpers::ControllerHelper
  ::ActiveRecord::Base.send :include, CrudExpress::Models::BaseExtension
  ::ActiveRecord::Relation.send :include, CrudExpress::Models::RelationExtension

end
