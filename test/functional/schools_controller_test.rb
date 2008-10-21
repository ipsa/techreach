require 'test_helper'

class SchoolsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:schools)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_school
    assert_difference('School.count') do
      post :create, :school => { }
    end

    assert_redirected_to school_path(assigns(:school))
  end

  def test_should_show_school
    get :show, :id => schools(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => schools(:one).id
    assert_response :success
  end

  def test_should_update_school
    put :update, :id => schools(:one).id, :school => { }
    assert_redirected_to school_path(assigns(:school))
  end

  def test_should_destroy_school
    assert_difference('School.count', -1) do
      delete :destroy, :id => schools(:one).id
    end

    assert_redirected_to schools_path
  end
end
