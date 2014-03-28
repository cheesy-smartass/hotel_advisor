class Rating < ActiveRecord::Base
  belongs_to :comment
  belongs_to :user

  validates_presence_of :score
end
