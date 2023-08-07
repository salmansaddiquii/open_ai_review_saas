class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def generate_password_reset_token
    self.reset_password_token = self.reset_token
    self.reset_password_sent_at = Time.now.utc
    save!
    PasswordResetTokenMailer.reset_password_email(self).deliver
  end
end
