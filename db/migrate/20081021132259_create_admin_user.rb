class CreateAdminUser < ActiveRecord::Migration
   def self.up
      
      # Create admin role
      admin_role = Role.create(:name => 'admin')
      
      # Create default admin user
      user = User.create do |u|
         u.email = APP_CONFIG[:admin_email]
         u.password = u.password_confirmation = 'chester'
         u.first_name = 'Admin'
         u.last_name = 'User'
      end
      
      # Activate user
      user.register!
      user.activate!
      
      # Add admin role to admin user
      user.roles << admin_role
      
   end
   
   def self.down
   end
end
