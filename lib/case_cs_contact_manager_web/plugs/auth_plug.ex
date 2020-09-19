defmodule CaseCsContactManagerWeb.Plugs.AuthPlug do
  @moduledoc """
  Ensures that requests reaching this controller are authenticated
  """
  alias Phoenix.Controller
  alias Plug.Conn
  alias CaseCsContactManagerWeb.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _opts) do
    case Conn.get_session(conn, :current_user_id) do
      nil ->
        conn
        |> Controller.put_flash(:error, "You need to be signed in to access that page.")
        |> Controller.redirect(to: Routes.user_path(conn, :new))
        |> Conn.halt()

      _ ->
        conn
    end
  end
end
