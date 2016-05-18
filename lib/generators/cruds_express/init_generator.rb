module Cruds_express
  module Generators
    class InitGenerator < Rails::Generators::Base
      desc "Copy SimpleForm default files"
      source_root File.expand_path('../templates', __FILE__)
      def copy_view_templates
        puts("copy_view_templates")
        create_file "app/views/shared/test.html", "<html></html>"
      end
    end
  end
end
