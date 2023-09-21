require 'sinatra'
require 'sinatra/base'
require 'erb'
require 'sinatra/contrib/all'
require 'bcrypt'


#


## auth
def hash_password(password)
  BCrypt::Password.create(password).to_s
end

def test_password(password, hash)
  BCrypt::Password.new(hash) == password
end

User = Struct.new(:id, :username, :password_hash)
USERS = [
  User.new(1, 'mostafa', hash_password('123')),
  User.new(2, 'adam', hash_password('789')),
]

class Auth < Sinatra::Base
  # config
  enable :inline_templates
  set :views, 'views'
  enable :sessions

  # helper
  helpers do
    def current_user
      if session[:user_id]
        USERS.find { |u| u.id == session[:user_id]}
      else
        nil
      end
    end
  end

  # routes

  get '/' do
    if current_user
      erb :home
    else
      redirect '/sign_in'
    end
  end

  get '/sign_in' do
    erb :sign_in #, {:layout => :auth_layout}
  end

  post '/sign_in' do
    user = USERS.find { |u| u.username == params[:username]}
    if user && test_password(params[:password], user.password_hash)
      session.clear
      session[:user_id] = user.id
      redirect '/'
    else
      @error = 'Username or password was incorrect'
      erb :sign_in
    end
  end

  post '/sign_up' do
    USERS << User.new(USERS.size+1, params[:username], hash_password(params[:password]))
    redirect '/'
  end

  post '/sign_out' do
    session.clear
    redirect '/sign_in'
  end


  run!

end
