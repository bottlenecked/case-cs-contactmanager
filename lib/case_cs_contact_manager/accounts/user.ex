defmodule CaseCsContactManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :token, :string
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:token])
    |> validate_required([:token])
  end
end
