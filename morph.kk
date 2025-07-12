fun main(): <console,exn> ()
  val entries = vector([
    vector(["yes", "no", "yes"]),
    vector(["yes", "no", "maybe"]),
  ])
  entries.foreach fn(entry)
    with final ctl throw-exn(exn)
      match exn.info
        ExnBadToken -> println("bad token")
        _ -> throw-exn(exn)
    println(entry.binarize)

fun binarize(tokens: vector<string>): _ string
  map-join(tokens) fn(token)
    match token
      "yes" -> "1"
      "no" -> "0"
      _ -> throw(token, ExnBadToken)

fun map-join(items: vector<t>, f: (t) -> e string): e string
  items.map(f).join("")

extend type exception-info
  ExnBadToken
