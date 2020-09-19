defmodule CaseCsContactManager.JwtAuthTest do
  use ExUnit.Case, async: true

  alias CaseCsContactManager.JwtAuth

  # these are sample values generated on jwt.io, not actual tokens/keys
  @key """
  -----BEGIN PUBLIC KEY-----
  MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnzyis1ZjfNB0bBgKFMSv
  vkTtwlvBsaJq7S5wA+kzeVOVpVWwkWdVha4s38XM/pa/yr47av7+z3VTmvDRyAHc
  aT92whREFpLv9cj5lTeJSibyr/Mrm/YtjCZVWgaOYIhwrXwKLqPr/11inWsAkfIy
  tvHWTxZYEcXLgAXFuUuaS3uF9gEiNQwzGTU1v0FqkqTBr4B8nW3HCN47XUu0t8Y0
  e+lf4s4OxQawWD79J9/5d3Ry0vbV3Am1FtGJiJvOwRsIfVChDpYStTcHTCMqtvWb
  V6L11BWkpzGXSW4Hv43qa+GSYOD2QU68Mb59oSk2OB+BtOLpJofmbGEGgvmwyCI9
  MwIDAQAB
  -----END PUBLIC KEY-----
  """

  @correct_token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.POstGetfAytaZS82wHcjoTyoqhMyxXiWdR7Nn7A29DNSl0EiXLdwJ6xC6AfgZWF1bOsS_TuYI3OG85AmiExREkrS6tDfTQ2B3WXlrr-wp5AokiRbz3_oB4OxG-W9KcEEbDRcZc0nH3L7LzYptiy1PtAylQGxHTWZXtGz4ht0bAecBgmpdgXMguEIcoqPJ1n3pIWk_dUZegpqx0Lka21H6XxUTxiy8OcaarA8zdnPUnV6AmNP3ecFawIFYdvJB_cm-GvpCSbr8G8y_Mllj8f4x9nBH8pQux89_6gUY618iYv7tuPWBFfEbLxtF2pZS6YC1aSfLQxeNe8djT9YjpvRZA"
  @wrong_token "eyJhbGciOiJSUzM4NCIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.D4kXa3UspFjRA9ys5tsD4YDyxxam3l_XnOb3hMEdPDTfSLRHPv4HPwxvin-pIkEmfJshXPSK7O4zqSXWAXFO52X-upJjFc_gpGDswctNWpOJeXe1xBgJ--VuGDzUQCqkr9UBpN-Q7TE5u9cgIVisekSFSH5Ax6aXQC9vCO5LooNFx_WnbTLNZz7FUia9vyJ544kLB7UcacL-_idgRNIWPdd_d1vvnNGkknIMarRjCsjAEf6p5JGhYZ8_C18g-9DsfokfUfSpKgBR23R8v8ZAAmPPPiJ6MZXkefqE7p3jRbA--58z5TlHmH9nTB1DYE2872RYvyzG3LoQ-2s93VaVuw"
  setup_all do
    key_name = "JWT_PUBLIC_KEY"

    System.put_env(key_name, @key)

    on_exit(fn ->
      System.delete_env(key_name)
    end)
  end

  test "can decode correct token" do
    result = JwtAuth.decode_and_verify(@correct_token)
    assert {:ok, %{"iat" => 1_516_239_022, "name" => "John Doe", "sub" => "1234567890"}} = result
  end

  test "wrong token cannot be validated" do
    result = JwtAuth.decode_and_verify(@wrong_token)
    assert {:error, :invalid_token} = result
  end
end
