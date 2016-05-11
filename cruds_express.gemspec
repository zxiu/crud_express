$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cruds_express/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cruds_express"
  s.version     = CrudExpress::VERSION
  s.authors     = ["zxiu"]
  s.email       = ["zxiu2015@gmail.com"]
  s.homepage    = "https://github.com/zxiu/cruds_express"
  s.summary     = "Summary of CrudExpress."
  s.description = "Description of CrudExpress."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.6"

  s.add_development_dependency "sqlite3"
end
