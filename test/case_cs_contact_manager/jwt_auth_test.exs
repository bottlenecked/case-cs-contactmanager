defmodule CaseCsContactManager.JwtAuthTest do
  use ExUnit.Case, async: true

  alias CaseCsContactManager.JwtAuth
  alias TestHelper.Jwt

  test "can decode correct token" do
    result = JwtAuth.decode_and_verify(Jwt.correct_token())
    assert {:ok, %{"iat" => 1_516_239_022, "name" => "John Doe", "sub" => "1234567890"}} = result
  end

  test "wrong token cannot be validated" do
    result = JwtAuth.decode_and_verify(Jwt.wrong_token())
    assert {:error, :invalid_token} = result
  end
end
