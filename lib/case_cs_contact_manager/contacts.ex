defmodule CaseCsContactManager.Contacts do
  @moduledoc """
  The Contacts context.
  """

  import Ecto.Query, warn: false
  alias CaseCsContactManager.{Repo, PubSub}

  alias CaseCsContactManager.Contacts.{Contact, ContactChange}

  @doc """
  Returns the list of contacts.

  ## Examples

      iex> list_contacts()
      [%Contact{}, ...]

  """
  def list_contacts do
    Repo.all(Contact)
  end

  @spec list_contacts_by_case(String.t()) :: [Contact.t()]
  def list_contacts_by_case(case_id) do
    from(Contact, where: [case_id: ^case_id], order_by: [desc: :updated_at])
    |> Repo.all()
  end

  @doc """
  Returns a list of %Contact{} with distinct values for case_id
  """
  @spec unique_by_case() :: [Contact.t()]
  def unique_by_case do
    from(Contact, distinct: true, select: [:case_id], order_by: :case_id)
    |> Repo.all()
  end

  @doc """
  Gets a single contact.

  Raises `Ecto.NoResultsError` if the Contact does not exist.

  ## Examples

      iex> get_contact!(123)
      %Contact{}

      iex> get_contact!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contact!(id), do: Repo.get!(Contact, id)

  @doc """
  Creates a contact.

  ## Examples

      iex> create_contact(%{field: value})
      {:ok, %Contact{}}

      iex> create_contact(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contact(attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a contact.

  ## Examples

      iex> update_contact(contact, %{field: new_value})
      {:ok, %Contact{}}

      iex> update_contact(contact, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a contact.

  ## Examples

      iex> delete_contact(contact)
      {:ok, %Contact{}}

      iex> delete_contact(contact)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contact changes.

  ## Examples

      iex> change_contact(contact)
      %Ecto.Changeset{data: %Contact{}}

  """
  def change_contact(%Contact{} = contact, attrs \\ %{}) do
    Contact.changeset(contact, attrs)
  end

  @spec publish_change(Contact.t(), Ecto.Changeset.t(), String.t(), ContactChange.change_type()) ::
          :ok
  def publish_change(%Contact{} = contact, changeset, user_id, type) do
    now = DateTime.utc_now()
    changed_fields = Map.keys(changeset.changes)

    %ContactChange{
      contact_id: contact.id,
      case_id: contact.case_id,
      fields: changed_fields,
      date: now,
      type: type,
      user_id: user_id
    }
    |> PubSub.publish_contact_changed()
  end
end
