defmodule CaseCsContactManager.AccountsTest do
  use ExUnit.Case, async: true

  alias TestHelper.Jwt
  alias CaseCsContactManager.Accounts

  describe "user" do
    test "logging in with valid token suceeds" do
      result = Accounts.validate_token(%{"token" => Jwt.correct_token()})
      user_id = Jwt.loggedin_user_id()
      assert {:ok, ^user_id} = result
    end

    test "logging in with wrong token fails" do
      result = Accounts.validate_token(%{"token" => Jwt.wrong_token()})
      assert {:error, %{errors: [token: {"invalid_token", []}]}} = result
    end

    test "logging in with missing token fails" do
      result = Accounts.validate_token(%{})
      assert {:error, %{errors: [token: {"can't be blank", _}]}} = result
    end

    test "logging in with random data fails" do
      result = Accounts.validate_token(%{token: "random"})
      assert {:error, %{errors: [token: {"invalid token data", _}]}} = result
    end
  end
end
