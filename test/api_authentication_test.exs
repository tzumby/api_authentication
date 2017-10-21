defmodule ApiAuthenticationTest do
  use ApiAuthentication.TestCase
  doctest ApiAuthentication

  test "greets the world" do
    assert ApiAuthentication.hello() == :world
  end
end
