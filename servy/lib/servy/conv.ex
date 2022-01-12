defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            params: %{},
            headers: %{},
            resp_body: "",
            status: nil

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
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

# map = %{}
# => %{}

# conv = %Servy.Conv{}
# => %Servy.Conv{method: "", path: "", resp_body: "", status: nil}

# conv = %Servy.Conv{method: "GET", path: "/bears"}
# => %Servy.Conv{method: "GET", path: "/bears", resp_body: "", status: nil}

# conv = %Servy.Conv{method: "GET", path: "/bears", name: "Mike"}
# => %KeyError{key: :name, message: nil, term: nil}
# conv.method
# => "GET"
# conv.path
# => "/bears"
# Note: structs only allow access with the dot notation
# conv[:path]
# => %UndefinedFunctionError{
# =>   arity: 2,
# =>   function: :fetch,
# =>   message: nil,
# =>   module: Servy.Conv,
# =>   reason: "Servy.Conv does not implement the Access behaviour"
# => }

# conv = %{ conv | status: 200 }
# => %Servy.Conv{method: "GET", path: "/bears", resp_body: "", status: 200}

# %Servy.Conv{ method: "GET" } = conv
# => %Servy.Conv{method: "GET", path: "/bears", resp_body: "", status: 200}

# %Servy.Conv{ status: 200 } = conv
# => %Servy.Conv{method: "GET", path: "/bears", resp_body: "", status: 200}

# %Servy.Conv{ method: method } = conv
# => %Servy.Conv{method: "GET", path: "/bears", resp_body: "", status: 200}

# is_map(conv)
# => true

# %{ method: "GET" } = conv
# => %Servy.Conv{method: "GET", path: "/bears", resp_body: "", status: 200}

# %Servy.Conv{ method: "GET" } = %{ method: "GET" }
# => %MatchError{term: %{method: "GET"}}
