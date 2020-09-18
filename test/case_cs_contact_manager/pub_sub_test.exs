defmodule CaseCsContactManager.PubSubTest do
  use ExUnit.Case

  alias CaseCsContactManager.PubSub
  alias CaseCsContactManager.Contacts.ContactChange

  test "published changes reach subscribers" do
    PubSub.subscribe_on_contact_changed()

    change = %ContactChange{
      case_id: "Case 1",
      user_id: "user1",
      contact_id: 1,
      fields: [:title, :address],
      type: :created,
      date: DateTime.utc_now()
    }

    PubSub.publish_contact_changed(change)

    assert_receive {:contact_changed, data}
    assert data == change
  end
end
