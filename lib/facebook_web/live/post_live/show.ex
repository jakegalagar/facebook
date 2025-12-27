defmodule FacebookWeb.PostLive.Show do
  use FacebookWeb, :live_view

  alias Facebook.Posts

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    post = Posts.get_post!(id)

    patch = ~p"/posts/#{id}"

    socket =
      socket
      |> assign(:post, post)
      |> assign(:patch, patch)
      |> assign(:query, "")

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> apply_action(socket.assigns.live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :show, _params) do
    socket
  end

  defp apply_action(socket, :edit, _params) do
    socket
    |> assign(:page_title, "Edit Post")
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto mt-8 p-6 bg-white shadow-md rounded-lg">
      <div class="flex justify-end mb-4">
        <.link patch={~p"/posts/#{@post}/show/edit"}>
          <.button>
            Edit
          </.button>
        </.link>
      </div>

      <h1 class="text-2xl font-bold text-gray-800 mb-4">Post Details</h1>

      <div class="grid grid-cols-1 gap-4">
        <div class="flex">
          <div class="w-32 font-semibold text-gray-700">ID:</div>
          <div class="text-gray-900">{@post.id}</div>
        </div>

        <div class="flex">
          <div class="w-32 font-semibold text-gray-700">Body:</div>
          <div class="text-gray-900">{@post.body}</div>
        </div>
      </div>

      <div class="mt-6">
        <.button
          phx-click={JS.navigate(~p"/posts")}
          class="inline-block bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
        >
          Back
        </.button>
      </div>
    </div>

    <%= if @live_action == :edit do %>
      <.modal id="edit-post-modal" show on_cancel={JS.patch(@patch)}>
        <.live_component
          id={@post.id}
          module={FacebookWeb.PostLive.FormComponent}
          post={@post}
          patch={@patch}
          page_title={@page_title}
          live_action={@live_action}
        />
      </.modal>
    <% end %>
    """
  end
end
