defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def track(%{ status: 404, path: path } = conv) do
    IO.puts "Warning: #{path} is on the loose!"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{ path: "/wildlife" } = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(conv), do: conv

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

  def route(%{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%{ method: "GET", path: "/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Teddy, Smokey, Paddington" }
  end

  def route(%{ method: "GET", path: "/bears" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def route(%{ method: "GET", path: "/about" } = conv) do
    Path.expand("../../pages", __DIR__)
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{ path: path } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def handle_file({ :ok, content }, conv) do
    %{ conv | status: 200, resp_body: content }
  end

  def handle_file({ :error, :enoent }, conv) do
    %{ conv | status: 400, resp_body: "File not found!" }
  end

  def handle_file({ :error, reason }, conv) do
    %{ conv | status: 500, resp_body: "File error: #{reason}" }
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

# request = """
# GET /wildthings HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)  # => nil
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

# request = """
# GET /bears HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)  # => nil

# request = """
# GET /bigfoot HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)  # => nil


# request = """
# GET /bears/1 HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)  # => nil

# Concatenate strings (binaries) with the less than greater than
# operator
# "/bears/" <> "1"
# => "/bears/1"

# "/bears/" <> id = "/bears/1"
# => "/bears/1"
# id
# => "1"

# request = """
# DELETE /wildlife HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)  # => nil

# conv = %{ method: "GET", path: "/wildlife" }
# => %{method: "GET", path: "/wildlife"}
# %{ path: "/wildlife" } = conv
# => %{method: "GET", path: "/wildlife"}
# %{ path: "/bears" } = conv
# => %MatchError{term: %{method: "GET", path: "/wildlife"}}
# %{ name: "mike", path: "/wildlife" } = conv
# => %MatchError{term: %{method: "GET", path: "/wildlife"}}
# %{ method: "GET" } = conv
# => %{method: "GET", path: "/wildlife"}
# %{ method: _method, path: "/wildlife" } = conv
# => %{method: "GET", path: "/wildlife"}
# %{ method: _method, path: _path } = conv
# => %{method: "GET", path: "/wildlife"}

# request = """
# GET /about HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handle(request)  # => nil

# { :ok, contents } = File.read("pages/about.html")
# => {:ok,
# =>  "<h1>Clark's Wildthings Refuge</h1>\n\n<blockquote>\n  When we contemplate the whole globe as one great dewdrop,\n  striped and dotted with continents and isladns, flying through\n  space with other stars all singing and shining together as one,\n  the whole universe appears as an infinite storm of beauty.\n  -- John Muir\n</blockquote>\n"}

# { :ok, contents } = File.read("pages/about-us.html")
# => %MatchError{term: {:error, :enoent}}
# { :error, reason } = File.read("pages/about-us.html")
# => {:error, :enoent}


request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request) 
# => %{method: "GET", path: "/about", resp_body: "", status: nil}
# => "HTTP/1.1 200 OK\nContent-Type: text/html\nContent-Length: 330\n\n<h1>Clark's Wildthings Refuge</h1>\n\n<blockquote>\n  When we contemplate the whole globe as one great dewdrop,\n  striped and dotted with continents and isladns, flying through\n  space with other stars all singing and shining together as one,\n  the whole universe appears as an infinite storm of beauty.\n  -- John Muir\n</blockquote>\n\n"

IO.puts response
