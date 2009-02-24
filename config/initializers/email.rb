ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address => 'mail.birminghamtechreach.org',
  :port => 26,
  :user_name => 'nobody+birminghamtechreach.org',
  :password => 'karn3ol1awt9ek',
  :authentication => :plain
}