defmodule CaseCsContactManager.JwtAuth do
  @moduledoc """
  Jwt validation callbacks module used by the Guardian lib
  """
  use Guardian, otp_app: :case_cs_contact_manager
  use Guardian.Token.Jwt.SecretFetcher

  @impl Guardian
  def subject_for_token(_resource, _claims) do
    {:error, "Issueing new JWT tokens is not supported"}
  end

  @impl Guardian
  def resource_from_claims(claims) do
    id = claims["sub"]
    {:ok, id}
  end

  def fetch_verifying_secret(_module, _headers, _opts) do
    secret = fetch("JWT_PUBLIC_KEY")
    {:ok, secret}
  end

  defp fetch(env_var) do
    env_var
    |> System.fetch_env!()
    |> JOSE.JWK.from_pem()
  end
end
