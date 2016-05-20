module CrudExpress::Helpers
  module ControllerHelper
    extend ActiveSupport::Concern

    included do
      before_action :prepare_crud_express
    end

    module AdminClassMethods
      attr_accessor :controllers
      def crud_express_admin(controllers: [])
        @controllers = controllers
      end
    end

    module AdminInstanceMethods
    end

    module ModelClassMethods
      attr_accessor :model, :collection, :includes_models
      @hidden_columns = Set.new
      @default_lock = [:id, :created_at, :updated_at]
      @locked_columns = Set.new(@default_lock)

      def crud_express_model(model: nil, collection: nil, includes: {}, hide: [], lock: @default_lock)
        @model = model
        @collection = collection
        @includes = includes
        @hidden_columns = Set.new(hide)
        @locked_columns = Set.new(lock)
        @includes_models = includes_models.merge(includes)
      end

      def includes_models
        @includes_models ||= Hash.new
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
        return (Set.new(@model.column_names) - @hidden_columns).to_a.concat(includes_models_columns)
      end

      def visible?(column_name)
        !hidden?(column_name)
      end

      def hidden?(column_name)
        @hidden_columns.include?(column_name.to_sym)
      end

      def editable?(column_name)
        !locked?(column_name)
      end

      def locked?(column_name)
        @locked_columns.include?(column_name.to_sym)
      end

      private
      def column_types
        @column_types ||= @model.columns.each_with_object(ActiveSupport::HashWithIndifferentAccess.new){|column, hsh| hsh[column.name] = column.type}
      end

    end

    module ModelInstanceMethods
      def collection
        @collection = self.try(self.class.collection)
      end

      def index
      end

      def show
      end

      def model
        collection.model
      end

      def new
        @entry = model.find_or_initialize_by(id: params[:id])
      end

      def permit_params
        params.require(ActiveModel::Naming.param_key(self.class.model)).permit(*self.class.permit_columns)
      end

      def create
        @entry = model.new
        @entry.update_attributes(permit_params)
      end

      def edit
        @entry = model.find_by(id: params[:id])
      end

      def update
        @entry = model.find_by(id: params[:id])
        @entry.update_attributes(permit_params)
      end

      def destroy
        @entry = model.find_by(id: params[:id])
        @entry.destroy
      end

    end

    module ClassMethods
      attr_accessor :role
      def crud_express (role: nil, controllers: [], model: nil, collection: nil, includes: {}, hide: [], lock: @default_lock)
        if role.to_sym == :admin || !controllers.blank?
          @role = :admin
          self.extend AdminClassMethods
          self.include AdminInstanceMethods
          crud_express_admin(controllers: controllers)
        elsif role.to_sym == :model || !model.blank?
          @role = :model
          self.extend ModelClassMethods
          self.include ModelInstanceMethods
          crud_express_model(model: model, collection: collection, includes: includes, hide: hide, lock: lock)
        end
      end
    end

    def is_model?
      self.class.role == :model
    end

    def is_admin?
      self.class.role == :admin
    end

    def prepare_crud_express
      if is_admin?
        @controllers = self.class.controllers
      elsif is_model?
        @collection = collection
        @model = self.class.model
        @helper = self.class
        @includes_models = self.class.includes_models
      end

      if is_model? || is_admin?
        action = params[:action]
        self.try(action)
        respond_to do |format|
          format.html {}
          format.js {render partial: "shared/crud_express/#{self.class.role}/#{action}"}
        end
      end
    end

  end
end
