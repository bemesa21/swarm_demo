defmodule SwarmDemo.Application do
  use Application

  def start(_type, _args) do
    topologies = [
      my_topology: [
        strategy: Cluster.Strategy.Gossip,
        config: [
          port: 45892,
          if_addr: "0.0.0.0",
          multicast_if: "192.168.1.1",
          multicast_addr: "230.1.1.251",
          multicast_ttl: 1,
          secret: "somepassword"
        ]
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: SwarmDemo.ClusterSupervisor]]},
      {SwarmDemo.WorkersSupervisor, []},
      {SwarmDemo.Simulator, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SwarmDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
