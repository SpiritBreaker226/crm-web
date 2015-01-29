require_relative "./rolodex"
require_relative "./contact"

require "sinatra"

@@rolodex = Rolodex.new

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

get "/contacts/:id" do
	@contact = @@rolodex.search_contact(params[:id].to_i)

	if @contact
		@title = "Contact Details For #{@contact.first_name} #{@contact.last_name}"
		erb :show_contact
	else
		raise Sinatra::NotFound
	end
end

get "/contacts/:id/edit" do
	@contact = @@rolodex.search_contact(params[:id].to_i)

	if @contact
		@title = "Edit Contact For #{@contact.first_name} #{@contact.last_name}"
		erb :edit_contact
	else
		raise Sinatra::NotFound
	end
end

delete "/contacts/:id" do
	@contact = @@rolodex.delete_contact(params[:id].to_i)

	if @contact
		redirect to("/contacts")
	else
		raise Sinatra::NotFound
	end
end

post "/contacts" do
	# for testing do not add when adding code to actully projects
	puts params

	new_contact = Contact.new(params[:first_name], params[:last_name], params[:email], params[:note])
	@@rolodex.add_contact(new_contact)
	redirect to("/contacts")
end

put "/contacts/:id" do
	@contact = @@rolodex.search_contact(params[:id].to_i)

	if @contact
		@contact.first_name = params[:first_name]
		@contact.last_name = params[:last_name]
		@contact.email = params[:email]
		@contact.note = params[:note]

		redirect to("/contacts")
	else
		raise Sinatra::NotFound
	end
end
