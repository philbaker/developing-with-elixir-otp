defmodule Servy.BearController do

  alias Servy.Wildthings
  alias Servy.Bear

  @templates_path Path.expand("../../templates", __DIR__)

  # Enum.map(phrases, &String.upcase(&1))
  def index(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    content =
      @templates_path
      |> Path.join("index.eex")
      |> EEx.eval_file(bears: bears)
    

    %{ conv | status: 200, resp_body: content }
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    
    %{ conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>" }
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}" }
  end
end
