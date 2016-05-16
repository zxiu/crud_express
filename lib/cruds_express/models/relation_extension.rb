module CrudExpress::Models
  module RelationExtension
    extend ActiveSupport::Concern

    module ClassMethods
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
      column_names.map{|column_name| readonly_columns.delete(column_name.to_sym)}
      return self
    end

    def readonly_columns(*column_names)
      column_names.map{|column_name| readonly_columns.add(column_name.to_sym)}
      return self
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

    private
    def hidden_columns
      @hidden_columns ||= Set.new
    end

    def readonly_columns
      @readonly_columns ||= Set.new [:id, :created_at, :updated_at]
    end

    def column_types
      @column_types ||= self.columns.each_with_object(ActiveSupport::HashWithIndifferentAccess.new){|column, hsh| hsh[column.name] = column.type}
    end

  end
end
