defmodule BlogVttkieu.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias BlogVttkieu.Repo
  alias BlogVttkieu.Blog.User
  # alias Comeonin.Bcrypt



  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: Repo.get(User, user_id)
  end

  def user_signed_in?(conn) do
    !!current_user(conn)
  end

  def sign_out(conn) do
    Plug.Conn.configure_session(conn, drop: true)
  end

end
