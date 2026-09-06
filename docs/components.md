# The components

Every prop, every default, and every sentence a component refuses with.

**Two rules hold for all of them and are not repeated in the tables.**

- **Every component takes an optional `class`, appended to its own** — never substituted. A library
  whose class could be replaced is a library whose stylesheet stops applying the moment anybody
  reaches for it.
- **Every component checks the props it is about to use, and a refusal names the prop.** It is a
  fault and not a result: a prop of the wrong shape is a defect in the program that wrote the tag,
  and it unwinds to a `Boundary` like any other render fault.

  ```
  Pagination's `total` is a whole number of things, and is "40"
  Avatar's `size` is one of "small", "medium", "large", and is "huge"
  Toast's `messages`, item 1, has no `id`
  ```

**A navigational prop is a function and not a string.** `href` on `TagList`, `Pagination` and
`Segmented` is handed the label, the page number or the value, and answers an address — because the
component knows the value and the application knows what a value means as a URL.

---

## Theme

| prop | default | what it is |
|---|---|---|
| `theme` | `null` | `"light"` or `"dark"`. With none, the theme is whatever `themeAtom` already holds |
| `onChange` | `null` | called with the theme after every later change; never for the seed and never on mount |
| `children` | `[]` | |

Renders `<div class="mortar" data-theme="…">`, which is what every stylesheet in the library selects
a dark page on. The value comes from a module-level atom, `themeAtom`, that every `Theme` and every
`useTheme()` read and write directly.

**`theme` seeds the atom; it does not control it.** Handing it in writes the atom once, for this
render; a later `useTheme()` toggle from anywhere in the tree is the atom's own value after that,
not fought by a `theme` prop a caller kept passing. The ordinary use is a server seeding a fresh
per-request store from the request's cookie — see the README's "Theming" section.

**An atom holding something that is neither word is the default, quietly.** A `theme` prop is the
program's own value and refuses if it is neither word; the atom is not something `Theme` can refuse
on the caller's behalf; the same default applies rather than a fault.

**Refuses**: a `theme` prop that is neither word — that one comes from the program, so it is the
program's mistake and says so.

## `useTheme()`

Answers `[theme, setTheme]`, straight off `themeAtom` — it **is** a hook. With no `Theme` above it,
the theme is `"light"` until something seeds or sets it, and the setter always works.

## Page

| prop | default | what it is |
|---|---|---|
| `brand` | `null` | the text of the brand link; with none, no link is rendered |
| `brandHref` | `"/"` | where the brand goes |
| `nav` | `null` | an element: what stands at the right of the header |
| `search` | `null` | an element: what stands beside the brand |
| `footer` | `null` | an element; with none, no `<footer>` is rendered |
| `skipLabel` | `"Skip to content"` | |
| `mainId` | `"main"` | what the skip link points at and what `<main>` carries |
| `children` | `[]` | the content of `<main>` |

**The header's pieces are slots and not props**, so a search form on one board and a project picker
on another are both an element the application already knows how to build.

## VisuallyHidden

| prop | default | what it is |
|---|---|---|
| `tag` | `"span"` | `"span"` or `"legend"` |
| `children` | `[]` | |

`clip-path`, not `display: none` — a hidden element is not announced at all, and the point of this
one is to be announced.

## Avatar

| prop | default | what it is |
|---|---|---|
| `name` | `"?"` | the person's name; the first letter is the fallback and the `alt` of the picture |
| `src` | `null` | the picture; with none, the letter |
| `size` | `"small"` | `"small"`, `"medium"`, `"large"` |

## Byline

| prop | default | what it is |
|---|---|---|
| `name` | `"?"` | |
| `src` | `null` | the avatar's picture |
| `href` | `null` | the person's page; with none the name is a `<span>` and not an empty link |
| `at` | `0` | epoch seconds |
| `size` | `"small"` | the avatar's size |

## Timestamp

| prop | default | what it is |
|---|---|---|
| `at` | `0` | epoch seconds |
| `show` | `"date"` | `"date"` or `"moment"` — the whole stamp is in `datetime` and `title` either way |

**It never asks what time it is now**, which is a hydration rule and not a style: a server rendering
*"4 minutes ago"* and a page adopting it a second later would disagree about the text, and a mismatch
is a fault by design. UTC, for the same reason.

## Photo

| prop | default | what it is |
|---|---|---|
| `src` | `null` | with none, nothing at all is rendered |
| `alt` | `""` | required to be text; `""` is the right answer for a decorative picture |

## Card

| prop | default | what it is |
|---|---|---|
| `title` | `null` | |
| `href` | `null` | with one, the title is a link |
| `level` | `"h2"` | `"h2"`, `"h3"`, `"h4"` — `h1` is refused: a card is never what the page is about |
| `children` | `[]` | |

A `<div>`. `ThreadCard` is an `<li>`, which is what `CardList` is a `<ul>` for.

