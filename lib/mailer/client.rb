require 'rubygems'
require 'pdf/reader'
require 'json'

require 'mail'
require 'openssl'
# require 'gmail'

module Mailer
	class Client
		class << self
			def fetch last_date


				date_last = last_date.strftime("%d-%b-%Y")

				puts date_last

				Mail.defaults do
					retriever_method :imap,
						:address    => 'imap.gmail.com',
						:port       => 993,
						:user_name  => "", #enter email address
						:password   => "", #enter email password
						:enable_ssl => true
				end

				recent_mail = Mail.find  :what       => :last,
					:keys       => ["SUBJECT", "Your receipt from Apple Store", "SINCE", date_last],
					:ready_only => true,
					:order      => :asc,
					:count      => 99999




				recent_mail.each do |mail|

					if mail.date > last_date
						item = Hash.new
						# # puts mail

						item[:sent] = mail.date
						# item[:from] = (mail.from || []).join(',')
						# item[:to] = (mail.to || []).join(',')
						# item[:cc] = (mail.cc || []).join(',')
						# item[:bcc] = (mail.bcc || []).join(',')
						# item[:subject] = mail.subject.to_s
						# item[:body] = mail.body.to_s.force_encoding('UTF-8')

						# yield(item) if block_given?


						mail.attachments.each do | attachment |
							# Attachments is an AttachmentsList object containing a
							# number of Part objects

							# extracting images for example...
							filename = attachment.filename
							puts filename

							begin
								File.open(filename, "w+b", 0644) {|f| f.write attachment.body.decoded}
							rescue => e
								# puts "Unable to save data for #{filename} because #{e.message}"
							end
							# ===================================================
							# encoding options, to remove crazy ? symbols
							encoding_options = {
								:invalid           => :replace,  # Replace invalid byte sequences
								:undef             => :replace,  # Replace anything not defined in ASCII
								:replace           => '',        # Use a blank for those replacements
								:universal_newline => true       # Always break lines with \n
							}


							# BEGIN PARSING DATA


							imei_array = Array.new


							# Takes files arguments passed on script run and parses to txt file


							PDF::Reader.open(filename) do |reader|
								date = reader.info[:CreationDate]
								@date = date.partition(':').last
								puts @date


								puts "Converting : #{filename}"

								pageno = 0
								txt = reader.pages.map do |page|

									pageno += 1
									begin
										print "Converting Page #{pageno}/#{reader.page_count}\r"
										page.text
									rescue
										puts "Page #{pageno}/#{reader.page_count} Failed to convert"

									end
								end # pages map

								puts "\nWriting text to disk"
								File.write filename+'.txt', txt.join("\n")



								File.open(filename+".txt", "rb") do |file|
										@duplicate_receipt = false
          					file.readlines.grep(/\s*DUP/).each do |line|
                      @duplicate_receipt = true
                    end
								end


								if @duplicate_receipt


								else

									File.open(filename+".txt", "rb") do |file|

										# Get Receipt Number before running through lines. Else it won't work right.
										file.readlines.grep(/\*R/).each do |line|
											receipt_line = line.partition('*').last
											receipt_number = receipt_line.partition('*').first
											@receipt_number = receipt_line.partition('*').first
										end

									end

									File.open(filename+".txt", "rb") do |file|

										file.readlines.each do |line|
											# Remove all them crazy ? characters
											c_line = line.encode(Encoding.find('ASCII'), encoding_options)

											# Get serial number
											if line.match("Serial")
												number = line.partition(':').last
												@serial_number = number.encode(Encoding.find('ASCII'), encoding_options).strip

											end

											# Get location
											if c_line[/AppleStore\,/]
												@location = c_line.partition(',').last.strip
											end

											# Get IMEI
											if line.match("IMEI")
												number = line.partition(':').last
												imei = number.encode(Encoding.find('ASCII'), encoding_options)
												imei_strip = imei.strip
												imei_array.push << {imei_number: imei_strip.to_i, serial_number: @serial_number, location:@location, receipt_number: @receipt_number, date: @date}
											end

										end

									end

									# Within each argument so data is right
									@hash = Array.new
									# puts imei_array
									imei_array.each do |imei|
										@hash.push << {imei: imei[:imei_number].to_i, location: imei[:location].to_s, serial_number: imei[:serial_number], receipt_number: imei[:receipt_number], purchase_date: imei[:date]}
									end
									# puts imei_array
									# puts @hash
									yield(@hash) if block_given?

								end #pdf reader end
								File.delete(filename+".txt")
								File.delete(filename)

							end

						end #attachments end
					else

					end #mail date


				end #end recent mail


				# Begin ends for module and class at the top:
			end
		end
	end
end
