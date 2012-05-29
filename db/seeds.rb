@user = User.create(:email => 'example@example.com')

account = Account.create account_type:  'gmail',
                         user_name:     'your_user_name',
                         password:      'your_password'
@user.accounts << account
@user.save
