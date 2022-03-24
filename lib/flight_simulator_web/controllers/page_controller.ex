defmodule FlightSimulatorWeb.PageController do
  use FlightSimulatorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
