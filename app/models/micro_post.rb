class MicroPost < ActiveRecord::Base
  attr_accessible :content, :user_id
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true,
					  length: {minimum: 4, maximum: 140 }
					  
  def mentions
    results = []
    content.scan(/@[^@]+@/) do |match|
      name = match[1..match.length - 2]
      # Write some code to look up a user by name; if the result
      # is non-nil, then add them to the results array. You should also 
      # check that they aren't @mentioning themselves
      # (remember you can use the '<<' operator to add to an array)
      
      if user.name != name
        users = User.where("name = :name", {:name => name})
        if users != []
          users.each do |item|
            results << item                 
          end
        end  
      end      
    end
    
    return results
  end

  after_create :send_mentions_email

  def send_mentions_email
    # using the function you just wrote iterate each mentioned user,
    # and send them an email (check the previous slides for the 
    # syntax of sending an email)
    results = mentions
    
    results.each do |item|
      UserMailer.mentioned(self, item).deliver
    end
    
  end  
end
