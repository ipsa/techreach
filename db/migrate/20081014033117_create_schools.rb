class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.integer :school_id, :null => false
      t.string :school_name
      t.timestamps
    end
    
    create_table :schools_users, :id => false do |t|
      t.belongs_to :school
      t.belongs_to :user
    end
  end

  def self.down
    drop_table :schools_users
    drop_table :schools
  end
end
