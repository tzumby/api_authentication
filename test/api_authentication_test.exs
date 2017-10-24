defmodule ApiAuthenticationTest do
  use ApiAuthentication.TestCase

  alias ApiAuthentication.Token
  alias ApiAuthentication.Test.Repo
  alias ApiAuthentication.Test.User

  test "assigns secret_id, secret and repo to conn" do
    conn = ApiAuthentication.call(%Plug.Conn{req_headers: [{"secret", "1234"}, {"secret_id", "123"}]}, Repo)

    assert conn.assigns.secret_id == "123"
    assert conn.assigns.secret == "1234"
    assert conn.assigns.repo == Repo
  end

  test "assigns empty strings for secret_id, secret" do
    conn = ApiAuthentication.call(%Plug.Conn{}, Repo)

    assert conn.assigns.secret_id == ""
    assert conn.assigns.secret == ""
    assert conn.assigns.repo == Repo
  end

  test "no repo is provided" do
    conn = ApiAuthentication.call(%Plug.Conn{}, %{})

    assert conn.assigns.secret_id == ""
    assert conn.assigns.secret == ""
    assert conn.assigns.repo == %{}
  end

  test "login_by_email_and_password returns a secret and secret_id" do
    email     = "john.doe@example.com"
    pass      = "q1w2e3r4t5"
    pass_hash = Comeonin.Bcrypt.hashpwsalt(pass)
    options   = [{:repo, Repo}, {:resource, User}]

    user_changeset  = User.changeset(%User{}, %{email: email, password_hash: pass_hash})
    {:ok, user}     = Repo.insert(user_changeset)

    {:ok, _, %{secret: secret, secret_id: secret_id }} = ApiAuthentication.login_by_email_and_password(%Plug.Conn{}, email, pass, options)

    assert secret != nil
    assert secret_id != nil
  end

  test "authenticate_request return conn if successful" do
    email     = "john.doe@example.com"
    pass      = "q1w2e3r4t5"
    pass_hash = Comeonin.Bcrypt.hashpwsalt(pass)

    user_changeset  = User.changeset(%User{}, %{email: email, password_hash: pass_hash})
    {:ok, user}     = Repo.insert(user_changeset)

    secret_id     = SecureRandom.hex 8
    secret        = SecureRandom.urlsafe_base64 32
    hashed_secret = Comeonin.Bcrypt.hashpwsalt(secret)
    expires       = System.system_time(:seconds) + 3600

    changeset     = Token.changeset(%Token{}, %{secret_id: secret_id, hashed_secret: hashed_secret, expires: expires, user_id: user.id})
    Repo.insert(changeset)

    conn      = %Plug.Conn{assigns: %{repo: Repo, secret_id: secret_id, secret: secret}}
    response  = ApiAuthentication.authenticate_request(conn, [])

    assert response.status == 200
  end
end
