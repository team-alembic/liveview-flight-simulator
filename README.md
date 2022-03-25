# Phoenix LiveView Flight Simulator

It's a simple flight simulator written in Phoenix LiveView. The flight simulation takes place completely on the server side, where Phoenix Live View sends DOM updates over a websocket at appoximately 30fps (1 tick every ~30ms).

Every client browser will get their own world with your very own plane in it, so enjoy flying around Sydney (you'll start on the main runway of Sydney International airport).


There's no fancy linear algebra here (yet) it was conceived in 2019 mostly to test out what LiveView was capable of.  LiveView in 2019 was perfectly capable of building this, but there were a few rough edges I needed to work around.

In 2022 the LiveView story is massively improved with the introduction of function components. So I've rewritten the original repo to take advantage of Tailwind and function components. Leaflet stopped working properly, so I've replaced it with Google Maps which works well.

https://github.com/joshprice/groundstation

Have fun!


## Getting started

You'll need to add your Google Maps API key here:

https://github.com/team-alembic/liveview-flight-simulator/blob/main/assets/js/map.js#L5

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Flight Manual

### Keyboard Commands

- `wasd` or `Arrow keys` controls the planes' roll and pitch
  - `up` or `w` points the plane down toward the ground
  - `down` or `s` points the plane up into the air
  - `left`/`right` or `a`/`d` banks left and right
- `,`/`.` turns the rudder left / right (yaw control - useful for taxiing on a runway)
- `-`/`=` increase / decrease speed
- `Esc` reset the simulation
- `Space` partially restore the plane to level flight

## Implementation Highlights

- The **Artificial Horizon** and **Compass** are rendered using hand-written SVG which is updated directly by Live View.
- The **Map** is implemented using Google Maps
- The **3D Cockpit View** is implemented using the ESRI library and the ArcGIS SDK https://developers.arcgis.com/javascript/latest/api-reference/esri-views-SceneView.html
- Both the Map and Cockpit view are updated using Live View Hooks which runs JS functions on DOM updates from the server

## Limitations

- It requires keyboard input to control the plane, so this probably won't work well on mobile devices (at least I haven't tested it)
- This is running on a tiny free tier Gigalixir deployment so if lots of people are using this, then it's going to not work that well. That said it's Elixir and it'll probably handle quite a lot of planes before crashing and burning ;)
- If you want to experience it super smooth then please run it locally to spare some bandwidth
- I tried getting the 3d camera to tilt but it wouldn't point up reliably, and often flipped upside down and be generally janky so our view stays level
- Don't fly too close to the ground as the 3d view doesn't react that well when you run into hills and mountains, but it's kind of fun.

## Contributing

Bug reports and PRs welcome!

## Background

This app is the starting point of building the Ground Station application for the UAV Challenge 2020 (https://uavchallenge.org/medical-rescue/). For this challenge, the BEAM UAV team will be attempting to complete the challenge using 2 drones and controlling them with as much Elixir and the BEAM for the software components as possible.

I wrote the Flight Simulator so this would be a bit more interactive and fun for a more general audience, as well as showing off the power and simplicity of Phoenix Live View.

## Thanks

Special thanks to Robin Hilliard for the motivation to build this and some guidance around simplifying the maths of the simulator. Also thanks to David Parry and Rufus Post for moral support.

Lastly I really appreciate all the hard work that's gone into Live View, it's an amazing technology that we'll hopefully see a lot more of in the coming years. So thanks Chris McCord and Jose Valim!

