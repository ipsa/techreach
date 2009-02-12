class CreateRoles < ActiveRecord::Migration
  def self.up
    Role.create(:name => 'teacher')
    Role.create(:name => 'professional')
  end

  def self.down
  end
end
