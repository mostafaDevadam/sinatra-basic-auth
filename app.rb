require 'sinatra'
require 'sinatra/base'
require 'erb'
#require "sinatra/content_for"
require 'sinatra/contrib/all'


# config
set :public_folder, __dir__ + '/static'
set :views, 'views'
enable :sessions

# functions
def yield_me
  yield
end


# routes
get '/' do
    redirect '/index.html'
end

get '/erb/:name' do
    erb :index, { :locals => params }
end

get '/ana/:name' do
 # template = "<h1>Hello <%= name %></h1>"
 #  layout   = "<html><body><%= yield %></body></html>"
  erb :index, { :locals => params } #, :layout => :layout }
end

get '/m' do
  erb :body, :layout => :layout do
    erb :foobar
  end

end

get '/n/:name' do
  @name = params["name"]
  erb :show, :layout => :layout do
    erb :about , { :locals => params}
  end
end

#
def store_name(filename, string)
  File.open(filename, "a+") do |file|
    file.puts(string)
  end
end

def read_names()
  return [] unless File.exist?("names.txt")
  File.read("names.txt").split("\n")
end

##
get '/form' do
  @msg = session[:msg]
  @username = session[:username]
  @names = read_names
  erb :form
end

##
post '/form' do
   @name = params["name"]
   store_name("names.txt", @name)
   session[:msg] = "done"
   session[:username] = @name
   #@names = read_names
   #erb :form
   redirect "/form" #?name=#{@name}"
end



