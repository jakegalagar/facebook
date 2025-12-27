defmodule FacebookWeb.PostLive.Index do
  use FacebookWeb, :live_view

  alias Facebook.Repo
  alias Facebook.Posts
  alias Facebook.Posts.Post

  @impl true
  def mount(_params, _session, socket) do
    posts = Posts.list_posts()

    patch = ~p"/posts"

    socket =
      socket
      |> assign(:posts, posts)
      |> assign(:patch, patch)
      |> assign(:show_modal, false)
      |> assign(:form_data, %{body: ""})

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:post, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Listing Posts</h1>

    <div class="flex justify-end mb-4">
      <.link navigate={~p"/posts/new"}>
        <.button>New</.button>
      </.link>
    </div>

    <%= if @live_action == :new do %>
      <.modal id="new-post-modal" show on_cancel={JS.patch(@patch)}>
        <.live_component
          id={:new}
          module={FacebookWeb.PostLive.FormComponent}
          post={@post}
          patch={@patch}
          page_title={@page_title}
          live_action={@live_action}
        />
      </.modal>
    <% end %>

    <.table id="post" rows={@posts}>
      <:col :let={post} label="ID">{post.id}</:col>
      <:col :let={post} label="Body">{post.body}</:col>

      <:action :let={post}>
        <.link
          navigate={~p"/posts/#{post}"}
          class="rounded-lg bg-zinc-50 px-2 py-2 hover:bg-zinc-200/100 me-2"
        >
          show
        </.link>

        <.button
          class="hover:text-primary"
          phx-click="upcase"
          phx-value-id={post.id}
        >
          upcase
        </.button>

        <.button class="hover:text-primary">
          <.link
            phx-click="downcase"
            phx-value-id={post.id}
          >
            downcase
          </.link>
        </.button>

        <.button
          class="hover:text-primary"
          phx-click="delete-post"
          phx-value-id={post.id}
        >
          delete
        </.button>
      </:action>
    </.table>

    <%= if @show_modal do %>
      <.modal id="add_post_modal" show>
        <h2 class="text-xl font-bold">Add New Post</h2>
        <form phx-submit="save-new">
          <input
            type="text"
            name="Body"
            class="border p-2 w-full rounded"
            value={@form_data.body}
          />
        </form>
      </.modal>
    <% end %>
    """
  end

  @impl true
  def handle_event("delete-post", %{"id" => id}, socket) do
    Posts.delete_post(id)

    socket =
      socket
      |> put_flash(:info, "Post was deleted successfully.")
      |> push_navigate(to: ~p"/posts")

    {:noreply, socket}
  end

  def handle_event("upcase", %{"id" => id}, socket) do
    post = Repo.get(Post, id)

    modified_body = String.upcase(post.body)

    post
    |> Ecto.Changeset.change(%{body: modified_body})
    |> Repo.update()

    socket =
      socket
      |> put_flash(:info, "Post was Upcase successfully")
      |> push_navigate(to: ~p"/posts")

    {:noreply, socket}
  end

  def handle_event("downcase", %{"id" => id}, socket) do
    post = Repo.get(Post, id)

    modified_body = String.downcase(post.body)

    post
    |> Ecto.Changeset.change(%{body: modified_body})
    |> Repo.update()

    socket =
      socket
      |> put_flash(:info, "Post was downcase successfully")
      |> push_navigate(to: ~p"/posts")

    {:noreply, socket}
  end

  def handle_event("open-modal", _params, socket) do
    socket.assigns.posts

    socket =
      socket
      |> assign(:show_modal, true)
      |> assign(:form_data, %{body: ""})

    {:noreply, socket}
  end

  def handle_event("close-modal", _params, socket) do
    socket.assigns.posts

    socket =
      socket
      |> assign(:show_modal, false)

    {:noreply, socket}
  end

  def handle_event("save-new", params, socket) do
    posts = socket.assigns.posts

    new_id = Integer.to_string(length(posts) + 1)

    new_post = %Facebook.Posts.Post{
      id: new_id,
      body: params["body"]
    }

    update = posts ++ [new_post]

    socket =
      socket
      |> assign(:posts, update)
      |> assign(:show_modal, false)

    {:noreply, socket}
  end
end
