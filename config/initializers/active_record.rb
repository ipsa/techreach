# Contains additions and changes to the ActiveRecord class.
if defined?(ActiveRecord)
   
   module ActiveRecord
      class Base
         
         # Validates an object for specific attributes only. This is useful in a step process
         # where you only want to validate the model object for particular attributes and
         # skip the ones not in that step.
         #
         # Returns true if no errors were added otherwise false.
         #
         #  Example:
         #  user.valid_for_attributes?([:email, :password, :password_confirmation])
         def valid_for_attributes?(attributes)
            unless self.valid?
               valid_errors = []
               errors.each do |attr, error|
                  if attributes.include?(attr.intern)
                     valid_errors << [attr, error]
                  end
               end
               
               errors.clear
               valid_errors.each {|attr, error| errors.add(attr, error)}
               return errors.empty?
            end
            
            return true
         end
      end
   end
   
end