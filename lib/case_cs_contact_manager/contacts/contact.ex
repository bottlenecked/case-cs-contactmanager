defmodule CaseCsContactManager.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :address, :string
    field :case_id, :string
    field :first_name, :string
    field :last_name, :string
    field :mobile_number, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:case_id, :title, :first_name, :last_name, :mobile_number, :address])
    |> validate_required([:case_id])
  end
end
