# == Schema Information
# Schema version: 20081014033117
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  identity_url              :string(255)
#  email                     :string(100)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  remember_token            :string(40)
#  activation_code           :string(40)
#  state                     :string(255)     default("passive")
#  remember_token_expires_at :datetime
#  activated_at              :datetime
#  deleted_at                :datetime
#  created_at                :datetime
#  updated_at                :datetime
#  first_name                :string(50)
#  last_name                 :string(50)
#  description               :text
#

require 'digest/sha1'

class User < ActiveRecord::Base
   include Authentication
   include Authentication::ByPassword
   include Authentication::ByCookieToken
   include Authorization::AasmRoles
   
   # Validations
   validates_presence_of [:first_name, :last_name]
   validates_format_of [:first_name, :last_name], :with => RE_NAME_OK, :message => MSG_NAME_BAD, :allow_nil => true
   validates_length_of [:first_name, :last_name], :maximum => 50
   
   validates_presence_of :email, :if => :not_using_openid?
   validates_length_of :email, :within => 6..100, :if => :not_using_openid?
   validates_uniqueness_of :email, :case_sensitive => false, :if => :not_using_openid?
   validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD, :if => :not_using_openid?
   
   validates_uniqueness_of :identity_url, :unless => :not_using_openid?
   validate :normalize_identity_url
   
   # Relationships
   has_and_belongs_to_many :roles
   
   # HACK HACK HACK -- how to do attr_accessible from here?
   # prevents a user from submitting a crafted form that bypasses activation
   # anything else you want your user to change should be added here.
   attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, 
      :identity_url, :description
   
   # Authenticates a user by their email and unencrypted password.  Returns the user or nil.
   def self.authenticate(email, password)
      u = find_in_state :first, :active, :conditions => { :email => email } # need to get the salt
      
      if (!u)
         # Allow pending users to login, but warn them that they need to activate their account.
         u = find_in_state :first, :pending, :conditions => {:email => email} # need to get the salt
      end
      
      u && u.authenticated?(password) ? u : nil
   end
   
   # Check if a user has a role.
   def has_role?(role)
      list ||= self.roles.map(&:name)
      list.include?(role.to_s) || list.include?('admin')
   end
   
   # Not using open id
   def not_using_openid?
      identity_url.blank?
   end
   
   # Overwrite password_required for open id
   def password_required?
      new_record? ? not_using_openid? && (crypted_password.blank? || !password.blank?) : !password.blank?
   end
   
   protected
   
   def make_activation_code
      self.deleted_at = nil
      self.activation_code = self.class.make_token
   end
   
   def normalize_identity_url
      self.identity_url = OpenIdAuthentication.normalize_url(identity_url) unless not_using_openid?
   rescue URI::InvalidURIError
      errors.add_to_base("Invalid OpenID URL")
   end
end
