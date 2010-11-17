require 'rubygems'
require 'sinatra'
require 'erb'
require 'helpers'

begin
  memory = load_memory
rescue Exception => e
  memory = {}
end

before do
  content_type "text/txt", :charset => 'utf-8'
end

get '/' do
  "Hello " + request.user_agent + "!"
end

get '/todos' do
  @todos = memory.values
  format = get_format
  
  content_type get_mimetype, :charset => 'utf-8'
  erb :"list.#{format}"
end

post '/todos/:id' do
  if memory.keys.include? params[:id]
    status 405
    "Todo already exist"
  elsif not params[:name]
    status 400
    "Name is required"
  else
    memory[params[:id]] = Todo.new(params[:id], params[:name], "false")
    save(memory)
    status 201
    "Created"
  end
end

put '/todos/:id' do
  if not memory.keys.include? params[:id]
    status 404
    "Todo not found"
  else
    if memory[params[:id]].completed == "false"
      memory[params[:id]].completed = "true"
    else
      memory[params[:id]].completed = "false"
    end
    save(memory)
    status 200
    "Updated"
  end
end

delete '/todos/:id' do
  if not memory.keys.include? params[:id]
    status 404
    "Todo not found"
  else
    memory.delete params[:id]
    save(memory)
    status 200
    "Deleted"
  end
end