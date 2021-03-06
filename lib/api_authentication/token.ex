defmodule ApiAuthentication.Token do
  @moduledoc """
  Ecto model for the database stored tokens. 
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias ApiAuthentication.Token

  config = Application.get_env(:api_authentication, ApiAuthentication, [])
  
  @schema_name Keyword.get(config, :schema_name, "tokens")
  @resource_fk Keyword.get(config, :resource_fk, :user_id)

  schema @schema_name do
    field :hashed_secret, :string
    field :secret_id, :string
    field :expires, :integer

    field @resource_fk, :id

    timestamps()
  end

  def changeset(%Token{} = token, attrs) do
    token
    |> cast(attrs, [:secret_id, :hashed_secret, :expires, @resource_fk])
    |> validate_required([:secret_id, :hashed_secret, :expires, @resource_fk])
  end
end
