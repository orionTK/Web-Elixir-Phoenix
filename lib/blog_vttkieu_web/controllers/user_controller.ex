defmodule BlogVttkieuWeb.UserController do
    use BlogVttkieuWeb, :controller
    import Ecto.Query

    alias BlogVttkieu.Blog
    alias BlogVttkieu.Blog.Post
    alias BlogVttkieu.Blog.Comment
    alias BlogVttkieu.Blog.User
    plug :authenticate when action in [:index, :new, :create, :update, :delete]
    alias BlogVttkieu.Repo



    def index(conn, _params) do
      page = Blog.list_users(_params) |> Repo.paginate(_params)
      render(conn, "index.html", user: page.entries, page: page)
    end

    def new(conn, _params) do

      changeset = Blog.change_user(%User{})
      render(conn, "new.html", changeset: changeset)
    end

    def create(conn, %{"user" => user_params}) do
      user_current = BlogVttkieu.Account.current_user(conn)

      case Blog.create_user_manager(user_current, user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: Routes.user_path(conn, :show, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end

    # def show(conn, %{"id" => id}) do
    #   post = Blog.get_post!(id)
    #   render(conn, "show.html", post: post)
    # end

    # def show(conn, %{"id" => id}) do
    #   post = Blog.get_post!(id)
    #   comment_changeset = Blog.change_comment(%Comment{})
    #   render(conn, "show.html", post: post, comment_changeset: comment_changeset)
    # end

    def show(conn, %{"id" => id}) do
      user = Blog.get_user!(id)
      comment_changeset = Blog.change_comment(%Comment{})
      post_changeset = Blog.change_post(%Post{})

      # IO.puts post.
      render(conn, "show.html", user: user, comment_changeset: comment_changeset, post_changeset: post_changeset)
    end

    def edit(conn, %{"id" => id}) do
      users = Blog.get_user!(id)
      changeset = Blog.change_user(users)
      render(conn, "edit.html", user: users, changeset: changeset)
    end

    def update(conn, %{"id" => id, "user" => user_params}) do
      user = Blog.get_user!(id)
      user_current = BlogVttkieu.Account.current_user(conn)
      query_modifi = from c in User, where: c.modifier_id > 0
      check_modifi = Repo.exists?(query_modifi)

      if check_modifi == true do
        put_flash(conn, :error, "User can only be edited once ")
        |> redirect(to: Routes.user_path(conn, :show, user))
      else
        case Blog.update_user(user_current,user, user_params) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "User updated successfully.")
            |> redirect(to: Routes.user_path(conn, :index))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", user: user, changeset: changeset)
        end
      end
    end

    def delete(conn, %{"id" => id}) do
      user = Blog.get_user!(id)
      user_current = BlogVttkieu.Account.current_user(conn)
      if user.id == user_current.id do
        put_flash(conn, :error, "You are not allowed to delete yourself!")
        |> redirect(to: Routes.user_path(conn, :index))

      else

        query_post = from p in Post, where: p.creator_id == type(^id, :integer) or p.modifier_id == type(^id, :integer)
        check_post = Repo.exists?(query_post)

        query_comment = from c in Comment, where: c.creator_id == type(^id, :integer) or c.modifier_id == type(^id, :integer)
        check_comment = Repo.exists?(query_comment)

        query_comment = from c in User, where: c.creator_id == type(^id, :integer) or c.modifier_id == type(^id, :integer)
        check_comment = Repo.exists?(query_comment)

        if (check_comment == true or check_post == true) do
            put_flash(conn, :error, "User is referencing another rows")
            |> redirect(to: Routes.user_path(conn, :index))
        else
          {:ok, _user} = Blog.delete_user(user)
          conn
          |> put_flash(:info, "User deleted successfully.")
          |> redirect(to: Routes.user_path(conn, :index))
        end
      end
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
