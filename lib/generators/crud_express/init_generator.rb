module Crud_express
  module Generators
    class InitGenerator < Rails::Generators::Base
      desc "Copy templates view file"
      source_root File.expand_path('../templates', __FILE__)
      def copy_view_templates
        puts("source_root=#{self.class.source_root}")
        create_file "app/views/shared/test.html", "<html></html>"
        directory "views", "app/views"
      end
    end
  end
end
