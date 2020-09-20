defmodule CaseCsContactManagerWeb.LayoutView do
  use CaseCsContactManagerWeb, :view
  alias CaseCsContactManager.Accounts

  def signed_in?(conn) do
    Accounts.current_user_id(conn) != nil
  end
end
