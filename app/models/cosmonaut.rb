class Cosmonaut < ApplicationRecord
  LEVELS = ["Below Average", "Average", "Above Average"]

  validates_inclusion_of :physical_condition, :mental_endurance, in: LEVELS, allow_nil: true
  validates_presence_of :first_name, :last_name, :physical_condition, :mental_endurance
end
