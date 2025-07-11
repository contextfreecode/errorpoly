pub fun main()
  entries.foreach fn(entry)
    println(entry.binarize)

pub fun binarize(texts: vector<string>): exn string
  map-join(texts) fn(text)
    match text
      "yes" -> "1"
      "no" -> "0"
      _ -> throw("bad text")

pub fun map-join(items: vector<t>, f: (t) -> e string): e string
  items.map(f).join("")

val entries = vector([
  vector(["yes", "no", "yes"]),
  vector(["yes", "no", "maybe"]),
])
