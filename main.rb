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

get '/' do
  mpg = Milage.all
  content_type :json
  mpg.to_json
end

post '/' do 
  mpg = params[:miles].to_f / params[:gallons].to_f
  fill_up = Milage.new(:miles => params[:miles], :gallons => params[:gallons], :mpg => mpg)
  if fill_up.save
    status 201
  else
    status 412
  end
end
