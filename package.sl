{
    name: "mortar",
    version: "0.4.0",

    // **One module, and that is the whole of the public surface.** `mortar.slx` declares every
    // component the library has; the files under `parts/` are where the bodies and the stylesheets
    // live and are not something a consumer names. slate has no re-export, so a name a program
    // imports has to be declared in the file it imports -- which is what the aliases in `mortar.slx`
    // are, and what makes that file the interface rather than a table in a README.
    //
    // **Only `parts/theme.slx` imports a host, and only for `slate:dom`'s cookie functions.** It
    // never calls one unguarded: the write is wrapped in a `catch`, so it is a no-op under the
    // interpreter and under a server, and every component still renders to markup on a server and
    // into a document in a browser with no other host import anywhere in the package.
    main: "mortar.slx",

    dependencies: {
        // The framework. **0.6.0 is the floor and it is not a preference**: the theme now lives in
        // an atom rather than the address bar, and `atom`, `useAtom`, `createStore` and `Provider`
        // are 0.6.0's. `style(css)` is what puts a component's stylesheet on the page, and every
        // component here writes both text and empty text children, which 0.5.1 was already the
        // floor for.
        lath: { git: "github.com/slate-language/lath", version: "0.7.0" },
    },
}
