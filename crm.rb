require_relative "./rolodex"
require_relative "./contact"

require "sinatra"

$rolodex = Rolodex.new
@@rolodex = Rolodex.new

# Temporary fake data so that we always find contact with id 1000.
@@rolodex.add_contact(Contact.new("Johnny", "Bravo", "johnny@bitmakerlabs.com", "Rockstar"))

get "/" do
	@title = "Welcome to My CRM"
	erb :index
end

get "/contacts" do
	@title = "All Contacts"
	erb :contacts
end

get "/contacts/new" do
	@title = "Create New Contact"
	erb :new_contact
end

post "/contacts" do
	# for testing do not add when adding code to actully projects
	puts params

	new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
	$rolodex.add_contact(new_contact)
	redirect to("/contacts")
end
