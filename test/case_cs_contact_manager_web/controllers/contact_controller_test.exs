defmodule CaseCsContactManagerWeb.ContactControllerTest do
  use CaseCsContactManagerWeb.ConnCase

  @moduletag authenticated_connection: true

  alias CaseCsContactManager.Contacts

  @create_attrs %{
    address: "some address",
    case_id: "some case_id",
    first_name: "some first_name",
    last_name: "some last_name",
    mobile_number: "some mobile_number",
    title: "some title"
  }
  @update_attrs %{
    address: "some updated address",
    case_id: "some updated case_id",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    mobile_number: "some updated mobile_number",
    title: "some updated title"
  }
  @invalid_attrs %{
    address: nil,
    case_id: nil,
    first_name: nil,
    last_name: nil,
    mobile_number: nil,
    title: nil
  }

  def fixture(:contact) do
    {:ok, contact} = Contacts.create_contact(@create_attrs)
    contact
  end

  describe "index" do
    test "lists all contacts", %{conn: conn} do
      conn = get(conn, Routes.contact_path(conn, :index, case_id: "some case_id"))
      assert html_response(conn, 200) =~ "Listing Contacts"
    end
  end

  describe "new contact" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.contact_path(conn, :new))
      assert html_response(conn, 200) =~ "New Contact"
    end
  end

  describe "create contact" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.contact_path(conn, :create), contact: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.contact_path(conn, :show, id)

      conn = get(conn, Routes.contact_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Contact"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.contact_path(conn, :create), contact: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Contact"
    end
  end

  describe "edit contact" do
    setup [:create_contact]

    test "renders form for editing chosen contact", %{conn: conn, contact: contact} do
      conn = get(conn, Routes.contact_path(conn, :edit, contact))
      assert html_response(conn, 200) =~ "Edit Contact"
    end
  end

  describe "update contact" do
    setup [:create_contact]

    test "redirects when data is valid", %{conn: conn, contact: contact} do
      conn = put(conn, Routes.contact_path(conn, :update, contact), contact: @update_attrs)
      assert redirected_to(conn) == Routes.contact_path(conn, :show, contact)

      conn = get(conn, Routes.contact_path(conn, :show, contact))
      assert html_response(conn, 200) =~ "some updated address"
    end

    test "renders errors when data is invalid", %{conn: conn, contact: contact} do
      conn = put(conn, Routes.contact_path(conn, :update, contact), contact: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Contact"
    end
  end

  describe "delete contact" do
    setup [:create_contact]

    test "deletes chosen contact", %{conn: conn, contact: contact} do
      conn = delete(conn, Routes.contact_path(conn, :delete, contact))
      assert redirected_to(conn) == Routes.contact_path(conn, :index, case_id: contact.case_id)

      assert_error_sent 404, fn ->
        get(conn, Routes.contact_path(conn, :show, contact))
      end
    end
  end

  describe "change events" do
    alias CaseCsContactManager.Contacts.ContactChange

    setup do
      CaseCsContactManager.PubSub.subscribe_on_contact_changed()
    end

    test "read", %{conn: conn} do
      %{id: id} = contact = fixture(:contact)
      get(conn, Routes.contact_path(conn, :show, contact))
      assert_received {:contact_changed, %ContactChange{contact_id: ^id, type: :read}}
    end

    test "create", %{conn: conn} do
      conn = post(conn, Routes.contact_path(conn, :create), contact: @create_attrs)
      %{id: id} = redirected_params(conn)
      id = String.to_integer(id)
      assert_received {:contact_changed, %ContactChange{contact_id: ^id, type: :create}}
    end

    test "update", %{conn: conn} do
      %{id: id} = contact = fixture(:contact)
      put(conn, Routes.contact_path(conn, :update, contact), contact: @update_attrs)
      assert_received {:contact_changed, %ContactChange{contact_id: ^id, type: :update}}
    end

    test "delete", %{conn: conn} do
      %{id: id} = contact = fixture(:contact)
      delete(conn, Routes.contact_path(conn, :delete, contact))
      assert_received {:contact_changed, %ContactChange{contact_id: ^id, type: :delete}}
    end
  end

  describe "unauthenticated access" do
    @describetag authenticated_connection: false

    def requires_login(conn) do
      quote do
        html_response(unquote(conn), 302) =~ "/login"
      end
    end

    test "index", %{conn: conn} do
      conn = get(conn, Routes.contact_path(conn, :index, case_id: "some case_id"))
      assert requires_login(conn)
    end

    test "new", %{conn: conn} do
      conn = get(conn, Routes.contact_path(conn, :new))
      assert requires_login(conn)
    end

    test "create", %{conn: conn} do
      conn = post(conn, Routes.contact_path(conn, :create), contact: @create_attrs)
      assert requires_login(conn)
    end

    test "edit", %{conn: conn} do
      contact = fixture(:contact)
      conn = get(conn, Routes.contact_path(conn, :edit, contact))
      assert requires_login(conn)
    end

    test "update", %{conn: conn} do
      contact = fixture(:contact)
      conn = put(conn, Routes.contact_path(conn, :update, contact), contact: @update_attrs)
      assert requires_login(conn)
    end

    test "delete", %{conn: conn} do
      contact = fixture(:contact)
      conn = delete(conn, Routes.contact_path(conn, :delete, contact))
      assert requires_login(conn)
    end
  end

  defp create_contact(_) do
    contact = fixture(:contact)
    %{contact: contact}
  end
end
