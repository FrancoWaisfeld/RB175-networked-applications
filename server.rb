require "socket"

def parse_http_method(request)
  request[/(^\S+){1}/]
end

def parse_path(request)
  request[/(?<=GET ).*?(?=\?)/]
end

def parse_query_parameters(request)
  query_parameters = request[/(?<=\?).*?(?=\/)/].split("&")

  query_parameters.to_h do |parameter|
    parameter.split("=")
  end
end

def parse_request(request)
  http_method = parse_http_method(request)
  path = parse_path(request)
  params = parse_query_parameters(request)
  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  _http_method, _path, params = parse_request(request_line)
  rolls = params["rolls"].to_i
  sides = params["sides"].to_i

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html\r\n\r\n"
  client.puts "<html>"
  client.puts "<body>"
  
  client.puts "<h1>Rolls</h1>"
  rolls.times do
    roll = rand(sides) + 1
    client.puts "<p>#{roll}</p>"
  end

  client.puts "<body>"
  client.puts "<html>"
  client.close
end
