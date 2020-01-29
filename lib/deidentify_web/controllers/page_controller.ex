defmodule DeidentifyWeb.PageController do
  use DeidentifyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
