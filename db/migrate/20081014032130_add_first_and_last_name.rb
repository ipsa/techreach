class AddFirstAndLastName < ActiveRecord::Migration
  def self.up
    remove_column(:users, :name)
    add_column(:users, :first_name, :string, :limit => 50)
    add_column(:users, :last_name, :string, :limit => 50)
    add_column(:users, :description, :text)
  end

  def self.down
    add_column(:users, :name, :string, :limit => 100, :default => "")
    remove_column(:users, :first_name)
    remove_column(:users, :last_name)
    remove_column(:users, :description)
  end
end
