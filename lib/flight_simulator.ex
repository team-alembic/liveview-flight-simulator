defmodule FlightSimulator do
  import Geocalc

  @moduledoc """
  The state of a simulated aircraft with ability to control basic parameters and
  update them over time.

  ## Units

  - All angles are expressed in degrees (and are converted to radians internally when needed)
  - All distances are expressed in metres
  - All speeds are expressed in metres per second
  """

  @pitch_delta 1.0
  @max_pitch_angle 50.0
  @min_pitch_angle -50.0

  @roll_delta 1.0
  @max_roll_angle 60.0
  @min_roll_angle -60.0

  @yaw_delta 1.0

  @speed_delta 0.2
  @min_speed 0.2
  @max_speed 120.0

  @min_altitude 1.0

  @reset_factor 1.1

  defstruct bearing: 0.0,
            altitude: @min_altitude,
            pitch_angle: 0.0,
            roll_angle: 0.0,
            speed: @min_speed,
            location: %{lat: 0.0, lng: 0.0}

  def reset_attitude(state),
    do:
      struct(state,
        pitch_angle: state.pitch_angle / @reset_factor,
        roll_angle: state.roll_angle / @reset_factor
      )

  def speed_down(state),
    do: struct(state, speed: max(state.speed - @speed_delta, @min_speed))

  def speed_up(state),
    do: struct(state, speed: min(state.speed + @speed_delta, @max_speed))

  def pitch_down(state),
    do: struct(state, pitch_angle: max(state.pitch_angle - @pitch_delta, @min_pitch_angle))

  def pitch_up(state),
    do: struct(state, pitch_angle: min(state.pitch_angle + @pitch_delta, @max_pitch_angle))

  def roll_left(state),
    do: struct(state, roll_angle: max(state.roll_angle - @roll_delta, @min_roll_angle))

  def roll_right(state),
    do: struct(state, roll_angle: min(state.roll_angle + @roll_delta, @max_roll_angle))

  def yaw_left(state),
    do: struct(state, bearing: update_bearing(state.bearing, -@yaw_delta))

  def yaw_right(state),
    do: struct(state, bearing: update_bearing(state.bearing, @yaw_delta))

  @doc """
  Calculate the changes in the simulator state over the time given in seconds.

  ## Example

      iex> update(%FlightSimulator{}, 10)
      %FlightSimulator{
        altitude: 1.0,
        pitch_angle: 0.0,
        roll_angle: 0.0,
        speed: 0.2,
        bearing: 0.0,
        location: %{lat: 0.0, lng: 2.0}
      }

  """
  def update(state, time) do
    distance = ground_distance(state.speed, time, state.pitch_angle)

    struct(state,
      bearing:
        update_bearing(state.bearing, bearing_delta_for_roll(state.roll_angle, state.speed, time)),
      altitude: update_altitude(state.altitude, altitude_delta(distance, state.pitch_angle)),
      location: update_location(state.location, state.bearing, distance)
    )
  end

  @doc """
  Calculate new bearing given the current bearing (in degrees) and a delta (in degrees).

  ## Example

      iex> update_bearing(0, 0)
      0.0
      iex> update_bearing(0, 1)
      1.0
      iex> update_bearing(0, 180)
      180.0
      iex> update_bearing(360, 270)
      270.0
      iex> update_bearing(0, -1)
      359.0
      iex> update_bearing(0, -180)
      180.0
      iex> update_bearing(0, -360)
      0.0

  """
  def update_bearing(bearing, delta) do
    new_bearing =
      (bearing + delta)
      |> degrees_to_radians()
      |> radians_to_degrees()

    if new_bearing >= 0 do
      new_bearing
    else
      360 + new_bearing
    end
  end

  @doc """
  Calculate new altitude given the current altitude (in metres) and a delta (in metres).

  ## Example

      iex> update_altitude(0, 0)
      1.0
      iex> update_altitude(0, 1)
      1.0
      iex> update_altitude(0, -1)
      1.0
      iex> update_altitude(500, 1)
      501.0
      iex> update_altitude(500, -501)
      1.0

  """
  def update_altitude(altitude, delta) do
    max(@min_altitude, altitude + delta) / 1
  end

  @doc """
  Calculate ground distance given speed (metres/second) and time (seconds).

  Account for the pitch angle to calculate the actual distance travelled across the ground.

  ## Example

      iex> ground_distance(10, 1, 0)
      10.0
      iex> ground_distance(10, 10, 0)
      100.0

  """
  def ground_distance(speed, time, pitch_angle) do
    speed * time * cos(pitch_angle)
  end

  @doc """
  Calculate the change in altitude given the actual distance travelled (not ground distance).

  ## Example

      iex> altitude_delta(10, 0)
      0.0
      iex> altitude_delta(10, 30)
      4.999999999999999
      iex> altitude_delta(10, 90)
      10.0

  """
  def altitude_delta(distance, pitch_angle) do
    distance * sin(pitch_angle)
  end

  @doc """
  Calculate the change in bearing (degrees) given the roll angle (degrees), speed (in m/s) and time (in seconds).

  ## Example

      iex> bearing_delta_for_roll(0, 100, 100)
      0.0
      iex> bearing_delta_for_roll(10, 100, 0)
      0.0
      iex> bearing_delta_for_roll(10, 50, 1)
      1.979301705471317
      iex> bearing_delta_for_roll(-10, 50, 1)
      -1.979301705471317

  """
  def bearing_delta_for_roll(roll_angle, speed, time) do
    time * rate_of_turn(roll_angle, speed)
  end

  @doc """
  Calculate rate of turn (in degrees / second) given roll angle (in degrees) and current speed (in m/s).

  See http://www.flightlearnings.com/2009/08/26/rate-of-turn/ for formula.

  ## Example

      iex> rate_of_turn(30, 60)
      5.400716176417849
      iex> rate_of_turn(-30, 60)
      -5.400716176417849
      iex> rate_of_turn(10, 60)
      1.6494180878927642
      iex> rate_of_turn(-10, 60)
      -1.6494180878927642
      iex> rate_of_turn(10, 30)
      3.2988361757855285
      iex> rate_of_turn(-10, 30)
      -3.2988361757855285

  """
  @knots_per_metre_per_second 1.9438444924406
  @rot_constant 1_091
  def rate_of_turn(roll_angle, speed) do
    @rot_constant * tan(roll_angle) / (speed * @knots_per_metre_per_second)
  end

  @doc """
  Calculate new location for distance (in metres) and bearing (in degrees) from current location

  Need this for lat/lng point given distance and bearing
  http://www.movable-type.co.uk/scripts/latlong.html#dest-point
  """
  def update_location_great_circle(%{lat: lat, lng: lng}, bearing, distance) do
    {:ok, [lat_new, lng_new]} =
      destination_point({lat, lng}, degrees_to_radians(bearing), distance * 100)

    %{lat: lat_new, lng: lng_new}
  end

  @doc """
  Calculate new location for distance (in metres) and bearing (in degrees) from current location

  ## Example

      iex> update_location(%{lat: 0, lng: 0}, 0, 1)
      %{lat: 0.0, lng: 1.0}
      iex> update_location(%{lat: 0, lng: 0}, 45, 1)
      %{lat: sin(45), lng: cos(45)}
      iex> update_location(%{lat: 0, lng: 0}, 90, 1)
      %{lat: 1.0, lng: cos(90)}
      iex> update_location(%{lat: 0, lng: 0}, 135, 1)
      %{lat: sin(135), lng: cos(135)}
      iex> update_location(%{lat: 0, lng: 0}, 180, 1)
      %{lat: sin(180), lng: -1.0}
      iex> update_location(%{lat: 0, lng: 0}, 225, 1)
      %{lat: sin(225), lng: cos(225)}
      iex> update_location(%{lat: 0, lng: 0}, 270, 1)
      %{lat: -1.0, lng: cos(270)}
      iex> update_location(%{lat: 0, lng: 0}, 315, 1)
      %{lat: sin(315), lng: cos(315)}

  """
  def update_location(%{lat: lat, lng: lng}, bearing, distance) do
    %{
      lat: lat + sin(bearing) * distance,
      lng: lng + cos(bearing) * distance
    }
  end

  def sin(a), do: :math.sin(degrees_to_radians(a))
  def cos(a), do: :math.cos(degrees_to_radians(a))
  def tan(a), do: :math.tan(degrees_to_radians(a))
end
