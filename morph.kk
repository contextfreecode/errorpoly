pub fun main()
  val entries = vector([
    vector(["yes", "no", "yes"]),
    vector(["yes", "no", "maybe"]),
  ])
  entries.foreach fn(entry)
    println(entry.binarize)

pub fun binarize(tokens: vector<string>): exn string
  map-join(tokens) fn(token)
    match token
      "yes" -> "1"
      "no" -> "0"
      _ -> throw("bad token")

pub fun map-join(items: vector<t>, f: (t) -> e string): e string
  items.map(f).join("")
