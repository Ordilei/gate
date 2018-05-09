defmodule GateWeb.PageController do
  use GateWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
