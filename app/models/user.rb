class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email, :name, :password
  
  validates :password, presence: true, if: "hashed_password.blank?"
  
  validates :name, presence: true,
                      length: { minimum: 4, maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                        format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
  
  has_many :micro_posts
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  before_save :encrypt_password
                
  def encrypt_password
    self.salt ||= Digest::SHA256.hexdigest("--#{Time.now.to_s}- -#{email}--")
    self.hashed_password = encrypt(password)
  end

  def encrypt(raw_password)
    Digest::SHA256.hexdigest("--#{salt}--#{raw_password}--")
  end
  
  def self.authenticate(email, plain_text_password)
    results = User.where("email = :email", {:email => email})
    if results == []
        return nil
    else
        results.each do |item|
            if Digest::SHA256.hexdigest("--#{item.salt}--#{plain_text_password}--") == item.hashed_password
                return item
            end
        end
        
        return nil
    end
  end
  
  def feed(paginate_options={page: 1})
    followed_user_ids = followed_users.map { |u| u.id }
    MicroPost.where('user_id = ? or user_id in (?)', id, followed_user_ids)
             .order('created_at DESC')
             .paginate(paginate_options)
  end
	
	# Returns the Relationship object this user has with other_user
  # or nil if no relationship exists
  def following?(other_user)
		relationships.find_by_followed_id(other_user.id)
  end

  # create a Relationship object where this user is following other_user
  def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
  end

  # destroy the Relationship object where this user is following other_user
  def unfollow!(other_user)
		relationships.find_by_followed_id(other_user.id).destroy
  end

end