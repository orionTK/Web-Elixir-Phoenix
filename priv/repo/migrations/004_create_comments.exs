defmodule BlogVttkieu.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string
      add :post_id, references(:posts, on_delete: :delete_all)  #khi mot post is removed -> all comment removed
     add :creator_id, references(:users, on_delete: :nothing)
      add :modifier_id, references(:users, on_delete: :nothing)

      timestamps()
    end
     create index(:comments, [:creator_id, :modifier_id])
    create index(:comments, [:post_id])
  end
end
