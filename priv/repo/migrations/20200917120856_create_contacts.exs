defmodule CaseCsContactManager.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :case_id, :string
      add :title, :string
      add :first_name, :string
      add :last_name, :string
      add :mobile_number, :string
      add :address, :string

      timestamps()
    end

  end
end
