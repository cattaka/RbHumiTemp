require 'test_helper'

class HumitempsControllerTest < ActionController::TestCase
  setup do
    @humitemp = humitemps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:humitemps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create humitemp" do
    assert_difference('Humitemp.count') do
      post :create, humitemp: { box_id: @humitemp.box_id, created_at: @humitemp.created_at, humidity: @humitemp.humidity, measured_at: @humitemp.measured_at, temperature: @humitemp.temperature }
    end

    assert_redirected_to humitemp_path(assigns(:humitemp))
  end

  test "should show humitemp" do
    get :show, id: @humitemp
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @humitemp
    assert_response :success
  end

  test "should update humitemp" do
    patch :update, id: @humitemp, humitemp: { box_id: @humitemp.box_id, created_at: @humitemp.created_at, humidity: @humitemp.humidity, measured_at: @humitemp.measured_at, temperature: @humitemp.temperature }
    assert_redirected_to humitemp_path(assigns(:humitemp))
  end

  test "should destroy humitemp" do
    assert_difference('Humitemp.count', -1) do
      delete :destroy, id: @humitemp
    end

    assert_redirected_to humitemps_path
  end
end
