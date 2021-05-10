defmodule BlogVttkieu.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :creator_id, references(:users, on_delete: :nothing)
      add :modifier_id, references(:users, on_delete: :nothing)
      add :fullname, :string
      timestamps()
      end
     create index(:users, [:creator_id, :modifier_id])

      create unique_index(:users, [:username])
  end
end
