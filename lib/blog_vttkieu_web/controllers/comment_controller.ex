defmodule BlogVttkieuWeb.CommentController do
  use BlogVttkieuWeb, :controller

  alias BlogVttkieu.Blog
  # plug :authenticate when action in [:index, :new, :create, :update, :delete]
  def create(conn, %{"post_id" => post_id, "comment" => comment_params}) do
    post = Blog.get_post!(post_id)
    user = BlogVttkieu.Account.current_user(conn)
    # comment_params = Map.put(comment_params, "time_update", DateTime.utc_now)

    case Blog.create_comment(post, user, comment_params) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Issue creating comment.")
        |> redirect(to: Routes.post_path(conn, :show, post))
    end
  end

  # def delete(conn, %{"id" => id}) do
  #   cmt = Blog.get_comment!(id)
  #   {:ok, _post} = Blog.delete_comment(cmt)

  #   conn
  #   |> put_flash(:info, "Comment deleted successfully.")
  #   |> redirect(to: Routes.post_path(conn, :show))
  # end

end
