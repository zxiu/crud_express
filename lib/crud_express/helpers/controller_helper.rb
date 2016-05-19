module CrudExpress::Helpers
  module ControllerHelper
    extend ActiveSupport::Concern

    included do
      # before_action :set_object, only: [:show]
      puts(" included #{self}")
      before_action :prepare_crud_express
      # around_action :respond_crud_express
    end

    module AdminClassMethods

      # def add_model(model, controller:)
      #   models[model.name] = Hash.new
      #   models[model.name][:controller] = controller
      # end
      #
      # def models
      #   locals[:models] = @models ||= HashWithIndifferentAccess.new
      # end

      def controllers
        @controllers ||= []
      end
    end

    module AdminInstanceMethods
      attr_accessor :models

      def prepare_crud_express
        @controllers = self.class.controllers
      end

    end

    module ModelClassMethods
      attr_accessor :collection_func

      def crud_express_collection(func)
        @collection_func = func
      end
    end

    module ModelInstanceMethods
      def collection
        @collection = self.try(self.class.collection_func)
      end

      def prepare_crud_express
        @locals = locals
        @locals[:collection] = collection if self.class.role == :model
        @model = self.class.model
        @helper = self.class
        @includes_models = self.class.includes_models
      end
    end

    module ClassMethods

      attr_accessor :locals, :role, :model, :includes_models

      def crud_express(role: nil, controllers: [], model: nil, collection: nil, includes: {}, hide: [], lock: default_lock)
        if role.to_sym == :admin || !controllers.blank?
          @role = :admin
          @controllers = controllers
          self.extend AdminClassMethods
          self.include AdminInstanceMethods
        elsif role.to_sym == :model || !model.blank?
          @role = :model
          @model = model
          @collection = collection
          @includes = includes
          @hidden_columns = Set.new(hide)
          @locked_columns = Set.new(lock)
          self.extend ModelClassMethods
          self.include ModelInstanceMethods
        end
      end

      def default_lock
        [:id, :created_at, :updated_at]
      end

      def crud_express_role(role = :model, model: nil, includes: {}, hide: [], lock: [:id, :created_at, :updated_at])
        @role = role
        self.include InstanceMethods
        case role
        when :admin
          self.extend AdminClassMethods
          self.include AdminInstanceMethods
        when :model
          self.extend ModelClassMethods
          self.include ModelInstanceMethods
          @model = model
          hide_columns(*hide)
          lock_columns(*lock)
          @includes_models = includes_models.merge(includes)
        end
      end

      def includes_models
        @includes_models ||= Hash.new
      end

      def locals
        @locals ||= HashWithIndifferentAccess.new
      end

      def hide_columns(*column_names)
        column_names.map{|column_name| hidden_columns.add(column_name.to_sym)}
        puts("hidden_columns=#{hidden_columns}")
        return self
      end

      def lock_columns(*column_names)
        column_names.map{|column_name| readonly_columns.add(column_name.to_sym)}
        return self
      end

      def permit_columns
        includes_models_columns = Array.new
        includes_models.each do |model_name, config|
          association_foreign_key = model.reflect_on_association(model_name).association_foreign_key
          case model.reflect_on_association(model_name).macro
            when :has_many, :has_and_belongs_to_many
              includes_models_columns.push("#{association_foreign_key}s" => [])
            when :has_one, :belongs_to
              includes_models_columns.push("#{association_foreign_key}")
          end
        end
        s = (Set.new(@model.column_names) - hidden_columns).to_a.concat(includes_models_columns)
        puts("permit_columns=#{s}")
        return s
      end

      def visible?(column_name)
        !hidden?(column_name)
      end

      def hidden?(column_name)
        hidden_columns.include?(column_name.to_sym)
      end

      def editable?(column_name)
        !readonly?(column_name)
      end

      def readonly?(column_name)
        readonly_columns.include?(column_name.to_sym)
      end

      def hello
        "hello"
      end

      private
      def hidden_columns
        @hidden_columns ||= Set.new
      end

      def readonly_columns
        @readonly_columns ||= Set.new [:id, :created_at, :updated_at]
      end

      def column_types
        @column_types ||= @model.columns.each_with_object(ActiveSupport::HashWithIndifferentAccess.new){|column, hsh| hsh[column.name] = column.type}
      end
    end

    module InstanceMethods
      attr_accessor :locals



      def index
        locals[:collection] = collection if self.class.role == :model
        locals[:crud_express] = crud_express if self.class.role == :index
      end

      def new
        @entry = self.class.model.find_or_initialize_by(id: params[:id])
        locals[:entry] = @entry
      end

      def permit_params
        params.require(ActiveModel::Naming.param_key(self.class.model)).permit(*self.class.permit_columns)
      end

      def create
        @entry = self.class.model.new
        @entry.update_attributes(permit_params)
        locals[:entry] = @entry
      end

      def edit
        locals[:entry] = User.find_by(id: params[:id])
      end

      def update
        @entry = self.class.model.find_by(id: params[:id])
        @entry.update_attributes(permit_params)
        locals[:entry] = @entry
      end

      def destroy
        @entry = self.class.model.find_by(id: params[:id])
        @entry.destroy
        locals[:entry] = @entry
      end

      def respond_crud_express
        @entry = self.class.model.find_by(id: params[:id])
        action = params[:action]
        self.send(action)
        unless performed?
        respond_to do |format|
          format.html {}
          format.js {render partial: "shared/crud_express/#{self.class.role}/#{action}", locals: locals}
        end
        end
      end

      def show
      end


      def locals
        self.class.locals
      end
    end

  end
end
