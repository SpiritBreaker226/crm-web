require_relative "./contact.rb"

class Rolodex
	@@index = 1001

	def initialize
		@contacts = []
	end
	
	def add_contact(contact)
		contact.id = @@index 
		@contacts << contact
		@@index += 1
	end

	def modify_contact(contact_id, modify_attribute, modify_value)
		found_contact = search_contact(contact_id)

		unless found_contact == nil
			case modify_attribute.to_i
			when 1 then found_contact[0].first_name = modify_value
			when 2 then found_contact[0].last_name = modify_value
			when 3 then found_contact[0].email = modify_value
			when 4 then found_contact[0].note = modify_value
			else
				return nil
			end

			return found_contact[0]
		end

		return nil
	end

	def delete_contact(contact_id)
		found_contact = search_contact(contact_id)

		return nil if found_contact.empty?

		@contacts.delete_if { |contact| contact.id.to_i == contact_id.to_i }

		found_contact[0]
	end

	def display_all_contacts
		@contacts.join("\n")
	end

	def display_info_by_attribute(select_attribute)
		display_contacts_by_attribute = ""

		@contacts.each do |contact| 
			unless select_attribute == nil
				display_contacts_by_attribute += 
				case select_attribute
					when "firstname" then contact.first_name + "\n"
					when "lastname"  then contact.last_name + "\n"
					when "email"     then contact.email + "\n"
					when "notes"     then contact.note + "\n"
					else
						""
				end
			end
		end

		display_contacts_by_attribute.empty? ? nil : display_contacts_by_attribute
	end

	def display_particular_contact(contact_id)
		found_contact = search_contact(contact_id)

		found_contact.empty? ? nil : found_contact
	end

	def search_contact(contact_id)
		@contacts.find_all { |contact| contact.id.to_i == contact_id.to_i }
	end
end