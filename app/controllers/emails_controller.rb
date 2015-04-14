class EmailsController < ApplicationController
  respond_to :html

  def run_mail
  	last_email = Email.find(:last)

  	if last_email.nil?

        time = "2013-04-25 00:00:04 UTC"
         date_time = DateTime.parse(time).to_time
        @string = date_time
  	else
  		@string = last_email.purchase_date
  	end
  	puts @string

  	Email.load_mail @string

  end

  def index
    if params[:start_date].present? and params[:end_date].present?
    	begin_date = DateTime.parse(params[:start_date]).to_time
   	 	end_date = DateTime.parse(params[:end_date]).to_time
   	 	puts begin_date
   	 	puts end_date
   	elsif params[:start_date].present?
   		begin_date = DateTime.parse(params[:start_date]).to_time
   		end_date = DateTime.now.to_time
    else
    	begin_date = DateTime.parse("2010-01-01").to_time
    	end_date = DateTime.now.to_time
    end

    imei_dupes = Email.where(purchase_date: begin_date.to_s(:db)..end_date.to_s(:db)).count(group: :imei).select { |k, v| v > 1 }.keys
    if imei_dupes.length > 0
    	@emails = Array.new
	    duplicats = Hash.new
	    imei_dupes.each do |duplicates|

	      emails = Email.where(:imei => duplicates)


	      arr = Array.new
	      emails.each do |item|
	      	clean_date = item.purchase_date.strftime("%_m-%d-%y")[1..-1]
	        arr.push << {:imei => item.imei,
	                     :location => item.location,
	                     :receipt_number => item.receipt_number,
	                     :purchase_date => clean_date,
	                     :serial_number => item.serial_number}
	      end


	      @emails.push << {:entry => arr}

	    end


    else
    	@emails = []
    end

    respond_with @emails


  end




  def choose

  end

end
