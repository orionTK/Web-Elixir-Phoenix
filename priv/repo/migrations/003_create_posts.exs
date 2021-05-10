defmodule BlogVttkieu.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :text
      add :creator_id, references(:users, on_delete: :nothing)
      add :modifier_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:posts, [:creator_id, :modifier_id])
  end
end
