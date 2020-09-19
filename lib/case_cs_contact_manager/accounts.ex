defmodule CaseCsContactManager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias CaseCsContactManager.Accounts.User
  alias CaseCsContactManager.JwtAuth

  @spec validate_token(%{String.t() => term()}) ::
          {:ok, String.t()} | {:error, Ecto.Changeset.t()}
  def validate_token(params) do
    with {:valid?, %{valid?: true} = changeset} <- {:valid?, User.changeset(%User{}, params)},
         %{changes: %{token: token}} = changeset,
         {:auth, {:ok, %{"sub" => user_id}}} <- {:auth, JwtAuth.decode_and_verify(token)} do
      {:ok, user_id}
    else
      {:valid?, changeset} ->
        {:error, changeset}

      {:auth, {:error, reason}} ->
        changeset =
          %User{}
          |> User.changeset(%{})
          |> Map.put(:errors, token: {to_string(reason), []})

        {:error, changeset}
    end
  end

  @spec current_user_id(Plug.Conn.t()) :: String.t() | nil
  def current_user_id(conn) do
    Plug.Conn.get_session(conn, :current_user_id)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
