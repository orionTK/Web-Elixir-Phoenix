defmodule BlogVttkieuWeb.Helpers.Auth do

  alias BlogVttkieu.Repo
  alias BlogVttkieu.Blog.User
  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user)
    if user_id, do: !!Repo.get(User, user_id)
  end

  def current_user(conn) do
    !!signed_in?(conn)
  end
  def sign_out(conn) do
    Plug.Conn.configure_session(conn, drop: true)
  end

  
end
