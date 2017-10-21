defmodule ApiAuthentication.Test.Repo.Migrations.CreateAuthenticationTokens do
  use Ecto.Migration

  def change do
    create table(:authentication_tokens) do
      add :secret_id, :string
      add :hashed_secret, :string
      add :expires, :integer

      timestamps
    end

    create unique_index(:authentication_tokens, [:secret_id])
  end
end
