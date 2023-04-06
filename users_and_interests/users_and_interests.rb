require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require "yaml"

=begin
explicit rules:
- the home page will redirect to a page that lists all the users names.
  - load users from users.yml file
  - each of the users names is a link to a page for that user
    - on each user page display email address, and interests (each being comma
      seperated.)
      - at the bottom of each user page list links to all other user pages,
        other than the current user.
- At the bottom of all pages add a display message: "There are X users with a
  total of X interests." 
  - The X variables are deteremiend by the users and interests in the users.yml
    file.
  - Use a view helper method, count_interests, to determine the total number of
    interests across all users

Database: hash

algorithm:
- commonly available hash, users, that lists the users names as keys. (pull data from users.yml file)
  - The values is another subhash, each containing two keys, email and interests.
    - the value for the email key is just the users email
    - the value for the interests key is an array of the users interests.
- count_users helper method that counts the users in the users hash
  - count the keys in the users hash
- count_interests helper method that counts the interests in the users hash
  - set a variable interests_count to 0
  - iterate through the values in the users hash
    - access the array associated with the interests key
      - increment the interests_count varialbe by the count of elements in the
        array
  - return interests_count
- general layout page that displays a message "There are X users with a
  total of X interests."
  - use the count_users and count_intersts helper methods to replace the 'X's
- home page that lists all users names.
  - each user's name is a link
  - iterate through the keys in the users hash
- user page that displays email address, and interests (each being comma
  seperated.)
- at the bottom of each user page list links to all other user pages,
  other than the current user.
  - iterate through the keys in the users hash
    - next if current route parameter is the same as the next name in the list
=end

helpers do
  def count_users
    @users.keys.count
  end

  def count_interests
    @users.inject(0) do |sum, (_, value)|
      sum + value[:interests].size
    end
  end
end

before do
  @users = YAML.load_file("users.yml")
end

get "/" do
  redirect "/home"
end

get "/home" do
  erb :home
end

get "/users/:name" do
  @user_name = params[:name].to_sym
  @email = @users[@user_name][:email]
  @interests = @users[@user_name][:interests]

  erb :user
end

