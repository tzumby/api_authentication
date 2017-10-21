ExUnit.start()

defmodule ApiAuthentication.TestCase do
  use ExUnit.CaseTemplate

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ApiAuthentication.Test.Repo)

    Ecto.Adapters.SQL.Sandbox.mode(ApiAuthentication.Test.Repo, { :shared, self() })
    :ok
  end
end


{:ok, _pid} = ApiAuthentication.Test.Repo.start_link
Ecto.Adapters.SQL.Sandbox.mode(ApiAuthentication.Test.Repo, { :shared, self() })
