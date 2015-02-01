require "sinatra"
require "data_mapper"

DataMapper.setup(:default, "sqlite3:database.sqlite3")

class Contact
	include DataMapper::Resource

	property :id, Serial
	property :first_name, String
	property :last_name, String
	property :email, String
	property :note, String

	# attr_accessor :id, :first_name, :last_name, :email, :note
	
	# def initialize(first_name, last_name, email, note)
	# 	@first_name = first_name
	# 	@last_name = last_name
	# 	@email = email
	# 	@note = note
	# end
end

DataMapper.finalize
DataMapper.auto_upgrade!

# end of datamapper setup

# begin sinatra routes

get "/" do
	@title = "Welcome to My CRM"
	erb :index
end

get "/contacts" do
	@contacts = Contact.all;

	@title = "All Contacts"
	erb :contacts
end

get "/contacts/new" do
	@title = "Create New Contact"
	erb :new_contact
end

get "/contacts/search_result" do
	@title = "Search Results for #{params[:search]}"
	@queries = params[:search].split(" ").map { |query| query = "%#{query}%" }

	@contacts = @queries.map do |query| 
		Contact.all({
			conditions: [
				"first_name LIKE ? OR last_name LIKE ? OR email LIKE ? OR note LIKE ?",
				query,
				query,
				query,
				query
			]
	})
	end

	@contacts.flatten!.compact!

	erb :contacts
end

get "/contacts/:id" do
	@contact = Contact.get(params[:id].to_i)

	if @contact
		@title = "Contact Details For #{@contact.first_name} #{@contact.last_name}"
		erb :show_contact
	else
		raise Sinatra::NotFound
	end
end

get "/contacts/:id/edit" do
	@contact = Contact.get(params[:id].to_i)

	if @contact
		@title = "Edit Contact For #{@contact.first_name} #{@contact.last_name}"
		erb :edit_contact
	else
		raise Sinatra::NotFound
	end
end

delete "/contacts/:id" do
	@contact = Contact.get(params[:id].to_i)

	if @contact
		@contact.destroy

		redirect to("/contacts")
	else
		raise Sinatra::NotFound
	end
end

post "/contacts" do
	# for testing do not add when adding code to actully projects
	puts params

	new_contact = Contact.new(params)
	new_contact.save
	redirect to("/contacts")
end

put "/contacts/:id" do
	@contact = Contact.get(params[:id].to_i)

	if @contact
		@contact.first_name = params[:first_name]
		@contact.last_name = params[:last_name]
		@contact.email = params[:email]
		@contact.note = params[:note]
		@contact.save

		redirect to("/contacts")
	else
		raise Sinatra::NotFound
	end
end
