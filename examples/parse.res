/* Parsing a JSON string using Json.parseOrRaise */

let arrayOfInts = str => {
  let json = Json.parseOrRaise(str)
  open Json.Decode
  array(int)(json)
}

/* prints `[3, 2, 1]` */
let _ = Js.log(Js.Array.reverseInPlace(arrayOfInts("[1, 2, 3]")))
