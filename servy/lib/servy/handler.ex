defmodule Servy.Handler do

  @moduledoc "Handles HTTP requests"

  alias Servy.Conv
  alias Servy.BearController

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]

  @doc "Transforms the request into a response"
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def route(%Conv{ method: "GET", path: "/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{ method: "GET", path: "/bears" } = conv) do
    BearController.index(conv)
  end

  def route(%Conv{ method: "GET", path: "/bears/" <> id } = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{ method: "POST", path: "/bears" } = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{ method: "GET", path: "/about" } = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{ path: path } = conv) do
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

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  def loopy([head | tail]) do
    IO.puts "Head: #{head} Tail: #{inspect(tail)}"
    loopy(tail)
  end

  def loopy([]), do: IO.puts "Done!"
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
# GET /bigfoot HTTP/1.1
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

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Servy.Handler.handle(request)

IO.puts response

# nums = [1, 2, 3, 4, 5]
# => [1, 2, 3, 4, 5]
# [a, b, c, d, e] = nums
# => [1, 2, 3, 4, 5]
# a
# => 1
# e
# => 5
# [head | tail] = nums
# => [1, 2, 3, 4, 5]
# head
# => 1
# tail
# => [2, 3, 4, 5]
# [head | tail] = tail
# => [2, 3, 4, 5]
# head
# => 2
# tail
# => [3, 4, 5]
# [head | tail] = tail
# => [3, 4, 5]
# head
# => 3
# tail
# => [4, 5]
# [head | tail] = tail
# => [4, 5]
# head
# => 4
# tail
# => [5]
# [head | tail] = tail
# => [5]
# head
# => 5
# tail
# => []
# [head | tail] = tail
# => %MatchError{term: []}

# URI.decode_query("name=Baloo&type=Brown")
# => %{"name" => "Baloo", "type" => "Brown"}

# Servy.Handler.loopy([1, 2, 3, 4, 5])
# Head: 1 Tail: [2, 3, 4, 5]
# Head: 2 Tail: [3, 4, 5]
# Head: 3 Tail: [4, 5]
# Head: 4 Tail: [5]
# Head: 5 Tail: []
# Done!

# request = """
# POST /bears HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
# Content-Type: multipart/form-data
# Content-Length: 21

# name=Baloo&type=Brown
# """

# response = Servy.Handler.handle(request)

# IO.puts response

# Enum.map([1, 2, 3], fn(x) -> x * 3 end)
# => [3, 6, 9]

# triple = fn(x) -> x * 3 end
# => #Function<44.65746770/1 in :erl_eval.expr/5>
# triple.(10)
# => 30
# Enum.map([1, 2, 3], triple)
# => [3, 6, 9]

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

# phrases = ["lions", "tigers", "bears", "oh my"]
# => ["lions", "tigers", "bears", "oh my"]
# Enum.map(phrases, fn(x) -> String.upcase(x) end)
# => ["LIONS", "TIGERS", "BEARS", "OH MY"]
# Enum.map(phrases, &String.upcase(&1))
# => ["LIONS", "TIGERS", "BEARS", "OH MY"]

# list comprehension
# for x <- [1, 2, 3], do: x * 3
# => [3, 6, 9]
