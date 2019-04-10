defmodule HordeTest do
  require Logger

  def set_members(nodes) do
    nodes
    |> Enum.map(fn i -> {HordeTest.Workers, node_name(i)} end)
    |> (&Horde.Cluster.set_members(HordeTest.Workers, &1)).()

    nodes
    |> Enum.map(fn i -> {HordeTest.Registry, node_name(i)} end)
    |> (&Horde.Cluster.set_members(HordeTest.Registry, &1)).()
  end

  def members() do
    Logger.info(
      "Members for HordeTest.Workers: \n #{inspect(Horde.Cluster.members(HordeTest.Workers))}"
    )

    Logger.info("====================")

    Logger.info(
      "Members for HordeTest.Registry: \n #{inspect(Horde.Cluster.members(HordeTest.Registry))}"
    )
  end

  def netsplit(cookie \\ :cookie) do
    Node.set_cookie(cookie)

    1..2
    |> Enum.map(fn i -> Node.disconnect(node_name(i)) end)
  end

  def heal(cookie \\ :cookie) do
    Node.set_cookie(cookie)

    1..2
    |> Enum.map(fn i -> Node.connect(node_name(i)) end)
  end

  defp node_name(i), do: :"node#{i}@127.0.0.1"
end

# These exist purely for iex autocompletion
defmodule HordeTest.Registry do
end

defmodule HordeTest.Workers do
  def start_worker(name) do
    Horde.Supervisor.start_child(HordeTest.Workers, HordeTest.Worker.child_spec(name))
  end

  def whereis_name(n) do
    Horde.Registry.whereis_name({HordeTest.Registry, n})
  end
end

defmodule HordeTest.Worker do
  use GenServer
  require Logger

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(name))
  end

  def init(state) do
    Logger.info("Starting worker as #{inspect(self())}")
    {:ok, state}
  end

  def via_tuple(name) do
    {:via, Horde.Registry, {HordeTest.Registry, name}}
  end

  def child_spec(name) do
    %{
      id: :"#{__MODULE__}.#{name}",
      start: {__MODULE__, :start_link, [name]}
    }
  end
end
