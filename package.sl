{
    name: "mortar",
    version: "0.5.0",

    // **One module, and that is the whole of the public surface.** `mortar.slx` declares every
    // component the library has; the files under `parts/` are where the bodies and the stylesheets
    // live and are not something a consumer names. slate has no re-export, so a name a program
    // imports has to be declared in the file it imports -- which is what the aliases in `mortar.slx`
    // are, and what makes that file the interface rather than a table in a README.
    //
    // **Two files import a host and every other one imports none**: `parts/theme.slx`, for the
    // cookie a colour is persisted in, and `parts/confirm.slx`, for the body a dialog portals into
    // and the caret it moves. Neither calls one unguarded -- both ask `host()` first, so the call is
    // not made where there is no browser to make it in. Every other component renders to markup on a
    // server and into a document in a browser with no host import at all, and `Confirm` is the one
    // component in the library that renders NOTHING where there is no document, open or closed.
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
