defmodule FlightSimulatorWeb.FlightSimulatorLive do
  use FlightSimulatorWeb, :live_view

  alias FlightSimulatorWeb.Instrument

  @initial_state %FlightSimulator{
    location: %{lat: -33.964592291602244, lng: 151.18069727924058},
    bearing: 347.0
  }

  @tick 30
  @tick_seconds @tick / 1000

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(@tick, self(), :tick)

    {:ok, assign(socket, simulator: @initial_state)}
  end

  @impl true
  def handle_info(:tick, socket) do
    socket.assigns.simulator
    |> FlightSimulator.update(@tick_seconds)
    |> update_simulator(socket)
  end

  @impl true
  def handle_event("control_input", %{"key" => code}, socket)
      when code in ["ArrowLeft", "KeyA"] do
    socket.assigns.simulator
    |> FlightSimulator.roll_left()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"key" => code}, socket)
      when code in ["ArrowRight", "KeyD"] do
    socket.assigns.simulator
    |> FlightSimulator.roll_right()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"key" => code}, socket)
      when code in ["ArrowUp", "KeyW"] do
    socket.assigns.simulator
    |> FlightSimulator.pitch_down()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"key" => code}, socket)
      when code in ["ArrowDown", "KeyS"] do
    socket.assigns.simulator
    |> FlightSimulator.pitch_up()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"key" => "Minus"}, socket) do
    socket.assigns.simulator
    |> FlightSimulator.speed_down()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"key" => "Equal"}, socket) do
    socket.assigns.simulator
    |> FlightSimulator.speed_up()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"key" => "Comma"}, socket) do
    socket.assigns.simulator
    |> FlightSimulator.yaw_left()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"key" => "Period"}, socket) do
    socket.assigns.simulator
    |> FlightSimulator.yaw_right()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"key" => "Space"}, socket) do
    socket.assigns.simulator
    |> FlightSimulator.reset_attitude()
    |> update_simulator(socket)
  end

  def handle_event("control_input", %{"key" => "Escape"}, socket) do
    update_simulator(@initial_state, socket)
  end

  def handle_event("control_input", _key, socket) do
    {:noreply, socket}
  end

  def update_simulator(state, socket) do
    {:noreply, assign(socket, :simulator, state)}
  end
end
