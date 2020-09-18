defmodule CaseCsContactManager.Contacts.ContactChange do
  @type change_type() :: :read | :create | :update | :delete

  @type t() :: %__MODULE__{
          contact_id: non_neg_integer(),
          case_id: String.t(),
          fields: [atom()],
          type: change_type(),
          date: DateTime.t(),
          user_id: String.t()
        }

  defstruct [
    :contact_id,
    :case_id,
    :fields,
    :type,
    :date,
    :user_id
  ]
end
