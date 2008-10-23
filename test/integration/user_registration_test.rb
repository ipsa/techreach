require File.dirname(__FILE__) + '/../test_helper'

class UserRegistrationTest < ActionController::IntegrationTest
  
  # Tests the process of creating a new teacher account.
  def test_creating_a_new_teacher
    
    # Go to the signup page
    get('/signup')
    assert_response(:success)
    assert_template('new')
    
    # Post the role, email address, and passwords, then redirect to the next page.
    post_via_redirect('/register', :user => {
      :email => 'tonysummerville@gmail.com',
      :password => 'password',
      :password_confirmation => 'password'
    })
    assert_response(:success)
    assert_template('new_user')
    
  end
end
