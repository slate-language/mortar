{
    name: "mortar",
    version: "0.1.0",

    // **One module, and that is the whole of the public surface.** `mortar.slx` declares every
    // component the library has; the files under `parts/` are where the bodies and the stylesheets
    // live and are not something a consumer names. slate has no re-export, so a name a program
    // imports has to be declared in the file it imports -- which is what the aliases in `mortar.slx`
    // are, and what makes that file the interface rather than a table in a README.
    //
    // **Nothing here imports a host.** No `lath/dom`, no `slate:dom`: every component renders to
    // markup on a server and into a document in a browser, and a suite can render all of them under
    // the interpreter with no page in the room.
    main: "mortar.slx",

    dependencies: {
        // The framework. **0.5.1 is the floor and it is not a preference**: `style(css)` is what
        // puts a component's stylesheet on the page, and 0.5.1 is the release in which a run of text
        // children and an empty text child hydrate against markup a browser parsed. Every component
        // here writes both.
        lath: { git: "github.com/slate-language/lath", version: "0.5.1" },
    },
}
