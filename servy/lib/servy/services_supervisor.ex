defmodule Servy.ServicesSupervisor do
  use Supervisor

  def start_link do
    IO.puts("Starting the services supervisor...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    %{conv | status: 200, resp_content_type: "application/json", resp_body: json}
  end
end
