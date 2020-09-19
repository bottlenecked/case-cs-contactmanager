defmodule CaseCsContactManagerWeb.PageControllerTest do
  use CaseCsContactManagerWeb.ConnCase
  @moduletag authenticated_connection: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "List of cases with active contacts"
  end

  describe "unauthenticated access" do
    @describetag authenticated_connection: false

    def requires_login(conn) do
      quote do
        html_response(unquote(conn), 302) =~ "/login"
      end
    end

    test "GET /", %{conn: conn} do
      conn = get(conn, "/")
      assert requires_login(conn)
    end
  end
end
