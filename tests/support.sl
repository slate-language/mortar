// What every test file here needs and the runner does not have.

// The message a call left behind, or empty where it did not fault.
//
// **Every component in this library has an error path and it is a FAULT rather than a result**, so
// this is how a test asks what a bad prop said. What is asserted is that the sentence names the prop
// -- not the whole sentence, which would make every wording change a test change for nothing.
export fell(f) -> string =
    var said = ""

    try
        f()
    catch e
        said = e.message

    said

// How many times one string occurs in another.
export countOf(s: string, sub: string) -> integer =
    var found = 0
    var from = 0

    while true
        val at = indexOf(s[from..], sub)

        if at == null then break

        found = found + 1
        from = from + at + sub.length

    found

// The markup with every `<style>` element taken out of it, which is what a test about the TREE
// wants: `html(root)` answers the sheets in front of the fragment, and a component's own markup is
// what is left.
export tree(out: string) -> string =
    var rest = out

    while true
        val opened = indexOf(rest, "<style")

        if opened == null then break

        val closed = indexOf(rest, "</style>")

        rest = rest[0..<opened] + rest[(closed + 8)..]

    rest
