# mortar

A component library for [lath](https://github.com/slate-language/lath), written in
[slate](https://github.com/slate-language/slate).

Twenty-seven components, each with its own stylesheet beside it — modern css, native nesting, custom
properties for the theme. **No preprocessor, no build step, and nothing to fetch at run time**: a
stylesheet is a file the compiler reads and the program carries, and a page ends up with a `<style>`
for exactly the components it rendered, on a server and in a browser alike.

```
slate add github.com/slate-language/mortar
```

```slate
import { createElement, Fragment, mount, html } from lath
import { Card, Page, Theme } from mortar

App(props) =
    <Theme>
        <Page brand="the board" footer={<p>slate, end to end.</p>}>
            <Card title="Hello" href="/hello">
                <p>A card, a page and a theme, and three stylesheets on the page.</p>
            </Card>
        </Page>
    </Theme>

print(html(mount(<App/>)))
```

`createElement` and `Fragment` have to be imported wherever an element is written: slate's parser
desugars `<div/>` into a call to them.

## What one page comes to

`examples/page.slx` is a board — threads, a reply, a filter, a sort order, a page number, a form
and a problem — rendered to markup with nothing else in the room:

```
slate examples/page.slx
```

| | |
|---|---|
| markup for that page | 3,977 bytes |
| stylesheets on it | 16 |
| whole answer | 55,875 bytes, or 15,190 over the wire |

**A page carries only what it rendered.** Each component brings its own sheet the first time it
appears and never again, so a page with no `Toast` on it ships no toast css — which is what one
stylesheet per component buys, and why there is no build step to configure.

**And most of what comes out is not decoration at all**: the `<header>`, `<main>` and `<footer>`, the
skip link, `role="status"` on an empty list and `role="alert"` on a problem, the `aria-live` region
rendered before there is anything in it, `for`/`id` between every label and its control,
`aria-describedby` and `aria-invalid` where a field has an error, `aria-current` on the filter in
force, a real `<a href>` behind every sort order and page number, and the `<li>` a thread in a list
is. That is the half an application should not be writing again.

## The interface

Every component takes an optional `class`, **appended** to its own — never substituted. Every
component checks the props it is about to use and refuses with a sentence that **names the prop**:

```
Pagination's `total` is a whole number of things, and is "40"
Avatar's `size` is one of "small", "medium", "large", and is "huge"
Toast's `messages`, item 1, has no `id`
```

| | props |
|---|---|
| `Theme` | `theme`, `onChange`, `children` |
| `useTheme()` | `[theme, setTheme]` -- a hook, reading and writing the theme atom directly |
| `Page` | `brand`, `brandHref`, `nav`, `search`, `footer`, `skipLabel`, `mainId`, `children` |
| `VisuallyHidden` | `tag`, `children` |
| `Avatar` | `name`, `src`, `size` |
| `Byline` | `name`, `src`, `href`, `at`, `size` |
| `Timestamp` | `at`, `show` |
| `Photo` | `src`, `alt` |
| `Card` | `title`, `href`, `level`, `children` |
| `ThreadCard` | `title`, `href`, `level`, `name`, `src`, `authorHref`, `at`, `excerpt`, `tags`, `tagHref`, `replies`, `children` |
| `CardList` | `children` |
| `Post` | `title`, `level`, `name`, `src`, `authorHref`, `at`, `body`, `photo`, `alt`, `tags`, `tagHref`, `compact`, `children` |
| `PostList` | `children` |
| `Tag` | `label`, `href`, `count`, `current`, `onChoose` |
| `TagList` | `tags`, `href`, `current`, `onChoose` |
| `Pagination` | `page`, `size`, `total`, `href`, `onChoose`, `unit` |
| `Segmented` | `options`, `value`, `href`, `onChoose`, `label` |
| `SortControls` | `options`, `sort`, `href`, `onChoose`, `label` |
| `EmptyState` | `title`, `detail`, `children` |
| `Problem` | `problem`, `title`, `detail`, `status`, `errors`, `reason` |
| `Live` | `live`, `atomic`, `children` |
| `Toast` | `messages`, `live`, `onDismiss`, `dismissLabel` |
| `Form` | `action`, `method`, `enctype`, `csrf`, `csrfName`, `onSubmit`, `label`, `children` |
| `Field` | `name`, `label`, `kind`, `value`, `error`, `hint`, `required`, `placeholder`, `autocomplete`, `id`, `onInput` |
| `TextArea` | `name`, `label`, `value`, `rows`, `error`, `hint`, `required`, `placeholder`, `id`, `onInput` |
| `FileInput` | `name`, `label`, `accept`, `maxSize`, `error`, `hint`, `required`, `id`, `onInput` |
| `Button` | `kind`, `variant`, `disabled`, `onClick`, `label`, `children` |
| `Actions` | `children` |

Plus ten exported lists of the words a prop may be — `Themes`, `Sizes`, `Shows`, `CardLevels`,
`PostLevels`, `LiveManners`, `Tones`, `FormMethods`, `ButtonKinds`, `ButtonVariants` — and
`problemReason`, the sentence one row of a problem document becomes.

**Every default and every refusal is in [`docs/components.md`](docs/components.md)**, which the suite
checks against the exports rather than trusting to memory.

## A stylesheet is a file

```slate
import { createElement, Fragment, style } from lath
import sheet from "./card.css"

card(props) =
    style(sheet)

    <div class="m-card">{props.children}</div>
```

`import sheet from "./card.css"` is [slate's asset
import](https://github.com/slate-language/slate/blob/dev/docs/reference/modules.md): the file is read
while the program is compiled and travels inside it, so a stylesheet stays something an editor
highlights and a browser's dev tools understand rather than a quoted blob in the middle of a
component. `style(css)` is lath's, and it registers the sheet **once per distinct sheet** — a list of
fifty cards is one `<style>`.

**Where it lands is the host's answer.** A server writes one `<style>` per sheet in front of the
fragment, so `html(root)` is one self-contained string a template drops into a `<div>`; a page puts
them in the document's head. A hydrated page writes none of them, the server having already sent
them.

**There is no minifier, so a sheet ships as it was written, comments included.** The library is
53.5 KB of css and 23 KB of that is the comments — which is a decision rather than an oversight: a
stylesheet here is meant to be read, and the paragraph saying *why* a reply is a rail rather than a
card is worth more than the bytes it costs. A page carries only the sheets of the components it
rendered, and the whole board above gzips to 15 KB. Serve it compressed and it is not something to
think about; if it ever is, a minifier is one step in front of the file the compiler reads.

## The look, and the four rules it comes from

Everything a sheet in this library can say is a token in
[`parts/tokens.css`](parts/tokens.css) — colour, a seven-step type scale, an eight-step space scale on
a quarter-rem grid, four radii, three elevations, one focus ring, and two motion durations. No sheet
writes a colour, a size or a duration of its own. Four rules decide what gets which.

**A serif means a person is talking.** The interface — a label, a page number, a filter, a button —
is set in the system's sans. A post's title and body, a thread's excerpt, and the textarea a reply is
typed into are set in the system's serif, at a size and a measure meant to be read for a minute
rather than glanced at for a second. It costs nothing to load: both faces are the ones the reader's
own machine already has.

**Elevation says what you are doing.** `Card` is flat, because a page shows twenty of them and twenty
shadows is a texture rather than a hierarchy; `Post` is raised, because there is one of it; a form is
a panel only when the caller says `class="card"`, meaning it is the thing on the page. A control is
the other direction — a well cut into the surface, which comes up to the raised colour under the
caret.

**A rail means attached.** A reply hangs off the post above it on a two-pixel rail rather than
sitting in a box of its own, a problem carries one in the danger colour, and a message in the corner
carries one in its tone. Nothing else has one.

**A pill is for choosing and a square corner is for doing.** Tags, segments and page numbers are
fully round because each is one of a set you pick from; a button is not a member of anything and has
a small square corner. `aria-current` is the only thing that says which choice is in force, so what
a page looks like and what a screen reader is told cannot drift apart.

Every text colour is checked against every ground it is written on, in both themes — 4.5:1 for the
quiet ones and better than 7:1 for body text. Every interactive part has a hover, an active and,
where it can be one, a disabled state, and one focus ring is drawn for all of them from
`.mortar :is(a, button, input, textarea, select, summary, [tabindex]):focus-visible` rather than per
component. **Every transition and animation takes its duration from one of two tokens**, and
`prefers-reduced-motion: reduce` sets both to zero in one block — so a component written next year is
covered before it is written.

## Theming, and why the theme is a cookie

`Theme` renders `<div class="mortar" data-theme="light">` and every colour in the library is a
`var(--m-…)` re-declared under `[data-theme="dark"]` — so a whole page turning over is one attribute,
not a class per element and not a second stylesheet. `tests-dom/theme.slx` measures it: three
mutation records for a page going dark.

**The theme lives in `themeAtom`, a plain lath atom, and `useTheme()` is `useAtom(themeAtom)`.** It
is a hook now, not the context-and-`useSearch` pair earlier versions used — it needs no `Theme` above
it to read from or write to.

```slate
val [theme, setTheme] = useTheme()

<Button onClick={() -> setTheme(if theme == "light" then "dark" else "light")}>
    {if theme == "light" then "Dark" else "Light"}
</Button>
```

**A reader's choice belongs to them, not to the page they were on, which is what a cookie is for and
a query string is not.** `?theme=dark` said something about *that address*; a cookie says something
about the reader, and is there again on the next request whichever page they land on next.

**The server seeds the atom from the request's cookie, one store per request:**

```slate
import { api } from sluice
import { createElement, mount, html, createStore, Provider } from lath
import { Theme } from mortar

app.get("/", (req) ->
    { body: html(mount(
        <Provider store={createStore()}>
            <Theme theme={req.cookies.theme}><Page/></Theme>
        </Provider>
    )) }
)
```

`createStore()` plus `<Provider>` gives each request its own atom, so two requests rendered by one
process never see each other's theme; `Theme`'s `theme` prop **seeds** that store's atom from the
cookie — `req.cookies.theme` is `null` when there is none, and a `Theme` with no `theme` prop reads
the atom exactly as it stands, `"light"` until something seeds or sets it. A cookie holding neither
word renders light rather than faulting, the same as an unrecognised address parameter used to.

**Seeding writes the atom once, for that render — it does not keep controlling it.** A page that
renders `<Theme theme={x}>` on every render is not fought by its own toggle: `useTheme()`'s setter,
called from anywhere in the tree, is the atom's own value from then on.

**The client writes the cookie back when the reader changes it — except there is currently no way to
do that from `slate:dom`.** `slate:dom` has `location`, `history` and `localStorage` and nothing that
reads or writes `document.cookie`; this is a gap in the host rather than something worth routing
around with raw JavaScript. Until it exists, `onChange` is the persistence mechanism: called with the
theme after every later change — never for the seed and never on mount, so a page can reach a server
route without posting to it on every load.

```slate
<Theme onChange={(next) -> post("/theme", { theme: next })}>
```

That route sets the cookie server-side, with `slate:http`'s `setCookie`, and the *next* request
already renders the right colour — which is everything a client-written cookie would have bought,
one round trip later.

## Server-rendered first, and hydration-clean

**Every component renders to a string with lath's `stringHost` and hydrates with zero DOM
mutations**, and that is measured rather than asserted: `tests-dom/hydrate.slx` puts each of them —
and then all of them at once, in one page — through the whole round trip, and watches the document
with a `MutationObserver` that has to record nothing.

That is not free. `{n} replies` is a run of text children a parser reads back as one text node, and
`<textarea>{""}</textarea>` writes an element with nothing in it; both were hydration faults until
lath 0.5.1 settled them in the tree. Every component here is written the ordinary way and the suite
is what says so.

**Nothing in this package imports a host.** There is no `lath/dom` and no `slate:dom`, so the whole
library renders under the interpreter, beside `slate:http` on a server, and in a browser.

## The tests

```
slate test tests
slate test --js tests
npm install
NODE_OPTIONS="--import ./tests-dom/setup.mjs" slate test --js tests-dom
```

**139, 139 and 27.** The first two are the same suite on both hosts. The third renders the components
into a real [jsdom](https://github.com/jsdom/jsdom) document — jsdom is a **dev** dependency of this
repository and of nothing else; a program that uses this package never sees npm.

`tests/interface.slx` reads that surface back — every name, what kind of thing it is, and a count —
so it cannot change by accident.

## Requirements

slate **0.0.30** or newer, and lath **0.6.0** or newer. The lath floor is not a preference: the theme
lives in an atom, and `atom`, `useAtom`, `createStore` and `Provider` are 0.6.0's. `style(css)` is
where a component's stylesheet comes from, and every component here also relies on 0.5.1's fix for a
run of text children and an empty text child hydrating against markup a browser parsed.

## Licence

ISC.
