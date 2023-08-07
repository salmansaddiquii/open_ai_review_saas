class PasswordResetTokenMailer < ActionMailer::Base
  def reset_password_email(user)
    @user = user
    mail(to: @user.email, subject: 'Password Reset Token')
  end
end
