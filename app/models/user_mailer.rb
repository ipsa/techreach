class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject = 'Please activate your new TechReach account'
    @body[:url] = "#{APP_CONFIG[:site_url]}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject = 'Your TechReach account has been activated!'
    @body[:url] = APP_CONFIG[:site_url]
  end
  
  protected
  
  def setup_email(user)
    @recipients = "#{user.email}"
    @from = 'TechReach <nobody@birminghamtechreach.org>'
    @sent_on = Time.now
    @body[:user] = user
  end
end
