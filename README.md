# Phoenix LiveView Flight Simulator

It's a simple flight simulator written in Phoenix LiveView.

There's no fancy linear algebra here (yet) it was conceived in 2019 mostly to test out what LiveView was capable of.  LiveView in 2019 was perfectly capable of building this, but there were a few rough edges I needed to work around.

In 2022 the LiveView story is massively improved with the introduction of function components. So I've rewritten the original repo to take advantage of Tailwind and function components. Leaflet stopped working properly, so I've replaced it with Google Maps which works well.

https://github.com/joshprice/groundstation

## Getting started

You'll need to add your Google Maps API key here:

https://github.com/team-alembic/liveview-flight-simulator/blob/main/assets/js/map.js#L5

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
