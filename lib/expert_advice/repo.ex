defmodule ExpertAdvice.Repo do
  use Ecto.Repo,
    otp_app: :expert_advice,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10
end
