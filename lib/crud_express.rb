module CrudExpress
end

begin
  require 'rails'
rescue LoadError
end



ActiveSupport.on_load(:active_record) do
  require 'crud_express/helpers/controller_helper'
  ::ActionController::Base.send :include, CrudExpress::Helpers::ControllerHelper
end
