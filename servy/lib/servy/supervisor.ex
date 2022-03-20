defmodule Servy.Supervisor do
  use Supervisor

  def start_link do
    IO.puts("Starting THE supervisor...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.KickStarter,
      Servy.ServicesSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

# {:ok, sup_pid} = Servy.Supervisor.start_link()

# Servy.KickStarter.child_spec([])

# Servy.ServicesSupervisor.child_spec([])

# Process.whereis(:http_server) |> Process.exit(:kaboom)

# Process.whereis(:pledge_server) |> Process.exit(:kaboom)

# pid = Process.whereis(Servy.ServicesSupervisor)

# Process.exit(pid, :kill)

# Application.started_applications()