## ThreadCard

| prop | default | what it is |
|---|---|---|
| `title` | `""` | |
| `href` | `null` | |
| `level` | `"h2"` | |
| `name` | `"?"` | who started it |
| `src` | `null` | their picture |
| `authorHref` | `null` | their page |
| `at` | `0` | epoch seconds |
| `excerpt` | `""` | with `""`, no paragraph is rendered |
| `tags` | `[]` | words, or records carrying a `label` |
| `tagHref` | `null` | a function of the label |
| `replies` | `0` | *1 reply*, *2 replies* |
| `children` | `[]` | anything else the row wants |

## CardList

| prop | default | what it is |
|---|---|---|
| `children` | `[]` | `ThreadCard`s, which are `<li>` |

## Post

| prop | default | what it is |
|---|---|---|
| `title` | `null` | |
| `level` | `"h1"` | `"h1"`, `"h2"`, `"h3"` — the post at the top of a thread is what the page is about |
| `name` | `"?"` | |
| `src` | `null` | |
| `authorHref` | `null` | |
| `at` | `0` | |
| `body` | `""` | **text, and rendered as text** — a post containing `<script>` contains eight characters |
| `photo` | `null` | |
| `alt` | `""` | |
| `tags` | `[]` | |
| `tagHref` | `null` | |
| `compact` | `false` | a reply: an `<li>` with less furniture |
| `children` | `[]` | |

## PostList

| prop | default | what it is |
|---|---|---|
| `children` | `[]` | compact `Post`s |

## Tag

| prop | default | what it is |
|---|---|---|
| `label` | `""` | |
| `href` | `null` | with none it is a `<span>` |
| `count` | `null` | rendered inside the link, so the whole pill is one target |
| `current` | `false` | `aria-current="true"` |
| `onChoose` | `null` | called with the label on a plain left click, which is then prevented |

## TagList

| prop | default | what it is |
|---|---|---|
| `tags` | `[]` | words, or records carrying a `label` and optionally a `count` |
| `href` | `null` | a function of the label |
| `current` | `null` | the label being filtered by |
| `onChoose` | `null` | |

An empty list renders **nothing at all**, rather than a `<ul>` announced as a list of nothing.

## Pagination

| prop | default | what it is |
|---|---|---|
| `page` | `1` | |
| `size` | `20` | refused at `0` rather than divided by |
| `total` | `0` | how many rows there are; `0` is one page |
| `href` | `null` | a function of the page number |
| `onChoose` | `null` | called with the page number |
| `unit` | `"items"` | the word after the total |

A step with nowhere to go is a `<span>` and not a disabled link — **there is no such thing as a
disabled anchor.**

## Segmented

| prop | default | what it is |
|---|---|---|
| `options` | `[]` | words, or records carrying a `value` and optionally a `label` |
| `value` | `null` | the one in force |
| `href` | `null` | a function of the value |
| `onChoose` | `null` | called with the value |
| `label` | `null` | with one, the group is a `<nav aria-label>`; with none it is not a landmark |

**With `href`, each choice is an anchor. With only `onChoose` and no `href`, each choice is a
`<button type="button">` instead** — the shape for a choice with no address, such as a theme kept
in a cookie.

## SortControls

`Segmented` with `sort` in place of `value` and `label` defaulting to `"Sort"`.

## EmptyState

| prop | default | what it is |
|---|---|---|
| `title` | `"Nothing here"` | |
| `detail` | `null` | |
| `children` | `[]` | what to do about it |

`role="status"` — polite. `Problem` is the one that interrupts.

## Problem

