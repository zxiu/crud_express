# desc "Explaining what the task does"
# task :crud_express do
#   # Task goes here
# end
namespace :crud_express do
  desc "test"
  task :test => :environment do
    puts( "test 123")
  end

end
