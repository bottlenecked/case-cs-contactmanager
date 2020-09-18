defmodule CaseCsContactManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      CaseCsContactManager.Repo,
      # Start the Telemetry supervisor
      CaseCsContactManagerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CaseCsContactManager.PubSub},
      # Start the Endpoint (http/https)
      CaseCsContactManagerWeb.Endpoint,
      # Start a worker by calling: CaseCsContactManager.Worker.start_link(arg)
      # {CaseCsContactManager.Worker, arg}
      {Registry,
       keys: :duplicate, name: :contacts_pub_sub, partitions: System.schedulers_online()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CaseCsContactManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CaseCsContactManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
