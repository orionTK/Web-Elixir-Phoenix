defmodule BlogVttkieu.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias BlogVttkieu.Paginator
  schema "posts" do
    field :body, :string
    field :title, :string
    # field :time_update, :utc_datetime
    has_many :comments, BlogVttkieu.Blog.Comment, on_delete: :delete_all  #quan he mot nhieu, delete_all dung cho xoa mqh

    belongs_to :creator_post, BlogVttkieu.Blog.User, foreign_key: :creator_id
    belongs_to :modifier_post, BlogVttkieu.Blog.User, foreign_key: :modifier_id


    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end

  def count_comments(query) do
    from p in query,
      group_by: p.id,
      left_join: c in assoc(p, :comments),
      select: {p, count(c.id)}
  end

  def count_posts(query) do
    from p in query,
      group_by: p.id,
      select: {p, count(p.id)}
  end


  def search(query, search_term) do
    wildcard_search = "%#{search_term}%"

    from post in query,
    where: like(post.title, ^wildcard_search),
    order_by: [asc: post.title]
  end



  def list_paged_posts(params) do
    Paginator.paginate(Post, params["page"])
  end
end
