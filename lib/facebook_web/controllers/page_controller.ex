defmodule FacebookWeb.PageController do
  use FacebookWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
