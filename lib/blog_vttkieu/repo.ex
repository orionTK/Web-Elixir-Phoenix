defmodule BlogVttkieu.Repo do
  use Ecto.Repo,
    otp_app: :blog_vttkieu,
    adapter: Ecto.Adapters.MyXQL
  use Scrivener, page_size: 5
end
