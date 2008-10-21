class CreateSchools < ActiveRecord::Migration
   def self.up
      create_table :schools do |t|
         t.string :name
         t.timestamps
      end
      
      add_column(:users, :school_id, :integer)
   end
   
   def self.down
      drop_table :schools
      remove_column(:users, :school_id)
   end
end
