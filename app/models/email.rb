class Email < ActiveRecord::Base
  attr_accessible :imei, :purchase_date, :receipt_number, :serial_number, :location

  class << self
    def load_mail string, klass = ::Mailer::Client
      last_date = string
      klass.fetch last_date do |mail|

        mail.each do |item|

          # create_params = {
          #   :imei      => item[:imei],
          #   :location  => item[:location],
          #   :serial_number => item[:serial_number],
          #   :purchase_date => item[:purchase_date],
          #   :receipt_number => item[:receipt_number]
          # }

          Email.find_or_create_by_imei_and_receipt_number(item[:imei], item[:receipt_number]) do |r|
          r.imei= item[:imei]
          r.location = item[:location]
          r.serial_number = item[:serial_number]
          r.receipt_number = item[:receipt_number]
          r.purchase_date = item[:purchase_date]
          end


        end

      end




    end
  end

end
