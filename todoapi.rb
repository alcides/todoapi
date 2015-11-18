require 'rubygems'
require 'sinatra'
require 'erb'
require File.expand_path(File.join(File.dirname(__FILE__), 'helpers'))


class TodoAPI < Sinatra::Application


  begin
    memory = load_memory
  rescue Exception => e
    memory = {}
  end

  PUT = {}

  before do
    content_type "text/txt", :charset => 'utf-8'
  
    if request.put?
      request.body.read.split("&").each do |x| 
        p = x.split("=");
        PUT[p[0]] = p[1] 
      end
    end
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

  get '/todos/:id' do
    if not memory.keys.include? params[:id]
      status 404
      "Todo already exist"
    else
      @todo = memory[params[:id]]
      format = get_format
      content_type get_mimetype, :charset => 'utf-8'
      erb :"todo.#{format}"
    end
  end


  put '/todos/:id' do
    if memory.keys.include? params[:id]
      status 405
      "Todo already exist"
    elsif not PUT.keys.include? "name"
      status 400
      "Name is required"  + PUT.to_s
    else
      memory[params[:id]] = Todo.new(params[:id], PUT["name"], "false")
      save(memory)
      status 201
      "Created"
    end
  end

  post '/todos/:id' do
    if not memory.keys.include? params[:id]
      status 404
      "Todo not found"
    else
      if params.keys.include? :name
        memory[params[:id]].name = params[:name]
      end
      if params.keys.include? "completed"
        memory[params[:id]].completed = (params[:completed] == "true")
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
end