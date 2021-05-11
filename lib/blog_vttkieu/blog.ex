defmodule BlogVttkieu.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias BlogVttkieu.Repo

  alias BlogVttkieu.Blog.Post
  alias BlogVttkieu.Blog.Comment
  alias BlogVttkieu.Blog.User
  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  # def get_post!(id), do: Repo.get!(Post, id)
  def get_post!(id) do
  Post
  |> Repo.get!(id)
  |> Repo.preload(:comments)

end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_post(attrs \\ %{}) do
  #   %Post{}
  #   |> Post.changeset(attrs)
  #   |> Repo.insert()
  # end

  def create_post(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:creator_posts)
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  # def create_comment(%Post{} = post, attrs \\ %{}) do
  #   post
  #   |> Ecto.build_assoc(:comments)
  #   |> Comment.changeset(attrs)
  #   |> Repo.insert()
  # end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%User{} = user, %Post{} = post, attrs) do
    post
    |> Repo.preload(:modifier_post)
    |> Post.changeset(attrs)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:modifier_post, user) #:))) lay bien tu belong_as
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)d
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end



  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # def create_comment(attrs \\ %{}) do
  #   %Comment{}
  #   |> Comment.changeset(attrs)
  #   |> Repo.insert()
  # end

  def create_comment(%Post{} = post, %User{} = user, attrs \\ %{}) do

    # %Comment{}
    #   |> Comment.changeset(attrs)
    #   |> Repo.insert()

    # %Comment{}
    # |> Repo.preload(:post)
    # |> Ecto.Changeset.change()
    # # |> Ecto.Changeset.put_assoc(:comments, post)
    # |> Ecto.Changeset.put_assoc(:post, post )
    # |> Repo.update()

    # %Comment{}
    # |> Ecto.Changeset.change()
    # |> Changeset.put_assoc(:comments, post)
    # |> Ecto.Changeset.put_assoc(:creator_comments, user)
    # |> Repo.update()


    post
    |> Ecto.build_assoc(:comments) #lay bien tu has_many
    |> Comment.changeset(attrs)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:creator_comment, user) #:))) lay bien tu belong_as
    |> Repo.insert()

  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()



  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end





  def list_users do
    Repo.all(User)
  end

  def get_user!(id) do
    User
     |>Repo.get!(id)
     |> Repo.preload(:creator_comments)
     |> Repo.preload(:creator_posts)

  end


  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_manager(%User{} = user, attrs \\ %{}) do

    user
    |> Ecto.build_assoc(:creator_users) #lay bien tu has_many
    |> User.changeset(attrs)
    |> Repo.insert()

  end

  def update_user(%User{} = user_current, %User{} = user, attrs) do
    # user
    # |> User.changeset(attrs)
    # |> Repo.update()

    user
    |> Repo.preload(:modifier_user)
    |> User.changeset(attrs)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:modifier_user, user_current) #:))) lay bien tu belong_as
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

end
