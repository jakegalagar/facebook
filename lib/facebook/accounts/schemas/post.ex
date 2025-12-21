defmodule Facebook.Posts.Post do
  use Ecto.Schema
  # defstruct [:id, :body]\\

  schema "posts" do
    field :body, :string

    timestamps(type: :utc_datetime_usec)
  end
end
