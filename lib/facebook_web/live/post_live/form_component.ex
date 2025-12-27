defmodule FacebookWeb.PostLive.FormComponent do
  use FacebookWeb, :live_component

  alias Facebook.Posts

  @impl true
  def update(assigns, socket) do
    changeset = Ecto.Changeset.change(assigns.post)

    form = to_form(changeset)

    socket =
      socket
      |> assign(assigns)
      |> assign(:form, form)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>{@page_title}</.header>

      <.simple_form for={@form} phx-target={@myself} phx-submit="save-post">
        <.input type="text" field={@form[:body]} label="Body" />
        <.button>Save Edit</.button>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("save-post", %{"post" => post_params}, socket) do
    IO.inspect(post_params)

    if socket.assigns.live_action == :new do
      Posts.create_post(post_params)
    else
      post = socket.assigns.post
      Posts.update_post(post, post_params)
    end

    message =
      if socket.assigns.live_action == :new do
        "Post was Created successfully."
      else
        "Post was Update successfully."
      end

    socket =
      socket
      |> put_flash(:info, message)
      |> push_navigate(to: ~p"/posts")

    {:noreply, socket}
  end
end
