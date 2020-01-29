defmodule Deidentify.Repo do
  use Ecto.Repo,
    otp_app: :deidentify,
    adapter: Ecto.Adapters.Postgres
end
