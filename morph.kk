pub fun main()
  println(binarize(texts))
  println(binarize(texts2))

pub fun binarize(texts: vector<string>): exn string
  map-join(texts) fn(text)
    match text
      "yes" -> "1"
      "no" -> "0"
      _ -> throw("bad text")

pub fun map-join(items: vector<t>, f: (t) -> e string): e string
  items.map(f).join("")

val texts = vector(["yes", "no", "yes"])
val texts2 = vector(["yes", "no", "maybe"])
