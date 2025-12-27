defmodule Facebook.Posts do
  alias Facebook.Repo
  alias Facebook.Posts.Post

  def list_posts() do
    Repo.all(Post)
  end

  def get_post!(id) do
    Repo.get!(Post, id)
  end

  def update_post(posts, params) do
    posts
    |> Ecto.Changeset.cast(params, [:body])
    |> Repo.update()
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
end
