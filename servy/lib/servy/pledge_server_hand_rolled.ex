defmodule Servy.GenericServerHandRolled do
  def start(callback_module, initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def call(pid, message) do
    send(pid, {:call, self(), message})

    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send(sender, {:response, response})
        listen_loop(new_state, callback_module)

      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        listen_loop(state, callback_module)
    end
  end
end

defmodule Servy.PledgeServerHandRolled do
  @name :pledge_server_hand_rolled

  alias Servy.GenericServerHandRolled

  # Client interface functions

  def start do
    IO.puts("Starting the pledge server")
    GenericServerHandRolled.start(__MODULE__, [], @name)
  end

  def create_pledge(name, amount) do
    GenericServerHandRolled.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges do
    GenericServerHandRolled.call(@name, :recent_pledges)
  end

  def total_pledged do
    GenericServerHandRolled.call(@name, :total_pledged)
  end

  def clear do
    GenericServerHandRolled.cast(@name, :clear)
  end

  # Server callbacks

  def handle_cast(:clear, _state) do
    []
  end

  def handle_call(:total_pledged, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum()
    {total, state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_pledges]
    {id, new_state}
  end

  defp send_pledge_to_service(_name, _amount) do
    # Code to send pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# alias Servy.PledgeServerHandRolled
# pid = PledgeServerHandRolled.start
# send pid, {:stop, "hammertime"}
# PledgeServerHandRolled.create_pledge("larry", 10)
# PledgeServerHandRolled.create_pledge("moe", 20)
# PledgeServerHandRolled.create_pledge("curly", 30)
# PledgeServerHandRolled.create_pledge("daisy", 40)

# PledgeServerHandRolled.clear()

# PledgeServerHandRolled.create_pledge("grace", 50)

# PledgeServerHandRolled.recent_pledges()

# PledgeServerHandRolled.total_pledged()

# Process.info(pid, :messages)
