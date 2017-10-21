defmodule ApiAuthenticationTest.Token do
  use ApiAuthentication.TestCase
  
  alias ApiAuthentication.Token
  alias ApiAuthentication.Test.Repo

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0, hashpwsalt: 1]

  test "create a token given secret_id, hashed_secret and expires" do
    secret_id = SecureRandom.hex 8
    secret = SecureRandom.urlsafe_base64 32
    hashed_secret = hashpwsalt(secret)
    expires = System.system_time(:seconds) + 3600

    changeset = Token.changeset(%Token{}, %{secret_id: secret_id, hashed_secret: hashed_secret, expires: expires, user_id: 1})
    Repo.insert(changeset)

    token = Repo.get_by!(Token, secret_id: secret_id)

    assert token.hashed_secret == hashed_secret
  end  
end
