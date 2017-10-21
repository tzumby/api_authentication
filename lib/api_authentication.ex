defmodule ApiAuthentication do
  @moduledoc """
  Documentation for ApiAuthentication.
  """

  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0, hashpwsalt: 1]

  alias ApiAuthentication.Token

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    secret = get_secret_header(conn)
    secret_id = get_secret_id_header(conn)
    auth_token =
      case secret_id do
        "" -> nil
        _ -> repo.get_by(Token, secret_id: secret_id)
      end
    cond do
      auth_token && auth_token.expires > timestamp && checkpw(secret, auth_token.hashed_secret) ->
        conn
        |> assign(:authenticated, true)
      auth_token ->
        conn
        |> assign(:authenticated, false)
      true ->
        dummy_checkpw()
        conn
        |> assign(:authenticated, false)
    end
  end

  def generate_token(conn, user, opts) do
    repo = Keyword.fetch!(opts, :repo)
    secret_id = SecureRandom.hex 8
    secret = SecureRandom.urlsafe_base64 32
    hashed_secret = hashpwsalt(secret)
    token_params = %{secret_id: secret_id, hashed_secret: hashed_secret, expires: timestamp + 3600}
    changeset = Token.changeset(%Token{}, token_params)
    token = repo.insert(changeset)
    cond do
      token ->
        {:ok, conn, %{secret: secret, secret_id: secret_id }}
      true ->
        {:error, :not_found, conn}
    end
  end

	def login_by_email_and_password(conn, email, password, opts) do
		repo = Keyword.fetch!(opts, :repo)
		resource = Keyword.fetch!(opts, :resource)

		user = repo.get_by(resource, email: email)
		cond do
			user && checkpw(password, user.password_hash) ->
				generate_token(conn, user, opts)
			user ->
				{:error, :unauthorized, conn }
			true
				dummy_checkpw()
				{:error, :not_found, conn}
		end
	end


	def authenticate_request(conn, _opts) do
		if conn.assigns.authenticated do
			conn
		else
			conn
			|> send_resp(401, "Unauthenticated")
			|> halt()
		end
	end

  defp timestamp do
    System.system_time(:seconds)
  end

  defp get_secret_id_header(conn) do
    conn
    |> get_req_header("secret_id")
    |> List.to_string
  end

  defp get_secret_header(conn) do
    conn
    |> get_req_header("secret")
    |> List.to_string
  end
end
