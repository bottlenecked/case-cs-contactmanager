defmodule CaseCsContactManager.ContactsTest do
  use CaseCsContactManager.DataCase

  alias CaseCsContactManager.Contacts

  describe "contacts" do
    alias CaseCsContactManager.Contacts.Contact

    @valid_attrs %{
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
    @invalid_attrs %{case_id: nil}

    def contact_fixture(attrs \\ %{}) do
      {:ok, contact} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contacts.create_contact()

      contact
    end

    test "list_contacts/0 returns all contacts" do
      contact = contact_fixture()
      assert Contacts.list_contacts() == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert Contacts.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      assert {:ok, %Contact{} = contact} = Contacts.create_contact(@valid_attrs)
      assert contact.address == "some address"
      assert contact.case_id == "some case_id"
      assert contact.first_name == "some first_name"
      assert contact.last_name == "some last_name"
      assert contact.mobile_number == "some mobile_number"
      assert contact.title == "some title"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contacts.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{} = contact} = Contacts.update_contact(contact, @update_attrs)
      assert contact.address == "some updated address"
      assert contact.case_id == "some updated case_id"
      assert contact.first_name == "some updated first_name"
      assert contact.last_name == "some updated last_name"
      assert contact.mobile_number == "some updated mobile_number"
      assert contact.title == "some updated title"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      assert {:error, %Ecto.Changeset{}} = Contacts.update_contact(contact, @invalid_attrs)
      assert contact == Contacts.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Contacts.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Contacts.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Contacts.change_contact(contact)
    end

    test "unique by case_id" do
      ["case 1", "case 2", "case 1", "case 3"]
      |> Enum.map(fn case_id -> %{case_id: case_id} end)
      |> Enum.map(fn attrs -> contact_fixture(attrs) end)

      contacts = Contacts.unique_by_case()

      assert [
               %Contact{case_id: "case 1", first_name: nil},
               %Contact{case_id: "case 2"},
               %Contact{case_id: "case 3"}
             ] = contacts
    end

    test "list contacts by case" do
      ["case 1", "case 2", "case 1", "case 3"]
      |> Enum.map(fn case_id -> %{case_id: case_id} end)
      |> Enum.map(fn attrs -> contact_fixture(attrs) end)

      contacts = Contacts.list_contacts_by_case("case 0")
      assert contacts == []

      contacts = Contacts.list_contacts_by_case("case 1")
      assert length(contacts) == 2

      for c <- contacts do
        assert c.case_id == "case 1"
      end
    end
  end
end
