export function mountVR(state, location) {
  let pos = {
    lat: parseFloat(location.lat),
    lng: parseFloat(location.lng),
    alt: parseFloat(location.alt),
    pitch: parseFloat(location.pitch),
    yaw: parseFloat(location.bearing),
    roll: parseFloat(location.roll),
  }

  state.camera = {
    rigElement: document.getElementById("vr-rig"),
    cameraElement: document.getElementById("vr-camera"),
    compassElement: document.getElementById("compass"),
    horizonElement: document.getElementById("horizon"),
    pos: pos,
  }

  updateVR(state, location)
}

export function updateVR(state, location) {
  let cam = state.camera.cameraElement
  let rig = state.camera.rigElement
  let compass = state.camera.compassElement
  let horizon = state.camera.horizonElement
  let pos = {
    lat: parseFloat(location.lat),
    lng: parseFloat(location.lng),
    alt: parseFloat(location.alt),
    pitch: parseFloat(location.pitch),
    roll: parseFloat(location.roll),
    yaw: parseFloat(location.bearing),
  }
  state.pos = pos
  rig.setAttribute("position", { x: pos.lat, y: pos.alt, z: -pos.lng })
  rig.setAttribute("rotation", { x: pos.pitch, y: -pos.yaw, z: -pos.roll })
  compass.setAttribute("rotation", { x: -90, y: pos.yaw, z: 0 })
  horizon.setAttribute("rotation", { x: 0, y: 0, z: pos.roll })
  horizon.setAttribute("position", { x: 0, y: -(pos.pitch / 100), z: -0.25 })

  // console.log(pos)
}
