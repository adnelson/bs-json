/* Decode a JSON tree structure */
type rec tree<'a> =
  | Node('a, list<tree<'a>>)
  | Leaf('a)

module Decode = {
  open Json.Decode

  let rec tree = decoder => andThen(x =>
      switch x {
      | "node" => node(decoder)
      | "leaf" => leaf(decoder)
      | _ => failwith("unknown node type")
      }
    , field("type", string))

  and node = decoder => json => Node(
    field("value", decoder)(json),
    field("children", map(a => Array.to_list(a), array(tree(decoder))))(json),
  )

  and leaf = decoder => json => Leaf(field("value", decoder)(json))
}

let rec indent = x =>
  switch x {
  | n if n <= 0 => ()
  | n =>
    print_string("  ")
    indent(n - 1)
  }

let print = {
  let rec aux = level => x =>
    switch x {
    | Node(value, children) =>
      indent(level)
      Js.log(value)
      List.iter(child => aux(level + 1)(child), children)
    | Leaf(value) =>
      indent(level)
      Js.log(value)
    }

  aux(0)
}

let json = ` {
  "type": "node",
  "value": 9,
  "children": [{
    "type": "node",
    "value": 5,
    "children": [{
      "type": "leaf",
      "value": 3
    }, {
      "type": "leaf",
      "value": 2
    }]
  }, {
      "type": "leaf",
      "value": 4
  }]
} `

let myTree = print(Decode.tree(Json.Decode.int)(Json.parseOrRaise(json)))
