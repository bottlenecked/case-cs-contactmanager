defmodule CaseCsContactManagerWeb.ContactController do
  use CaseCsContactManagerWeb, :controller

  alias CaseCsContactManager.Contacts
  alias CaseCsContactManager.Contacts.Contact

  def index(conn, %{"case_id" => case_id}) do
    contacts = Contacts.list_contacts_by_case(case_id)
    render(conn, "index.html", contacts: contacts, case_id: case_id)
  end

  def new(conn, params) do
    case_id = params["case_id"]
    changeset = Contacts.change_contact(%Contact{}, %{case_id: case_id})
    render(conn, "new.html", changeset: changeset, case_id: case_id)
  end

  def create(conn, %{"contact" => contact_params}) do
    case Contacts.create_contact(contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contact created successfully.")
        |> redirect(to: Routes.contact_path(conn, :show, contact))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, case_id: contact_params["case_id"])
    end
  end

  def show(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    render(conn, "show.html", contact: contact)
  end

  def edit(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    changeset = Contacts.change_contact(contact)
    render(conn, "edit.html", contact: contact, changeset: changeset)
  end

  def update(conn, %{"id" => id, "contact" => contact_params}) do
    contact = Contacts.get_contact!(id)

    case Contacts.update_contact(contact, contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contact updated successfully.")
        |> redirect(to: Routes.contact_path(conn, :show, contact))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", contact: contact, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    {:ok, _contact} = Contacts.delete_contact(contact)

    conn
    |> put_flash(:info, "Contact deleted successfully.")
    |> redirect(to: Routes.contact_path(conn, :index, case_id: contact.case_id))
  end
end
