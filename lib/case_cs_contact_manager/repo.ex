defmodule CaseCsContactManager.Repo do
  use Ecto.Repo,
    otp_app: :case_cs_contact_manager,
    adapter: Ecto.Adapters.Postgres
end
