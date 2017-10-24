defmodule ApiAuthentication.Mixfile do
  use Mix.Project

  def project do
    [
      app: :api_authentication,
      elixirc_paths: elixirc_paths(Mix.env),
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: "A module for API Token based authentication in Phoenix.",
      docs: [
        main: "ApiAuthentication"
      ],
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [applications: applications(Mix.env)]
  end

  defp package do
    [
      maintainers: ["Razvan Draghici"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/tzumby/api_authentication"}
    ]
  end

  defp applications(:test), do: [:postgrex, :ecto, :logger]
  defp applications(_), do: [:logger]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.2"},
      {:postgrex, "~> 0.13"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 1.0"},
      {:secure_random, "~> 0.5"},
      {:plug, "~> 1.4"},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, "~> 0.10", only: :dev}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
