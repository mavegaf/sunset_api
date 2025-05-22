require "test_helper"

class SunsetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sunsets_index_url
    assert_response :success
  end
end
