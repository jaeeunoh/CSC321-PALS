class Interest < ApplicationRecord
    has_and_belongs_to_many :users
    
    def self.cat_interests 
        ["Shifts", "Fostering", "Transport"]
    end
    
    def self.dog_interests
        ["Shifts", "Fostering", "Transport"]
    end

    def self.other_interests
        ["Cooking/baking", "Organizing events", "Fundraising", "Machine maintenance"]
    end
end
