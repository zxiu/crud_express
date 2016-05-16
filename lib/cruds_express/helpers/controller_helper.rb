module CrudExpress::Helpers
  module ControllerHelper
    extend ActiveSupport::Concern

    module ClassMethodsBackup
      def cruds_expresslize(roller)
        self.include InstanceMethods
        case roller
        when :admin
          as_cruds_admin
        when :model
          as_cruds_model
        end
      end

      def as_cruds_admin
        self.extend AdminClassMethods
        self.include AdminInstanceMethods
      end

      def as_cruds_model
        self.extend ModelClassMethods
        self.include ModelInstanceMethods
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

      def cruds_express_controller(model, controller:)
        name = model_name(model)
        default_controllers[name] = controller
      end

      def default_controller(model)
        default_controllers[model_name(model)]
      end

      def default_controllers
        @default_controllers ||= HashWithIndifferentAccess.new
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



      def cruds
        @cruds ||= HashWithIndifferentAccess.new
      end

      def cruds_model(model)
        cruds[model] ||= HashWithIndifferentAccess.new
      end

      def cruds_express_set(model, cruds:, action: nil, controller: nil, method: nil, source: nil)

      end

      def hash_new
        HashWithIndifferentAccess.new(HashWithIndifferentAccess.new)
      end

      def cruds_all
        [:create, :read, :update, :destroy, :show]
      end

      def parse_cruds(fs)
        cruds = fs.is_a?(Array) ? fs : [fs]
        cruds.include?(:all) ? cruds_all : cruds.select{|f| cruds_all.include?(f)}
      end

      def parse_controller(c)

      end

      def default_controller(model, controller: nil)
        cruds_default[model] ||= hash_new
        cruds_default[model][:controller] = controller unless controller.blank?
        return cruds_default[model][:controller]
      end

      def default_action(cruds:)
        return case cruds
        when :create, :update, :destroy, :show
          cruds
        when :read
          :index
        end
      end

      def cruds_default
        @cruds_default ||= hash_new
      end

      def url_for(controller:, action:)

      end


      def cruds_express_model(model, cruds: cruds_all, action: nil, controller: nil, method: nil, source: nil, permit: [], hide: nil)
        model_name = model.name
        cruds_express[model_name] ||= hash_new
        cruds_express[model_name][:columns] ||= hash_new
        model.columns.each do |column|
          column_name = column.name.to_sym
          cruds_express[model_name][:columns][column_name] ||= hash_new
          cruds_express[model_name][:columns][column_name][:permit] = permit.include?(column_name)
          cruds_express[model_name][:columns][column_name][:hide] = hide.include?(column_name) unless hide.blank?
        end

        cruds_express[model_name][:cruds] ||= hash_new
        cruds_express[model_name][:actions] ||= hash_new
        parse_cruds(cruds).each do |func|
          ctr = default_controller(model, controller: controller)
          act = action || default_action(cruds: func)

          cruds_express[model_name][:cruds][func] ||= hash_new
          cruds_express[model_name][:cruds][func][:controller] = ctr
          cruds_express[model_name][:cruds][func][:action] = act
          cruds_express[model_name][:cruds][func][:url] =
            begin
              Rails.application.routes.url_helpers.url_for(controller: ctr, action: act, only_path: true)
            rescue
              Rails.application.routes.url_helpers.url_for(controller: ctr, action: act, id: ":id", only_path: true)
            end
          cruds_express[model_name][:cruds][func][:method] = method || default_method(action: act)

          cruds_express[model_name][:actions][act] ||= hash_new
          cruds_express[model_name][:actions][act][:crud] = func
          cruds_express[model_name][:actions][act][:source] = source


        end
      end

      def cruds_express_column(model, permit: [], hide: [])
        name = model_name(model)
        cruds_express[name] ||= HashWithIndifferentAccess.new
        cruds_express[name][:permit] = permit
        cruds_express[name][:hide] = hide
      end

      def cruds_express
        @cruds_express ||= hash_new
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

    module AdminClassMethods
      def add_model(model, controller:)
        models[model.name] = Hash.new
        models[model.name][:controller] = controller
      end

      def models
        locals[:models] = @models ||= HashWithIndifferentAccess.new
      end
    end

    module AdminInstanceMethods
      attr_accessor :models

      def models
        self.class.models
      end
    end

    module ModelClassMethods
      attr_accessor :entries_func
      def cruds_express_entries(func)
        @entries_func = func
      end
    end

    module ModelInstanceMethods
      def entries
        self.send(self.class.entries_func) unless self.class.entries_func.blank?
      end


    end

    module ClassMethods
      attr_accessor :locals, :roller, :model
      def cruds_express_roller(roller, model = nil)
        @roller = roller
        self.include InstanceMethods
        case roller
        when :admin
          as_cruds_admin
        when :model
          as_cruds_model(model)
        end
      end



      def as_cruds_admin
        self.extend AdminClassMethods
        self.include AdminInstanceMethods
      end

      def as_cruds_model(model)
        self.extend ModelClassMethods
        self.include ModelInstanceMethods
        @model = model
      end

      def locals
        @locals ||= HashWithIndifferentAccess.new
      end
    end

    module InstanceMethods
      attr_accessor :locals

      def cruds_show

      end

      def cruds_read
        result = self.send(cruds_express[http_curd_express_model][:action][params[:action]][:source])
        render_result(true, result.to_json)
      end

      def cruds_create
        model = http_cruds_express_model.constantize.new
        model.update_attributes(params.permit(self.class.permit(model_name)))
        model.save!
        render_result(true, model.inspect)
      end

      def cruds_update
        model = http_curd_express_model.constantize.find(params[:id])
        model.update_attributes(params.permit(self.class.permit(model_name)))
        render_result(true, model.inspect)
      end

      def cruds_destroy

      end

      def render_result(success, message)
        render json: {success: success, message: message}
      end

      def prepare_cruds_express

        # cruds_express.each do |model_name, value|
        #   unless value[:actions][action].blank?
        #     value[:entries] = self.send(value[:actions][action][:source])
        #   end
        # end
        # locals[:cruds_express] = cruds_express
        @locals = locals
        @locals[:entries] = entries if self.class.roller == :model
      end

      def index
        locals[:entries] = entries if self.class.roller == :model
        locals[:cruds_express] = cruds_express if self.class.roller == :index
      end

      def new
        @entry = self.class.model.find_or_initialize_by(id: params[:id])
        locals[:entry] = @entry
      end

      def permit_params
        params.require(ActiveModel::Naming.param_key(self.class.model))
                                .permit(:first_name, :last_name, :email, :title, :gender, :birthday)

      end

      def create
        @entry = self.class.model.new
        permit_params.each do |k, v|
          value = @entry.defined_enums.has_key?(k) ? v.to_i : v
          @entry[k] = value
        end
        @entry.save
        locals[:entry] = @entry
      end

      def edit
        locals[:entry] = User.find_by(id: params[:id])
      end

      def update
        puts("permit_params=#{permit_params}")
        @entry = self.class.model.find_by(id: params[:id])
        permit_params.each do |k, v|
          value = @entry.defined_enums.has_key?(k) ? v.to_i : v
          @entry[k] = value
        end
        @entry.save
        # @entry.update_attributes(permit_params)
        locals[:entry] = @entry
      end

      def respond_curds_express
        @entry = self.class.model.find_by(id: params[:id])
        action = params[:action]
        self.send(action)
        respond_to do |format|
          format.html {}
          format.js {render partial: "shared/cruds_express/#{self.class.roller}/#{action}", locals: locals}
        end
      end

      def delete
      end



      def show
      end


      def locals
        self.class.locals
      end

      def cruds_express
        self.class.cruds_express
      end

    end

  end
end
