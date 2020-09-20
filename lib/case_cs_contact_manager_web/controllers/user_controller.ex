defmodule CaseCsContactManagerWeb.UserController do
  use CaseCsContactManagerWeb, :controller

  alias CaseCsContactManager.Accounts
  alias CaseCsContactManager.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.validate_token(user_params) do
      {:ok, user_id} ->
        conn
        |> put_session(:current_user_id, user_id)
        |> put_flash(:info, "Successfully signed in")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset} = Ecto.Changeset.apply_action(changeset, :insert)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.user_path(conn, :new))
  end
end
