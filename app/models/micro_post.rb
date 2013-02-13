class MicroPost < ActiveRecord::Base
  attr_accessible :content, :user_id
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true,
					  length: {minimum: 4, maximum: 140 }
end
