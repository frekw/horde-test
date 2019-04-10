defmodule HordeTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Horde.Supervisor, [name: HordeTest.Workers, strategy: :one_for_one]},
      {Horde.Registry, [name: HordeTest.Registry, keys: :unique]}
    ]

    opts = [strategy: :one_for_one, name: HordeTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
