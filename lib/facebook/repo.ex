defmodule Facebook.Repo do
  use Ecto.Repo,
    otp_app: :facebook,
    adapter: Ecto.Adapters.Postgres
end
