defmodule Servy.ServicesSupervisor do
  use Supervisor

  def start_link(_arg) do
    IO.puts("Starting the services supervisor...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.PledgeServer,
      {Servy.SensorServer, 60}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

# {:ok, sup_pid} = Servy.ServicesSupervisor.start_link()

# Supervisor.which_children(sup_pid)

# Supervisor.count_children(sup_pid)

# Process.whereis(:sensor_server) |> Process.exit(:kaboom)

# Process.whereis(:pledge_server) |> Process.exit(:kaboom)

# Servy.PledgeServer.child_spec([])
