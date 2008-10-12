# Removes the "login" field from the Users table since email will be used
# to login.
class RemoveUsername < ActiveRecord::Migration
   def self.up
      remove_index(:users, :login)
      remove_column(:users, :login)
      add_index(:users, :email, :unique => true)
   end
   
   def self.down
      add_column(:users, :login, :string, :limit => 40)
      add_index(:users, :login, :unique => true)
      remove_index(:users, :email)
   end
end
