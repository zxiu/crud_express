module CrudExpress::Helpers
  module ControllerHelper
    extend ActiveSupport::Concern

    module ClassMethods
      def cruds_expresslize
        self.include InstanceMethods
      end

      def allow?(model_or_class, action:)
        name = model_name(model_or_class)
        return false unless allowed_models.has_key?(name)
        only = allowed_models[name][:only]
        return true if only.blank? || only.include?(action.to_sym)
      end

      def permit?(model_or_class, column_name)
        name = model_name(model_or_class)
        cruds_express[name][:permit].include?(column_name.to_sym)
      end

      def hidden?(model_or_class, column_name)
        name = model_name(model_or_class)
        cruds_express[name][:hide].include?(column_name.to_sym)
      end

      def cruds_express_controller(controller:)
        @default_controller = controller
      end

      def default_method(action:)
        return case action
        when :create
          :post
        when :index, :show
          :get
        when :update
          :patch
        when :destroy
          :delete
        end
      end

      def default_action(cruds:)
        return case cruds
        when :create, :update, :destroy, :show
          cruds
        when :read
          :index
        end
      end

      def cruds_express_model(model, cruds:, action: nil, controller: @default_controller, method: nil, source: nil)
        if cruds.is_a?(Array)
          cruds.each do |f|
            cruds_express_model(model, cruds: f, action: action, controller: controller, method: method, source: source)
          end
        else
          name = model_name(model)
          action = default_action(cruds: cruds) if action.blank?
          cruds_express[name] ||= HashWithIndifferentAccess.new
          cruds_express[name][:action] ||= HashWithIndifferentAccess.new
          cruds_express[name][:action][action] ||= HashWithIndifferentAccess.new
          cruds_express[name][:action][action][:cruds] = cruds
          cruds_express[name][:action][action][:source] = source
          cruds_express[name][:cruds] ||= HashWithIndifferentAccess.new
          cruds_express[name][:cruds][cruds] ||= HashWithIndifferentAccess.new
          cruds_express[name][:cruds][cruds][:controller] = controller
          cruds_express[name][:cruds][cruds][:action] = action
          cruds_express[name][:cruds][cruds][:method] = method || default_method(action: action)
        end
      end

      def cruds_express_column(model, permit: [], hide: [])
        name = model_name(model)
        cruds_express[name] ||= HashWithIndifferentAccess.new
        cruds_express[name][:permit] = permit
        cruds_express[name][:hide] = hide
      end

      def cruds_express
        @cruds_express ||= HashWithIndifferentAccess.new
      end

      def model_name(model_or_class)
        return nil if model_or_class.blank?
        if (model_or_class.is_a?(String) || model_or_class.is_a?(Symbol))
          return model_or_class.to_sym
        else
          return (model_or_class.is_a?(Class) ? model_or_class : model_or_class.class).model_name.to_s.to_sym
        end
      end
    end

    module InstanceMethods
      def cruds_show
        
      end

      def cruds_read
        result = self.send(cruds_express[http_curd_express_model][:action][params[:action]][:source])
        render_result(true, result.to_json)
      end

      def cruds_create
        model = http_cruds_express_model.constantize.new
        model.update_attributes(params.permit(cruds_helper.permit(model_name)))
        model.save!
        render_result(true, model.inspect)
      end

      def cruds_update
        model = http_curd_express_model.constantize.find(params[:id])
        model.update_attributes(params.permit(cruds_helper.permit(model_name)))
        render_result(true, model.inspect)
      end

      def cruds_destroy

      end

      def render_result(success, message)
        render json: {success: success, message: message}
      end

      def http_cruds_express_model
        request.env["HTTP_CRUDS_EXPRESS_MODEL"]
      end

      def cruds_express_prepare
        if request.xhr?
          puts("check_allowed=#{check_allowed?}")
          if check_allowed?
            self.send ("cruds_#{cruds_express[http_curd_express_model][:action][params[:action]][:crud]}")
          else
            render_result(false, :forbidden!)
          end
        end
        @cruds_express = cruds_express
        @curd_helper = self.class
      end

      def check_allowed?
        cruds_express[http_curd_express_model][:action].has_key?(params[:action])
      end

      def cruds_express
        self.class.cruds_express
      end

    end

  end
end
