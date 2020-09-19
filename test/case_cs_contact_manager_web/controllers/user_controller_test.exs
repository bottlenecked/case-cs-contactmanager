defmodule CaseCsContactManagerWeb.UserControllerTest do
  use CaseCsContactManagerWeb.ConnCase
  alias CaseCsContactManager.Accounts
  alias TestHelper.Jwt

  @create_attrs %{token: Jwt.correct_token()}
  @invalid_attrs %{token: Jwt.wrong_token()}
  @missing_attrs %{token: nil}

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "Sign in"
    end
  end

  describe "create user" do
    test "redirects to / when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert Accounts.current_user_id(conn) == Jwt.loggedin_user_id()
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Sign in"
    end

    test "renders errors when token missing", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @missing_attrs)
      assert html_response(conn, 200) =~ "Sign in"
    end
  end

  describe "delete user" do
    test "logs out user", %{conn: conn} do
      conn =
        conn
        |> post(Routes.user_path(conn, :create), user: @create_attrs)
        |> delete(Routes.user_path(conn, :delete))

      assert redirected_to(conn) == Routes.user_path(conn, :new)
      assert Accounts.current_user_id(conn) == nil
    end
  end
end
