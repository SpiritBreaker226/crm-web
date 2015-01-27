require_relative "./rolodex"
require_relative "./contact"

require "sinatra"

$rolodex = Rolodex.new

get "/" do
	@crm_app_name = "My CRM"
	erb :index
end

get "/contacts" do
	erb :contacts
end

get "/contacts/new" do
end