# ApiAuthentication

Token authentication Plug for Phoenix.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `api_authentication` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:api_authentication, "~> 0.1.0"}
  ]
end
```

## Configuration

```elixir
config :api_authentication, ApiAuthentication,
      repo: MyApp.Repo,
      schema_name: "tokens", # default
      resource_fk: :user_id, # default
      expire: 3600, # default        
```

You will need to create a migration for the Tokens database table:

```elixir
defmodule TokenAuth.Repo.Migrations.CreateAuthenticationTokens do
  use Ecto.Migration
  def change do
    create table(:authentication_tokens) do
      add :secret_id, :string
      add :hashed_secret, :string
      add :expires, :integer
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end

    create index(:authentication_tokens, [:user_id])
    create unique_index(:authentication_tokens, [:secret_id])
  end
end
```

Use the plug in your application entrypoint

```elixir
defmodule MyApp do

  def controller do
    quote do
    ...
      import ApiAuthentication, only: [authenticate_request: 2] 
    ...
    end
  end

end
```

You can use the plug in your controller:

```elixir
defmodule MyApp.ProtectedController do
  plug :authenticate_request when action in [:index]
end
```

Add the plug to your controller:

```elixir
defmodule MyApp.Router do
  
  pipeline :api do
    plug ApiAuthentication, repo: MyApp.Repo
  end

end
```
