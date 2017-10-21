defmodule ApiAuthentication.Token do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias ApiAuthentication.Token

  config = Application.get_env(:api_authentication, ApiAuthentication, [])
  
	@schema_name Keyword.get(config, :schema_name, "tokens")
  @expiration_time Keyword.get(config, :expiration_time, 3600)
	@resource_fk Keyword.get(config, :resource_name, :user_id)

  schema @schema_name do
    field :hashed_secret, :string
    field :secret_id, :string
    field :expires, :integer
    field @resource_fk, :id

    timestamps()
  end

  def changeset(%Token{} = token, attrs) do
    token
    |> cast(attrs, [:secret_id, :hashed_secret, :expires])
    |> validate_required([:secret_id, :hashed_secret, :expires])
  end
end
