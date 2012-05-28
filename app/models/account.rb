class Account < ActiveRecord::Base
  attr_accessible :account_type, :password, :user_id, :user_name
  belongs_to :user
end
