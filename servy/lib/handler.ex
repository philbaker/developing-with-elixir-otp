defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do
    # TODO: parse the request string into a map:
    first_line = request |> String.split("\n") |> List.first
    conv = %{ method: "GET", path: "/wildthings", resp_body: "" }
  end

  def route(conv) do
    # TODO: create a new map that also has the response body:
    conv = %{ method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers" }
  end

  def format_response(conv) do
    # TODO: use values in the map to create an HTTP response string
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)
# => "HTTP/1.1 200 OK\nContent-Type: text/html\nContent-Length: 20\n\nBears, Lions, Tigers\n"

lines = String.split(request, "\n")
# => ["GET /wildthings HTTP/1.1", "Host: example.com",
# =>  "User-Agent: ExampleBrowser/1.0", "Accept: */*", "", ""]
# first_line = List.first(lines)
# => "GET /wildthings HTTP/1.1"
first_line = request |> String.split("\n") |> List.first
  # => "GET /wildthings HTTP/1.1"
parts = String.split(first_line, " ")
# => ["GET", "/wildthings", "HTTP/1.1"]

# pattern matching
a = 1
# => 1
# a
# => 1
1 = a
# => 1
# 2 = a
# => %MatchError{term: 1}
a = 2
# => 2
# ^a = 3
# => %MatchError{term: 3}

[1, 2, 3] = [1, 2, 3]
# => [1, 2, 3]
[first, 2, 3] = [1, 2, 3]
# => [1, 2, 3]
