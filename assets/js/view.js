import { loadModules } from 'esri-loader';

export function mountView(state, location) {
  loadModules(["esri/Map", "esri/views/SceneView"])
    .then(([Map, SceneView]) => {
      const view = state.view = new SceneView({
        map: new Map({
          basemap: "satellite",
          ground: "world-elevation",
          ui: {
            components: []
          }
        }),
        ui: {
          components: []
        },
        environment: {
          starsEnabled: false,
          atmosphereEnabled: true
        },
        qualityProfile: "low",
        container: "view",
        zoom: 12,
        tilt: 90,
        rotation: 0,
        center: {
          latitude: parseFloat(location.lat),
          longitude: parseFloat(location.lng),
          z: parseFloat(location.alt),
        }
      })

      view.on("focus", function (event) {
        event.stopPropagation();
      });
      view.on("key-down", function (event) {
        event.stopPropagation();
      });
      view.on("mouse-wheel", function (event) {
        event.stopPropagation();
      });
      view.on("double-click", function (event) {
        event.stopPropagation();
      });
      view.on("double-click", ["Control"], function (event) {
        event.stopPropagation();
      });
      view.on("drag", function (event) {
        event.stopPropagation();
      });
      view.on("drag", ["Shift"], function (event) {
        event.stopPropagation();
      });
      view.on("drag", ["Shift", "Control"], function (event) {
        event.stopPropagation();
      });
    });
}

export function updateView(state, location) {
  if (state.view) {
    const value = {
      position: {
        latitude: parseFloat(location.lat),
        longitude: parseFloat(location.lng),
        z: parseFloat(location.alt),
      },
      zoom: 12,
      heading: parseFloat(location.bearing),
      tilt: 90
    }
    state.view.goTo(value, {
      animate: false
    })
    .catch(function(error) {
      if (error.name != "AbortError") {
         console.error(error);
      }
    });
  }
}
