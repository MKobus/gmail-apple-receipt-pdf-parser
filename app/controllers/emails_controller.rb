class EmailsController < ApplicationController
  respond_to :html
  
  def index
    @user = User.find User.first
    Email.load_mail @user
    @emails = Email.find :all
    respond_with @emails
  end
  
end
