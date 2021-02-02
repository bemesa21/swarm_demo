defmodule SwarmDemo.Simulator do
  use GenServer
  alias SwarmDemo.ExampleUsage
  @items [:coins, :candy, :gifts]
  @players [:susi, :katy, :bob]
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Process.send_after(self(), :send_items, 100)
    {:ok, {@players, :paused}}
  end

  def handle_cast(:resume, {players, _status}) do
    {:noreply, {players, :active}}
  end

  def handle_cast(:pause, {players, _status}) do
    {:noreply, {players, :paused}}
  end
  def handle_info(:send_items, {players, status}) do
    if status == :active do
      ExampleUsage.cast_worker(Enum.random(players), {:add, Enum.random(@items), Enum.random(1..4)})
    end
    Process.send_after(self(), :send_items, Enum.random([1000, 1250, 1500]) )
    {:noreply, {players, status}}
  end

end
