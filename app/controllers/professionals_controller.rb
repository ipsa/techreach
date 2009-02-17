class ProfessionalsController < ApplicationController
  
  def index
    @professionals = User.find(:all, :include => :roles, :conditions => 'roles.id = 3')
  end
  
end
