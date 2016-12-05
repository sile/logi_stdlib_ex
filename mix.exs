defmodule LogiStd.Mixfile do
  use Mix.Project

  def project do
    [app: :logi_stdlib_ex,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: "The standard library for logi_ex",
     package: [
       maintainers: ["Takeru Ohta"],
       licenses: ["MIT"],
       links: %{"GitHub" => "https://github.com/sile/logi_stdlib_ex"}
     ],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     docs: docs()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logi_ex, :logi_stdlib]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:logi_ex, "~> 0.1.1"},
      {:logi_stdlib, "~> 0.1"},
      {:earmark, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev}
    ]
  end

  defp docs do
    [deps: [logi: "https://hexdocs.pm/logi_ex"]]
  end
end
