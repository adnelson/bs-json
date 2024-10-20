/* Decoding a fixed JSON data structure using Json.Decode */
let mapJsonObjectString = (f, decoder, encoder: int => Js.Json.t, str) => {
  let json = Json.parseOrRaise(str)
  let decoded = Json.Decode.dict(decoder)(json)->(Js.Dict.map(v => f(v), _))
  Json.stringify(Json.Encode.dict(encoder)(decoded))
}

let sum = arr => Array.fold_left((a, b) => a + b, 0, arr)

/* prints `{ "foo": 6, "bar": 24 }` */
let _ = Js.log(
  mapJsonObjectString(
    sum,
    {
      open Json.Decode
      j => array(int)(j)
    },
    Json.Encode.int,
    `
      {
        "foo": [1, 2, 3],
        "bar": [9, 8, 7]
      }
    `,
  ),
)

/* Error handling */
let _ = {
  let json = Json.parseOrRaise(`{ "y": 42 } `)
  switch {
    open Json.Decode
    field("x", int)(json)
  } {
  | x => Js.log(x)
  | exception Json.Decode.DecodeError(msg) => Js.log("Error:" ++ msg)
  }
}
