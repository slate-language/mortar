// What a component does with a prop it cannot use.
//
// **A component library's ordinary mistake is a prop of the wrong shape**, and the ordinary way for
// one to go wrong is silently: `<Pagination total="40"/>` divides a string by a number somewhere
// three files down, `<TagList tags={null}/>` calls `map` on nothing, and the sentence that comes back
// names an expression inside this package rather than the attribute the reader wrote. So every
// component checks the props it is about to use, and every refusal here **names the prop and the
// component**:
//
//     Pagination's `total` is a whole number of rows, and is "40"
//
// **It is a fault and not a result**, which is slate's own division and not a preference: a prop of
// the wrong shape is a defect in the program that wrote the tag, not a condition the caller was
// going to handle. It unwinds to a `Boundary` exactly as any other render fault does.
//
// **The check is what the component is about to DO with the value, not a type declaration.** A prop
// annotated `array` would be checked by slate and the message would be slate's, which names the
// parameter of a function inside this package; these name the attribute as it was written in the
// tag, which is where the reader is looking.

// A value, described the way a sentence about it would say it.
//
// **A string keeps its quotes and nothing else does**, which is the difference between *"and is
// `"40"`"* and *"and is `40`"* -- the whole of what the reader needs in order to see the mistake.
export said(value) -> string
    if value == null then return "nothing"
    if value is string then return "\"" + value + "\""

    string(value)

// The head of every sentence here.
of(who: string, name: string) -> string = who + "'s `" + name + "`"

// Text, and text is the only thing a class name, a label or a URL can be.
export text(who: string, name: string, value) -> string
    if !(value is string)
        throw of(who, name) + " is text, and is " + said(value)

    value

// Text, or nothing at all -- which is the shape of every prop a component only sometimes has.
export maybeText(who: string, name: string, value)
    if value == null then return null

    text(who, name, value)

// A whole number that counts something, so never below zero.
//
// **A page number, a total and a row count are all this**, and each of them reads badly as a real:
// *"page 1.5 of 3"* is not a state the component should be asked to render.
export count(who: string, name: string, value) -> integer
    if !(value is number) || value < 0
        throw of(who, name) + " is a whole number of things, and is " + said(value)

    integer(value)

// A moment, as the seconds since the epoch a row carries.
//
// **A number and not a date**, because the two hosts have to agree about the text: a server rendering
// *"4 minutes ago"* and a browser adopting it a second later would disagree, and a mismatch is a
// fault by design.
export moment(who: string, name: string, value) -> number
    if !(value is number)
        throw of(who, name) + " is a moment in epoch seconds, and is " + said(value)

    value

// A list of anything.
export list(who: string, name: string, value) -> array
    if !(value is array)
        throw of(who, name) + " is a list, and is " + said(value)

    value

// A record.
export record(who: string, name: string, value) -> object
    if !(value is object)
        throw of(who, name) + " is a record, and is " + said(value)

    value

// A record, or nothing.
export maybeRecord(who: string, name: string, value)
    if value == null then return null

    record(who, name, value)

// One of a fixed set of words -- a size, a variant, a tone.
//
// **The message lists what the words ARE**, which is what a reader who wrote `size="big"` needs and
// is the thing a type could not say: the set is three strings and not a type in any language here.
export choice(who: string, name: string, value, allowed: array) -> string
    val names = allowed

    if value is string && names.indexOf(value) != null then return value

    var words = ""

    for one in names
        words = if words == "" then "\"" + one + "\"" else words + ", \"" + one + "\""

    throw of(who, name) + " is one of " + words + ", and is " + said(value)

// Yes or no, and nothing else.
//
// **`0` is true in slate and false in JavaScript**, so a prop taken as truthy would read differently
// depending on which back end the page was rendered on. It is a boolean or it is a mistake.
export flag(who: string, name: string, value) -> boolean
    if !(value is boolean)
        throw of(who, name) + " is true or false, and is " + said(value)

    value

// A function, or nothing -- which is every handler and every `href` that is computed from a value.
export maybeFn(who: string, name: string, value)
    if value == null then return null

    if !(value is function)
        throw of(who, name) + " is a function, and is " + said(value)

    value

// A function that is not optional.
export fn(who: string, name: string, value) -> function
    if !(value is function)
        throw of(who, name) + " is a function, and is " + said(value)

    value

// A list of records, each of which has to carry a member.
//
// **The index is in the message.** A list of forty tags with one bad row is a mistake somebody has to
// find, and *"`tags`, item 12, has no `label`"* is the difference between finding it and reading the
// whole list.
export rows(who: string, name: string, value, member: string) -> array
    val all = list(who, name, value)
    var at = 0

    for one in all
        if !(one is object)
            throw of(who, name) + ", item " + string(at) + ", is a record, and is " + said(one)

        if (one[member] ?? null) == null
            throw of(who, name) + ", item " + string(at) + ", has no `" + member + "`"

        at = at + 1

    all

// A component's own class names, with whatever the application added.
//
// **EVERY COMPONENT IN THIS LIBRARY TAKES A `class`, AND IT IS ALWAYS APPENDED RATHER THAN
// SUBSTITUTED.** A library that let a caller replace its class would be a library whose own
// stylesheet stops applying the moment anybody reaches for it; appending leaves the component
// looking like itself and puts the application's rule after it in the cascade, which is where a rule
// that means to win belongs.
export classes(who: string, own: string, extra) -> string
    if extra == null then return own

    val more = text(who, "class", extra)

    if more == "" then own else own + " " + more
