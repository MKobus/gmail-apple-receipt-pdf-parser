@user = User.create(:email => 'example@example.com')

account = Account.create account_type:  'gmail',
                         user_name:     'cgabaldon',
                         password:      'Fixedgearbike1228'
@user.accounts << account
@user.save
