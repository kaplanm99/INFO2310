class UserMailer < ActionMailer::Base
  default from: "web@info2310.com"

  def welcome(user)
    @user = user
    mail(to: user.email, 
         subject: "Welcome to the Info2310 MicroPoster")
  end

  def mentioned(micro_post, mentioned_user)
    # Send an email to the mentioned_user that they were mentioned
    # in the given micro_post
	@micro_post = micro_post
	@mentioned_user = mentioned_user
	mail(to: @mentioned_user.email, 
         subject: "You were mentioned")
  end
end