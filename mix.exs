defmodule HordeTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :hord_test,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {HordeTest.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:horde, "0.5.0-rc.12"}
    ]
  end
end
