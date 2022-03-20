# defmodule Servy.Examples do
# end

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

# request = """
# GET /about HTTP/1.1\r
# Host: example.com\r
# User-Agent: ExampleBrowser/1.0\r
# Accept: */*
# \r
# """

# response = Servy.Handler.handle(request) 
# => %{method: "GET", path: "/about", resp_body: "", status: nil}
# => "HTTP/1.1 200 OK\nContent-Type: text/html\nContent-Length: 330\n\n<h1>Clark's Wildthings Refuge</h1>\n\n<blockquote>\n  When we contemplate the whole globe as one great dewdrop,\n  striped and dotted with continents and isladns, flying through\n  space with other stars all singing and shining together as one,\n  the whole universe appears as an infinite storm of beauty.\n  -- John Muir\n</blockquote>\n\n"

# IO.puts response

# request = """
# POST /bears HTTP/1.1\r
# Host: example.com\r
# User-Agent: ExampleBrowser/1.0\r
# Accept: */*\r
# Content-Type: application/x-www-form-urlencoded\r
# Content-Length: 21\r
# \r

# name=Baloo&type=Brown
# """

# response = Servy.Handler.handle(request)

# IO.puts response

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

# request = """
# GET /bears HTTP/1.1\r
# Host: example.com\r
# User-Agent: ExampleBrowser/1.0\r
# Accept: */*\r
# \r
# """

# response = Servy.Handler.handle(request)

# IO.puts response

# request = """
# GET /bears/1 HTTP/1.1\r
# Host: example.com\r
# User-Agent: ExampleBrowser/1.0\r
# Accept: */*\r
# \r
# """

# response = Servy.Handler.handle(request)

# IO.puts response

# phrases = ["lions", "tigers", "bears", "oh my"]
# => ["lions", "tigers", "bears", "oh my"]
# Enum.map(phrases, fn(x) -> String.upcase(x) end)
# => ["LIONS", "TIGERS", "BEARS", "OH MY"]
# Enum.map(phrases, &String.upcase(&1))
# => ["LIONS", "TIGERS", "BEARS", "OH MY"]

# list comprehension
# for x <- [1, 2, 3], do: x * 3
# => [3, 6, 9]
# for size <- ["S", "M", "L"], color <- [:red, :blue], do: {size, color}
# => [
# =>   {"S", :red},
# =>   {"S", :blue},
# =>   {"M", :red},
# =>   {"M", :blue},
# =>   {"L", :red},
# =>   {"L", :blue}
# => ]

# bears = Servy.Wildthings.list_bears()
# => [
# =>   %Servy.Bear{hibernating: true, id: 1, name: "Teddy", type: "Brown"},
# =>   %Servy.Bear{hibernating: false, id: 2, name: "Smokey", type: "Black"},
# =>   %Servy.Bear{hibernating: false, id: 3, name: "Paddington", type: "Brown"},
# =>   %Servy.Bear{hibernating: true, id: 4, name: "Scarface", type: "Grizzly"},
# =>   %Servy.Bear{hibernating: false, id: 5, name: "Snow", type: "Polar"},
# =>   %Servy.Bear{hibernating: false, id: 6, name: "Brutus", type: "Grizzly"},
# =>   %Servy.Bear{hibernating: true, id: 7, name: "Rosie", type: "Black"},
# =>   %Servy.Bear{hibernating: false, id: 8, name: "Roscoe", type: "Panda"},
# =>   %Servy.Bear{hibernating: true, id: 9, name: "Iceman", type: "Polar"},
# =>   %Servy.Bear{hibernating: false, id: 10, name: "Kenai", type: "Grizzly"}
# => ]
# Poison.encode(bears)
# => {:ok,
# =>  "[{\"type\":\"Brown\",\"name\":\"Teddy\",\"id\":1,\"hibernating\":true},{\"type\":\"Black\",\"name\":\"Smokey\",\"id\":2,\"hibernating\":false},{\"type\":\"Brown\",\"name\":\"Paddington\",\"id\":3,\"hibernating\":false},{\"type\":\"Grizzly\",\"name\":\"Scarface\",\"id\":4,\"hibernating\":true},{\"type\":\"Polar\",\"name\":\"Snow\",\"id\":5,\"hibernating\":false},{\"type\":\"Grizzly\",\"name\":\"Brutus\",\"id\":6,\"hibernating\":false},{\"type\":\"Black\",\"name\":\"Rosie\",\"id\":7,\"hibernating\":true},{\"type\":\"Panda\",\"name\":\"Roscoe\",\"id\":8,\"hibernating\":false},{\"type\":\"Polar\",\"name\":\"Iceman\",\"id\":9,\"hibernating\":true},{\"type\":\"Grizzly\",\"name\":\"Kenai\",\"id\":10,\"hibernating\":false}]"}
