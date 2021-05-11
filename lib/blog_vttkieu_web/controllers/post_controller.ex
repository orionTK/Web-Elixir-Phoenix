defmodule BlogVttkieuWeb.PostController do
  use BlogVttkieuWeb, :controller
  import Ecto.Query
  alias BlogVttkieu.Blog
  alias BlogVttkieu.Blog.Post
  alias BlogVttkieu.Blog.Comment
  alias BlogVttkieu.Repo

  plug :authenticate when action in [:index, :new, :create, :update, :delete]

  def index(conn, _params) do
     posts = Post
    |> Post.count_comments
    |> Repo.all #lay ra tat ca cac field of Post trong db
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Blog.change_post(%Post{})
    user = BlogVttkieu.Account.current_user(conn)
    render(conn, "new.html", changeset: changeset, user: user)
  end

  def create(conn, %{ "post" => post_params}) do
    user = BlogVttkieu.Account.current_user(conn)
      # post_params = Map.put(post_params, "creator_id", user.id)

    case Blog.create_post(user, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


  # def show(conn, %{"id" => id}) do
  #   post = Blog.get_post!(id)
  #   render(conn, "show.html", post: post)
  # end

  def show(conn, %{"id" => id}) do
    user = BlogVttkieu.Account.current_user(conn)
    post = Blog.get_post!(id)
    comment_changeset = Blog.change_comment(%Comment{})
    render(conn, "show.html", post: post, comment_changeset: comment_changeset, user: user)
  end

  def edit(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    changeset = Blog.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blog.get_post!(id)
    user = BlogVttkieu.Account.current_user(conn)
    query_modifi = from c in Post, where: c.modifier_id > 0
    check_modifi = Repo.exists?(query_modifi)
    if check_modifi == true do
      put_flash(conn, :error, "Post can only be edited once ")
      |> redirect(to: Routes.post_path(conn, :show, post))
    else
      case Blog.update_post(user,post, post_params) do
        {:ok, post} ->
          conn
          |> put_flash(:info, "Post updated successfully.")
          |> redirect(to: Routes.post_path(conn, :show, post))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", post: post, changeset: changeset)
      end
    end

  end

  def delete(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    {:ok, _post} = Blog.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  def authenticate(conn, _params) do
    if BlogVttkieu.Account.user_signed_in?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You must be sign in to do that.")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end

end
