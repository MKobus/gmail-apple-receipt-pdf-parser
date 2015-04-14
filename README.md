Gmail Apple Receipt Duplicate Finder
===================

This was a quick and dirty project that scans an email address for all Apple Store PDF receipts and then parses them for duplicate IMEI entries. Results show which receipt#, date purchased, Serial# and location of the duplicate entry iPhone.

## Quick start

1. Install Ruby
2. Install Bundle `gem install bundler`
3. Install Ruby Version Manager `\curl -sSL https://get.rvm.io | bash -s stable` (optional)
4. Install PostgreSQL `postgresql`
5. Run `bundle install`
6. Run `rake db:reset` (initializes your database with data)
7. In a new console start Rails `rails s`
8. In `lib/mailer/client.rb` enter your email address and email password associated with the account you want to run duplicates on.
9. Open [localhost:3000](http://localhost:3000/) in a browser
