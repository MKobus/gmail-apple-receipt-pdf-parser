class Email < ActiveRecord::Base
  attr_accessible :subject, :user_id
  belongs_to :user
  
  class << self
    def load_mail user, klass = ::Gmail::Client
      account = user.accounts.find_by_account_type('gmail')
      
      klass.fetch account do |mail|
        
        create_params = {
          :subject      => mail[:subject]
        }
        create create_params
        
      end
    end
  end
  
end
