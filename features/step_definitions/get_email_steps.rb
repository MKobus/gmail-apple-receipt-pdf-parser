Given /^the user has a Gmail  account$/ do
  @user = User.create(:email => 'example@example.com')
  
  account = Account.create account_type:  'gmail',
                           user_name:     'cgabaldon',
                           password:      ''
  @user.accounts << account
  @user.save
end

When /^they select get email from the menu$/ do
  visit(emails_path)
end

Then /^they will see a list of new email$/ do
  page.find('#email_count').value.to_i.should be > 0
end
