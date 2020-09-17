defmodule CaseCsContactManagerWeb.PageControllerTest do
  use CaseCsContactManagerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "List of cases with active contacts"
  end
end
