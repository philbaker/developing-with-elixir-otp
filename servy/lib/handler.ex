defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  @spec log(any) :: any
  def log(conv), do: IO.inspect conv

  def parse(request) do
    [method, path, _] = 
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method,
       path: path,
       resp_body: "",
       status: nil,
    }
  end

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/wildthings") do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(conv, "GET", "/bears") do
    %{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
  end

  def route(conv, "GET", "/bears/" <> id) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def route(conv, _method, path) do
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error",
    }[code]
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)  # => nil
# => "HTTP/1.1 200 OK\nContent-Type: text/html\nContent-Length: 20\n\nBears, Lions, Tigers\n"

# lines = String.split(request, "\n")
# => ["GET /wildthings HTTP/1.1", "Host: example.com",
# =>  "User-Agent: ExampleBrowser/1.0", "Accept: */*", "", ""]
# first_line = List.first(lines)
# => "GET /wildthings HTTP/1.1"
# first_line = request |> String.split("\n") |> List.first
  # => "GET /wildthings HTTP/1.1"
# parts = String.split(first_line, " ")
# => ["GET", "/wildthings", "HTTP/1.1"]
# [method, path, _] = String.split(first_line, " ")
# method
# => "GET"

# pattern matching
# a = 1
# => 1
# a
# => 1
# 1 = a
# => 1
# 2 = a
# => %MatchError{term: 1}
# a = 2
# => 2
# ^a = 3
# => %MatchError{term: 3}

# [1, 2, 3] = [1, 2, 3]
# => [1, 2, 3]
# [first, 2, 3] = [1, 2, 3]
# => [1, 2, 3]
# [first, 2, last] = [1, 2, 3]
# first
# => 1
# last
# => 3
# [first, 7, last] = [1, 2, 3]
# => %MatchError{term: [1, 2, 3]}

# Elixir maps
# conv = %{ method: "GET", path: "/wildthings", resp_body: "" }
# => %{method: "GET", path: "/wildthings", resp_body: ""}
# conv[:method]
# => "GET"
# conv[:path]
# => "/wildthings"
# conv[:mike]
# => nil
# conv.path
# => "/wildthings"
# conv.mike
# => %KeyError{
# =>   key: :mike,
# =>   message: nil,
# =>   term: %{method: "GET", path: "/wildthings", resp_body: ""}
# => }

# Creating a new map with extra keys/values
# conv = Map.put(conv, :resp_body, "Bears")
# => %{method: "GET", path: "/wildthings", resp_body: "Bears"}
# Same as above but shorter (only works for updating existing keys)
# conv = %{ conv | resp_body: "Bears, Lions, Tigers" }
# => %{method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers"}

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)  # => nil

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)  # => nil


request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)  # => nil

# Concatenate strings (binaries) with the less than greater than
# operator
"/bears/" <> "1"
# => "/bears/1"

"/bears/" <> id = "/bears/1"
# => "/bears/1"
id
# => "1"


