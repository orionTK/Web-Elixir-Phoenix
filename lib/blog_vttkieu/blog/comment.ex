defmodule BlogVttkieu.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    # field :time_update, :utc_datetime
    belongs_to :post, BlogVttkieu.Blog.Post
    belongs_to :creator_comment, BlogVttkieu.Blog.User, foreign_key: :creator_id
    belongs_to :modifier_comment, BlogVttkieu.Blog.User, foreign_key: :modifier_id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([ :body])
  end
end
