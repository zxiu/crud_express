require 'test_helper'

class CrudExpressTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, CrudExpress
  end

  test "haha" do
    CrudExpress.haha
  end
end