An [RFC 9457](https://www.rfc-editor.org/rfc/rfc9457) problem document, rendered for a person.

| prop | default | what it is |
|---|---|---|
| `problem` | `null` | the whole document: `type`, `title`, `status`, `detail`, `instance`, `errors` |
| `title` | `null` | overrides the document's |
| `detail` | `null` | overrides the document's; this is the sentence |
| `status` | `null` | overrides the document's |
| `errors` | `[]` | overrides the document's `errors` or `mismatch` |
| `reason` | `null` | a function turning one row into a sentence |

`type` and `instance` are shown to nobody: they are for a machine and for a log. With nothing to say,
**nothing is rendered** — which is what lets a page write `<Problem detail={note}/>` unconditionally.

The default `reason` — exported as `problemReason` — reads a row's own `detail`, then
`{ path | pointer | name, wanted, got }`, and says *"title is missing"* for a `got` of `"nothing"`.

## Live

| prop | default | what it is |
|---|---|---|
| `live` | `"polite"` | `"polite"` or `"assertive"` |
| `atomic` | `false` | |
| `children` | `[]` | |

**Rendered even when it is holding nothing**, which is the whole point: a screen reader watches
regions it already knows about, so a region created at the same moment as its text announces nothing.

## Toast

| prop | default | what it is |
|---|---|---|
| `messages` | `[]` | records carrying an `id` and a `text`, and optionally a `tone` |
| `live` | `"polite"` | |
| `onDismiss` | `null` | called with the message's id; with none, no button is rendered |
| `dismissLabel` | `"Dismiss"` | |

`tone` is `"info"`, `"good"` or `"danger"`. The `id` is what keys the row, so an arriving message
inserts one element.

## Form

| prop | default | what it is |
|---|---|---|
| `action` | `""` | |
| `method` | `"post"` | `"get"` or `"post"` |
| `enctype` | `null` | `"multipart/form-data"` for a form carrying a file |
| `csrf` | `null` | the token, written as a hidden field |
| `csrfName` | `"_csrf"` | |
| `onSubmit` | `null` | with none, the browser posts the form, which is the fallback |
| `label` | `null` | `aria-label`, for a page with more than one form on it |
| `children` | `[]` | |

**A `get` form carrying a `csrf` is refused**: a double-submit token is about a request that changes
something, and putting one on a search box would put it in the address bar of every search anybody
sent to anybody else.

**Three classes give a form a different shape**, and they are the library's own — hand one to
`class`, which is appended and never substituted.

| `class` | what it is for |
|---|---|
| `card` | the form is the thing on the page: a raised panel, its own border and its own padding |
| `m-doing` | one button and no fields — signing out, deleting a post — laid out inline |
| `m-search` | a search box in a header: one line, a pill on a sunken ground, and the field's label kept for a screen reader instead of printed over the box |

`m-search` is the one that reaches into `Field`'s own layout, and it is why a header's search box
does not need a `search` prop on `Field`.

## Field

| prop | default | what it is |
|---|---|---|
| `name` | `""` | |
| `label` | `null` | with none, the name |
| `kind` | `"text"` | the input's `type`; `"file"` is refused and names `FileInput` |
| `value` | `null` | **`null` leaves the attribute off**, which is what makes the field uncontrolled |
| `error` | `null` | rendered under the control, `aria-describedby` and `aria-invalid` wired to it |
| `hint` | `null` | rendered under the error |
| `required` | `false` | |
| `placeholder` | `null` | |
| `autocomplete` | `null` | |
| `id` | `null` | with none, `"f-" + name` |
| `onInput` | `null` | |

**A `required` field is marked with a `*` after its label**, drawn by the stylesheet from the
`required` attribute itself rather than from a second prop — so the mark and the browser's own
refusal to submit cannot come apart.

**A control is drawn as a well and comes up to the raised colour under the caret**, which is what
makes the field being filled in the lightest thing on the surface.

## TextArea

| prop | default | what it is |
|---|---|---|
| `name` | `""` | |
| `label` | `null` | |
| `value` | `""` | the **default** value — a textarea's text is what it started as |
| `rows` | `5` | |
| `error`, `hint`, `required`, `placeholder`, `id`, `onInput` | | as `Field` |

**A textarea is set in the reading face**, because what goes into it is a person's writing and
`Post` is about to publish it in that face.

## FileInput

| prop | default | what it is |
|---|---|---|
| `name` | `""` | |
| `label` | `null` | |
| `accept` | `null` | the `accept` attribute, and where the hint comes from |
| `maxSize` | `null` | bytes; `5242880` reads *"up to 5 MB"* |
| `hint` | `null` | with none, built from `accept` and `maxSize` |
| `error`, `required`, `id`, `onInput` | | as `Field` |

**The hint is built rather than written out again**, so the sentence a person reads and the `accept`
a browser enforces cannot disagree.

## Button

| prop | default | what it is |
|---|---|---|
| `kind` | `"button"` | `"button"`, `"submit"`, `"reset"` |
| `variant` | `"primary"` | `"primary"`, `"quiet"`, `"danger"` |
| `disabled` | `false` | |
| `onClick` | `null` | |
| `label` | `null` | `aria-label`, for a button whose content is an icon |
| `children` | `[]` | |

**`kind` defaults to `"button"` and not to `"submit"`, which is the opposite of HTML's default and is
deliberate**: a `<button>` inside a form with no `type` submits it.

## Actions

| prop | default | what it is |
|---|---|---|
| `children` | `[]` | the row a form's buttons stand in |

---

## The words a prop may be

Each of these is exported, so an application rendering its own control over the same set does not
write the strings out again.

| | |
|---|---|
| `Themes` | `light dark` |
| `Sizes` | `small medium large` |
| `Shows` | `date moment` |
| `CardLevels` | `h2 h3 h4` |
| `PostLevels` | `h1 h2 h3` |
| `LiveManners` | `polite assertive` |
| `Tones` | `info good danger` |
| `FormMethods` | `get post` |
| `ButtonKinds` | `button submit reset` |
| `ButtonVariants` | `primary quiet danger` |
