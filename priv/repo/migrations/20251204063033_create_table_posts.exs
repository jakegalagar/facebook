defmodule Facebook.Repo.Migrations.CreateTablePosts do
  use Ecto.Migration

  def change do
    create table("posts") do
      add :body, :string

      timestamps(type: :utc_datetime_usec)
    end
  end
end
