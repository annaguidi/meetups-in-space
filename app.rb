require 'sinatra'
require_relative 'config/application'
require 'pry'

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @events = Event.all.order(name: :asc)
  erb :'meetups/index'
end

get '/meetups/meetup/:id' do
  @event = Event.find(params[:id])
  @creator = Member.where(creator: true).find_by(event: @event).user
  @members = @event.users


  erb :'meetups/show'
end

get '/meetups/new' do
  @name = session[:name]
  session.delete(:name)
  @description = session[:description]
  session.delete(:description)
  @location = session[:location]
  session.delete(:location)
  erb :'meetups/new'
end

post '/meetups/new' do
  @error_message = nil
  @name = params["name"]
  @description = params["description"]
  @location = params["location"]

  if !current_user.nil?
    Event.create(
    name: "#{@name}", description: "#{@description}", location: "#{@location}")

    @last = Event.last

    Member.create(
    event_id: "#{@last.id}",
    user_id: "#{current_user.id}",
    creator: true
    )

    redirect "/meetups/meetup/#{@last.id}"
  else
    session[:name] = @name
    session[:description] = @description
    session[:location] = @location

    @error_message = true
    redirect "/meetups/new"
  end
end

post '/meetups/join/:id' do
  @error_message = nil

  if !current_user.nil?
    current_user
    Member.create(
      event_id: "#{params[:id]}",
      user_id: "#{current_user.id}",
      creator: false
    )
    @event = Event.find(params[:id])
    @creator = Member.where(creator: true).find_by(event: @event).user
    @members = @event.users
    erb :'meetups/show'
  else
    @error_message = true
    @error = 'join'
    @event = Event.find(params[:id])
    @creator = Member.where(creator: true).find_by(event: @event).user
    @members = @event.users
    erb :'meetups/show'
  end
end

get '/meetups/meetup/:id/edit' do
  @event = Event.find(params[:id])
  erb :'meetups/edit'
end

patch '/meetups/meetup/:id' do
  @event = Event.find(params[:id])
  @event.location = params["location"]
  @event.save
  @event.name = params["name"]
  @event.save
  @event.description = params["description"]
  @event.save

  redirect "/meetups/meetup/#{params[:id]}"

end

delete '/meetups/meetup/:id' do
  Event.find(params[:id]).delete
  redirect '/'
end

post '/meetups/leave/:id' do
  @error_message = nil
  if !current_user.nil?
    @event = Event.find(params[:id])
    Member.where(event: @event).find_by(user: current_user).delete
    redirect "/meetups/meetup/#{params[:id]}"
  else
    @error_message = true
    @error = 'leave'
    @event = Event.find(params[:id])
    @creator = Member.where(creator: true).find_by(event: @event).user
    @members = @event.users
    erb :'meetups/show'
  end
end
