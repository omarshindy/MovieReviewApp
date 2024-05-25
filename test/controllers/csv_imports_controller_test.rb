require "test_helper"

class CsvImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get csv_imports_new_url
    assert_response :success
  end

  test "should get create" do
    get csv_imports_create_url
    assert_response :success
  end
end
