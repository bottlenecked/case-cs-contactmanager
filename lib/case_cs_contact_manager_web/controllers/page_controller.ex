defmodule CaseCsContactManagerWeb.PageController do
  use CaseCsContactManagerWeb, :controller
  alias CaseCsContactManager.Contacts

  plug AuthPlug

  def index(conn, _params) do
    contacts = Contacts.unique_by_case()
    render(conn, "index.html", contacts: contacts)
  end
end
