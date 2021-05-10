defmodule BlogVttkieu.Blog.User do
    use Ecto.Schema
    import Ecto.Changeset
    import Ecto.Query
    alias Comeonin.Bcrypt

    schema "users" do #ten duoi database
        field :username, :string
        field :fullname, :string
        field :password, :string
        field :password_confirmation, :string, virtual: true

        # has_many :posts, BlogVttkieu.Blog.Post
        has_many :modifier_posts, BlogVttkieu.Blog.Post, foreign_key: :modifier_id, on_delete: :nothing
        has_many :creator_posts, BlogVttkieu.Blog.Post, foreign_key: :creator_id, on_delete: :nothing

        has_many :creator_comments, BlogVttkieu.Blog.Comment, foreign_key: :creator_id, on_delete: :nothing
        has_many :modifier_comments, BlogVttkieu.Blog.Comment, foreign_key: :modifier_id, on_delete: :nothing

        has_many :creator_users, BlogVttkieu.Blog.User, foreign_key: :creator_id, on_delete: :nothing
        has_many :modifier_users, BlogVttkieu.Blog.User, foreign_key: :modifier_id, on_delete: :nothing

        belongs_to :creator_user, BlogVttkieu.Blog.User, foreign_key: :creator_id
        belongs_to :modifier_user, BlogVttkieu.Blog.User, foreign_key: :modifier_id
        timestamps()
    end

    @doc false
  def changeset(user, attrs) do #loc, kiem tra, giu rang buoc thay doi ( xu ly du lieu dau vao)
    user
    |> cast(attrs, [:username, :fullname, :password]) #truyen du lieu
    |> validate_required([:username, :fullname, :password]) #check du lieu
    |> unique_constraint(:username)
    # |> required pattern=/^[a-zA-Z0-9.!$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$/
    # |> put_password_hash
    |> validate_length(:password, min: 6, max: 128)
    # |> encrypt_password()
    end

    # def put_password_hash(changeset) do
    #   case changeset do
    #     %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
    #       put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
    #     _ ->
    #       changeset
    #   end
    # end

  def count_posts(query) do
    from p in query,
      group_by: p.id,
      left_join: c in assoc(p, :creator_posts),
      select: {p, count(c.id)}
  end
end
