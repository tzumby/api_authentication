defmodule ApiAuthentication.Test.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :secret_id, :string
      add :hashed_secret, :string
      add :expires, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end

    create unique_index(:tokens, [:secret_id])
    create unique_index(:tokens, [:user_id])
  end
end
