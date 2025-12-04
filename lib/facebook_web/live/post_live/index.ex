defmodule FacebookWeb.PostLive.Index do
  use FacebookWeb, :live_view

  def mount(_params, _session, socket) do
    posts = [%{id: 1, body: "Jake"}, %{id: 2, body: "Helloo"}]

    socket =
      socket
      |> assign(:posts, posts)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Listing Posts</h1>

    <.table id="post" rows={@posts}>
      <:col :let={post} label="ID">{post.id}</:col>
      <:col :let={post} label="Body">{post.body}</:col>
    </.table>
    """
  end
end
