defmodule ApiAuthenticationTest do
  use ApiAuthentication.TestCase

  alias ApiAuthentication.Test.Repo

  test "assigns secret_id, secret and repo to conn" do
    conn = ApiAuthentication.call(%Plug.Conn{req_headers: [{"secret", "1234"}, {"secret_id", "123"}]}, Repo)

    assert conn.assigns.secret_id == "123"
    assert conn.assigns.secret == "1234"
    assert conn.assigns.repo == Repo
  end
end
