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
    socket = save_post(socket, socket.assigns.live_action, post_params)

    {:noreply, socket}
  end

  defp save_post(socket, :new, post_params) do
    case Posts.create_post(post_params) do
      {:ok, _changes} ->
        socket
        |> put_flash(:info, "Post was created successfully.")
        |> push_navigate(to: socket.assigns.patch)

      {:error, _failed_op, changeset, _changes} ->
        form = to_form(changeset)

        socket
        |> assign(:form, form)
    end
  end

  defp save_post(socket, :edit, post_params) do
    post = socket.assigns.post

    case Posts.update_post(post, post_params) do
      {:ok, _changes} ->
        socket
        |> put_flash(:info, "Post was Update successfully.")
        |> push_navigate(to: socket.assigns.patch)

      {:error, _failed_op, changeset, _changes} ->
        form = to_form(changeset)

        socket
        |> assign(:form, form)
    end
  end
end
