module CrudExpress::Helpers
  module ControllerHelper
    extend ActiveSupport::Concern
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
      attr_accessor :collection_func

      def cruds_express_collection(func)
        @collection_func = func
      end
    end

    module ModelInstanceMethods
      def collection
        @collection = self.try(self.class.collection_func)
      end
    end

    module ClassMethods
      attr_accessor :locals, :roller, :model, :includes_models
      def cruds_express_roller(roller = :model, model: nil, includes: [], hide: [], lock: [:id, :created_at, :updated_at])
        @roller = roller
        self.include InstanceMethods
        case roller
        when :admin
          self.extend AdminClassMethods
          self.include AdminInstanceMethods
        when :model
          self.extend ModelClassMethods
          self.include ModelInstanceMethods
          @model = model
          hide_columns(*hide)
          lock_columns(*lock)
          @includes_models = Set.new(includes)
        end
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

      def permited_columns
        (Set.new(@model.column_names) - hidden_columns).to_a
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

      def prepare_cruds_express
        @locals = locals
        @locals[:collection] = collection if self.class.roller == :model
        @model = self.class.model
        @helper = self.class
        @includes_models = self.class.includes_models
      end

      def index
        locals[:collection] = collection if self.class.roller == :model
        locals[:cruds_express] = cruds_express if self.class.roller == :index
      end

      def new
        @entry = self.class.model.find_or_initialize_by(id: params[:id])
        locals[:entry] = @entry
      end

      def permit_params
        params.require(ActiveModel::Naming.param_key(self.class.model)).permit(*self.class.permited_columns)
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
        locals[:entry] = @entry
      end

      def destroy
        @entry = self.class.model.find_by(id: params[:id])
        @entry.destroy
        locals[:entry] = @entry
      end

      def respond_curds_express
        @entry = self.class.model.find_by(id: params[:id])
        action = params[:action]
        self.send(action)
        unless performed?
        respond_to do |format|
          format.html {}
          format.js {render partial: "shared/cruds_express/#{self.class.roller}/#{action}", locals: locals}
        end
        end
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
