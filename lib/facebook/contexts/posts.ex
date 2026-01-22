defmodule Facebook.Posts do
  alias Ecto.Multi
  alias Facebook.Repo
  alias Facebook.Posts.Post

  def list_posts() do
    Repo.all(Post)
  end

  def get_post!(id) do
    Repo.get!(Post, id)
  end

  def create_post(params) do
    %Post{}
    |> Ecto.Changeset.cast(params, [:body])
    |> Repo.insert()
  end

  def delete_post(id) do
    post = get_post!(id)

    Repo.delete(post)
  end

  def update_post(%Post{} = post, params) do
    # posts
    # |> Ecto.Changeset.cast(params, [:body])
    # |> Repo.update()

    meta =
      %{
        type: "post update",
        actor: "Jake Galagar"
      }

    Multi.new()
    |> Carbonite.Multi.insert_transaction(%{meta: meta})
    |> Multi.update(:post, fn _changes ->
      post
      |> Ecto.Changeset.cast(params, [:body])
      |> Ecto.Changeset.validate_required([:body])
    end)
    |> Repo.transact()
  end
end
