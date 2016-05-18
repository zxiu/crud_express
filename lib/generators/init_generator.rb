module Cruds_express
  module Generators
    class InitGenerator < Rails::Generators::NamedBase
      def copy_view_templates
        create_file "app/views/shared/test.html", "<html></html>"
      end
    end
  end
end
