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

## Why there are two of these

**[`chalk`](https://github.com/slate-language/chalk) declares exactly the same names with exactly the
same props and almost no style at all.** An application swaps one import for the other and keeps its
pages — and what it sees change is precisely the part that was appearance.

`examples/page.slx` is the same file in both repositories except for one import. Run it in each:

```
slate examples/page.slx
```

| | `mortar` | `chalk` |
|---|---|---|
| markup for that page | 3,955 bytes | 2,940 bytes |
| stylesheets on it | 16 | 1 |
| whole answer | 20,327 bytes | 4,642 bytes |

**What is identical in the two outputs is the interesting half**: the `<header>`, `<main>` and
`<footer>`, the skip link, `role="status"` on an empty list and `role="alert"` on a problem, the
`aria-live` region rendered before there is anything in it, `for`/`id` between every label and its
control, `aria-describedby` and `aria-invalid` where a field has an error, `aria-current` on the
filter in force, a real `<a href>` behind every sort order and page number, and the `<li>` a thread
in a list is. None of that is decoration, and neither library leaves it out.

**What differs is everything else.** `mortar` puts a class on each element and a stylesheet behind
it; `chalk` writes the element and a `data-` attribute for the word you gave it.

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
| `useTheme()` | `[theme, setTheme]` |
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

**There is no minifier, so a sheet ships as it was written, comments included.** That is about 3.6 KB
of the library's 16.7 KB, and a page only carries the sheets of the components it actually rendered.
Serve it compressed and it is not something to think about.

## Theming, and why the theme is in the URL

`Theme` renders `<div class="mortar" data-theme="light">` and every colour in the library is a
`var(--m-…)` re-declared under `[data-theme="dark"]` — so a whole page turning over is one attribute,
not a class per element and not a second stylesheet. `tests-dom/theme.slx` measures it: three
mutation records for a page going dark.

**With no `theme` prop, the choice is `?theme=dark` in the address, read with lath's `useSearch`.**

```slate
val [theme, setTheme] = useTheme()

<Button onClick={() -> setTheme(if theme == "light" then "dark" else "light")}>
    {if theme == "light" then "Dark" else "Light"}
</Button>
```

That is the arrangement to reach for, and the reason is the **server**: a page rendered for
`/?theme=dark` is dark in the markup, so there is no first paint in the wrong colours and nothing for
a hydrating page to correct. A choice kept in `localStorage` is invisible to the server, and the page
flips in front of the reader. `set` rewrites the address rather than pushing it — changing a theme is
not somewhere anybody went — and `theme=light` is the absence of the parameter, so a copied URL has
nothing in it that did not need to be there.

**The cookie form is the same component with the value handed in**: the server reads its own cookie
and passes `theme`, and `onChange` posts a form that sets it.

```slate
<Theme theme={fromTheCookie} onChange={(next) -> post("/theme", { theme: next })}>
```

It buys a URL with nothing in it and costs a route and a `Set-Cookie`. `useTheme` is **not a hook**
in either arrangement — it keeps no slot, so it may be called inside a condition.

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

`tests/interface.slx` is the same file in `chalk`'s repository, which is what keeps the two libraries
swappable.

## Requirements

slate **0.0.30** or newer, and lath **0.5.1** or newer. The lath floor is not a preference: `style(css)`
is where a component's stylesheet comes from, and 0.5.1 is the release in which a run of text children
and an empty text child hydrate against markup a browser parsed — which every component here writes.

## Licence

ISC.
