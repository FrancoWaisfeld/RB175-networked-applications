require "socket"

def parse_http_method(request)
  request[/(^\S+){1}/]
end

def parse_path(request)
  request[/(?<=GET ).*?(?=\?)/]
end

def parse_query_parameters(request)
  query_parameters = (request[/(?<=\?).*?(?=\/)/] || "").split("&")

  query_parameters = query_parameters.to_h do |parameter|
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

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html\r\n\r\n"
  client.puts "<html>"
  client.puts "<body>"

  client.puts "<h1>Counter</h1>"

  number = params["number"].to_i

  client.puts"<p>The current number is #{number}.</p>"
  client.puts"<a href=\"?number=#{number + 1}\">Add one</a>"
  client.puts"<a href=\"?number=#{number + -1}\">Subtract one</a>"
  
  client.puts "<body>"
  client.puts "<html>"
  client.close
end
