require 'sinatra'
require 'data_mapper'
require 'json'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class Milage
  include DataMapper::Resource
  property :id,          Serial
  property :mpg,         Numeric, :required => true
  property :miles,       Numeric, :required => true
  property :gallons,     Numeric, :required => true
  property :created_at,  DateTime
  property :updated_at,  DateTime
end

DataMapper.finalize

get '/milage.?:format?' do
  mpg = Milage.all(:order => [ :created_at.desc ])
  case params[:format]
  when 'json'
    content_type :json
    mpg.to_json
  else
    @mpg = mpg
    erb :milage
  end
end

get '/.?:format?' do
  erb :index
end

post '/' do 
  mpg = params[:miles].to_f / params[:gallons].to_f
  fill_up = Milage.new(:miles => params[:miles], :gallons => params[:gallons], :mpg => mpg, :created_at => params[:created_at])
  if fill_up.save
    status 201
  else
    status 412
  end
end
