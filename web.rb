## setup ENV
require 'dotenv'
Dotenv.load

## setup App
require 'sinatra'
require "redis"
require "yaml"
require "pry"

SECRETS = YAML.load_file(
            File.expand_path("config/secrets.yml")
          )
DATASTORE = SECRETS["datastore"][ENV["RACK_ENV"]]

def protected!
  return if authorized?
  headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
  halt 401, "Not authorized\n"
end

def authorized?
  @auth ||=  Rack::Auth::Basic::Request.new(request.env)
  @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [ SECRETS["user"], SECRETS["password"]]
end

get '/' do
  @redis = Redis.new(connection_hash)
  erb :index
end

get '/admin' do
  protected!
  @redis = Redis.new(connection_hash)
  erb :admin
end

post '/save' do
  protected!
  @redis = Redis.new(connection_hash)
  text = params.fetch('page', '').strip
  @redis.set "index.html", text
  redirect to('/')
end


def connection_hash
    {
      host:     DATASTORE["host"],
      login:    DATASTORE["login"],
      password: DATASTORE["password"],
      port:     DATASTORE["port"]
    }
end
