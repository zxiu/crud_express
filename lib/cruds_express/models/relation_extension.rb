module CrudExpress::Models
  module RelationExtension
    extend ActiveSupport::Concern

    module ClassMethods
    end

    def url_for_params(function, id: nil)
      params = {:controller => cruds_ajax[function][:controller], :action => cruds_ajax[function][:action]}
      case function.to_sym
      when :index, :create, :new
      when :edit, :show, :update, :destroy, :delete
        params[:id] = id
      end
      return params
    end

    def add_cruds_ajax(function, controller:, action:, method:)
      cruds_ajax[function] = {controller: controller, action: action, method: method}
      return self
    end

    def cruds_ajax
      @cruds_ajax ||= ActiveSupport::HashWithIndifferentAccess.new
    end

    def show_columns(*column_names)
      column_names.map{|column_name| hidden_columns.delete(column_name.to_sym)}
      return self
    end

    def hide_columns(*column_names)
      column_names.map{|column_name| hidden_columns.add(column_name.to_sym)}
      puts("hidden_columns=#{hidden_columns}")
      return self
    end

    def edit_columns(*column_names)
      column_names.map{|column_name| disabled_columns.delete(column_name.to_sym)}
      return self
    end

    def disable_columns(*column_names)
      column_names.map{|column_name| disabled_columns.add(column_name.to_sym)}
      return self
    end

    def visible?(column_name)
      !hidden?(column_name)
    end

    def hidden?(column_name)
      hidden_columns.include?(column_name.to_sym)
    end

    def editable?(column_name)
      !disabled?(column_name)
    end

    def disabled?(column_name)
      disabled_columns.include?(column_name.to_sym)
    end

    def cruds_type(column_name)
      # return :hide unless visible?(column_name)
      return :enum unless defined_enums.with_indifferent_access[column_name].blank?
      column_type = column_types[column_name]
      puts("column_types=#{column_types}")
      case column_type
      when :integer, :string
        return :string
      when :text
        return :text
      when :date, :time, :datetime, :timestamps
        return column_type
      else
        return :text
      end
    end

    def hidden_columns
      @hidden_columns ||= Set.new
    end

    def disabled_columns
      @disabled_columns ||= Set.new [:id, :created_at, :updated_at]
    end

    def column_types
      @column_types ||= self.columns.each_with_object(ActiveSupport::HashWithIndifferentAccess.new){|column, hsh| hsh[column.name] = column.type}
    end

  end
end
