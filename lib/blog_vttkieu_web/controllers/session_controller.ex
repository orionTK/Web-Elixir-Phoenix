defmodule BlogVttkieuWeb.SessionController do
  use BlogVttkieuWeb, :controller
  alias BlogVttkieu.Account
  alias BlogVttkieu.Blog.User
  alias BlogVttkieu.Repo
  alias BlogVttkieu.Blog
  alias BlogVttkieu.Blog.Post
  alias BlogVttkieu.Blog.Comment
  alias Comeonin.Bcrypt
    alias BlogVttkieu.Repo
  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do

    # case Comeonin.Bcrypt.check_pass(user, session_params["password"]) do
    case sign_in(session_params["username"], session_params["password"]) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "There was a problem with your username/password")
        |> render("new.html")
      end

  end

  def newsignup(conn, _params) do
    changeset = Blog.change_user(%User{})
    render(conn, "register.html", changeset: changeset)
  end

  def register(conn, %{"user" => user_params}) do

    case Blog.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    conn
    |>Account.sign_out()
    |> put_flash(:info, "Signed out successfully")
    |> redirect(to: Routes.page_path(conn, :index))
  end


  def sign_in(username, password) do
    # user = Account.get_by_username(session_params["username"])
    user = Repo.get_by(User, username: username)
    cond do
      user && user.password == password ->
        {:ok, user}
      true ->
        {:error, :unauthorized}
    end
  end
  end
