defmodule SwarmDemo.SessionWorker do
  use GenServer
  
  def start_link(name) do
    GenServer.start_link(__MODULE__, name)
  end

  def init([name: name]) do
    IO.puts("#{name}s session started!")
    {:ok, {name, %{}}}
  end
  
  def handle_call(:player_items, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:swarm, :begin_handoff}, _from, state) do
    {:reply, {:resume, state}, state}
  end

  def handle_cast({:swarm, :end_handoff, old_state}, _state) do
    {:noreply, old_state}
  end

  def handle_cast({:add, type, number}, {name, items}) do
    IO.puts("[#{name}] Adding #{number} #{type}")
    {:noreply, _new_state({{name, items}, type, number})}
  end

  def handle_cast(:restart , _state) do
    {:noreply, %{}}
  end

  def handle_info(:hello, {name, items}) do
    IO.puts("[#{name}] Hello from #{inspect(self())}")
    {:noreply, {name, items}}
  end

  def handle_info({:swarm, :die}, state) do
    {:stop, :shutdown, state}
  end

  defp _new_state({{name, items} , type, number}) do
    {name, Map.update(items, type, 1, &(&1 + number))}
  end
end
