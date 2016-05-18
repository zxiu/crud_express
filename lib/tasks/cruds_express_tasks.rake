# desc "Explaining what the task does"
# task :cruds_express do
#   # Task goes here
# end
namespace :cruds_express do
  desc "test"
  task :test => :environment do
    puts( "test 123")
  end

end
