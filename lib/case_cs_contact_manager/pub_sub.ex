defmodule CaseCsContactManager.PubSub do
  @moduledoc """
  Events publishing helper module
  """

  @registry_name :contacts_pub_sub
  @contact_change_event :contact_changed

  alias CaseCsContactManager.Contacts.ContactChange

  @spec subscribe_on_contact_changed() :: :ok
  def subscribe_on_contact_changed() do
    Registry.register(@registry_name, @contact_change_event, [])
    :ok
  end

  @spec unsubscribe_on_contact_changed() :: :ok
  def unsubscribe_on_contact_changed() do
    Registry.unregister(@registry_name, @contact_change_event)
  end

  @spec publish_contact_changed(ContactChange.t()) :: :ok
  def publish_contact_changed(%ContactChange{} = change) do
    Registry.dispatch(@registry_name, @contact_change_event, fn entries ->
      for {pid, _} <- entries, do: send(pid, {@contact_change_event, change})
    end)
  end
end
