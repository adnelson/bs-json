type rec line = {
  start: point,
  end_: point,
  thickness: option<int>,
}
and point = {
  x: int,
  y: int,
}

module Decode = {
  let point = json => {
    open Json.Decode
    {
      x: field("x", int)(json),
      y: field("y", int)(json),
    }
  }

  let line = json => {
    open Json.Decode
    {
      start: field("start", point)(json),
      end_: field("end", point)(json),
      thickness: optional(field("thickness", int))(json),
    }
  }
}

let data = ` {
  "start": { "x": 1, "y": -4 },
  "end":   { "x": 5, "y": 8 }
} `

let _ = Js.log(Decode.line(Json.parseOrRaise(data)))
