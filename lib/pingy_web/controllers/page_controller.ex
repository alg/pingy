defmodule PingyWeb.PageController do
  use PingyWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
