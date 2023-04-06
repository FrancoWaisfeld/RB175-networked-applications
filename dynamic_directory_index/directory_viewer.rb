require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @files = Dir.glob("public/*").map { |file| file[/(?<=\/).+/]}.sort
  @files.reverse! if params[:sort] == "reverse"

  erb :page
end