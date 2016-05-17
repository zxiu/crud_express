module CrudExpress
  extend ActiveSupport::Concern
end

ActiveSupport.on_load(:active_record) do
  require 'cruds_express/helpers/controller_helper'
  ::ActionController::Base.send :include, CrudExpress::Helpers::ControllerHelper
end
