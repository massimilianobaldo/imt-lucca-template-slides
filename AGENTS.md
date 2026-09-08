# AGENTS.md

Guidance for coding agents and new contributors working on this repository.

## What this repo is

A Beamer theme following the IMT School for Advanced Studies Lucca visual
identity, published so other people can clone it and give talks with it. It is
a **template**, not a presentation: every change is judged by whether it helps
someone who has just cloned the repo, not only by whether `main.tex` still
builds.

## Layout

| File | Role |
|---|---|
| `main.tex` | the example presentation; the only file a user of the template edits |
| `beamerthemeimtlucca.sty` | the theme: colors, fonts, title page, frame titles, footer, section pages, custom boxes |
| `assets/` | third-party logo files (see Logos below) |
| `Makefile` | build, watch, lint, format, clean |
| `build/` | all auxiliary output, gitignored |

## Build and verify

```sh
make            # list targets
make pdf        # build ./main.pdf (aux files in build/)
make ci         # strict build, output stays at build/main.pdf
make lint       # chktex; non-zero exit on any warning
make check-deps # report missing tools
make distclean  # remove build/ and the root PDF
```

Requires `latexmk` and `pdflatex`; `chktex` and `latexindent` are optional.
The theme also needs `tcolorbox`, `etoolbox`, `kvoptions` and `tikz`, all in
TeX Live and on Overleaf.

Before claiming a visual change works, **render it and look at it**:

```sh
pdftotext -layout main.pdf - | grep -n "Frame title"   # find the page
pdftocairo -png -r 150 -f 9 -l 9 main.pdf /tmp/out     # render page 9
```

Page numbers shift whenever a frame is added, so locate the slide instead of
assuming its number.

## Where code goes

The split is the whole point of the repo, so keep it clean:

- Presentation layout, styling, and any new box or environment go in the `.sty`.
- `main.tex` holds only metadata, content packages, and frames. It stays short
  enough that a newcomer reads it top to bottom.
- A new user-facing feature is done when it is implemented in the `.sty`,
  demonstrated by a frame in `main.tex`, and documented in the README under
  `## Features`.

## Public API

Users' own decks call these. Renaming or changing their signatures is a breaking
change; do not do it casually.

- Theme options: `sectionpages`, `footer`, `assetpath`
- Logos: `\imtlogo[<height>]{<file>}`, `\imtcologo[<height>]{<file>}`,
  `\IMTLogo`, `\IMTLogoVertical`
- Colors: `IMTDarkBlue`, `IMTOrange`, `IMTAccentBlue`, `IMTBackground`,
  `IMTBlack`, `IMTMutedText`, `IMTRule`
- Text helpers: `\highlight`, `\bluehighlight`, `takeawaybox`
- Boxes: `leanbox` (kind, name), `recap` with `\recapitem` (label, text)

Internal macros use the `\imt@` prefix and are fair game.

## Gotchas that have already caused bugs

**The title page needs two or more compilation passes.** It draws with tikz
`remember picture, overlay`, so a single `pdflatex` run silently misplaces every
node: logos disappear and the title block lands in the wrong place, with no
error. Always build through `make` or `latexmk`. A one-shot `pdflatex` is only
safe for content that has no page-anchored overlay.

**The `beamertheme` filename prefix is mandatory.** `\usetheme{imtlucca}`
expands to `\usepackage{beamerthemeimtlucca}`. The file cannot be renamed, and
it cannot move into a subdirectory, because `\usetheme` accepts no path prefix.
Keeping it in the repo root is also what makes the template work on Overleaf
with no configuration.

**`tcolorbox` is loaded with no package options,** deliberately. Add libraries
with `\tcbuselibrary{...}`. Any `\usepackage[...]{tcolorbox}` in a document
using this theme raises an option clash.

**Theme logos resolve as `\imt@assetpath` plus a bare file name,** not through
`\graphicspath`. That way a clone finds them in `assets/` and a texmf install
finds them via kpathsea. The `\graphicspath` in `main.tex` is for the user's own
figures; do not route theme assets through it.

**`make lint` fails on any chktex warning.** chktex warning 1, "command
terminated with space", fires on any parameterless macro at the end of a line
(`\titlepage`, for example). Fix it with a trailing `%`, not by suppressing the
check.

**`make ci` does not copy the PDF to the repo root.** Unlike `make pdf` it runs
latexmk without the `success_cmd` hook, so its output is `build/main.pdf`.

**`.gitignore` ignores `/*.pdf`, root only.** This is intentional: `assets/`
contains logo PDFs that must stay tracked. Never broaden it to `*.pdf`.

## Logos and trademarks

Everything in `assets/` is third-party and **not** covered by this repo's
license. The README's "Logos and trademarks" section records the terms for each
mark, with sources. Rules:

- Do not add, swap, or resize a logo without checking that holder's terms, and
  update the README notice in the same change.
- Do not recolor, crop, or otherwise alter a mark. When artwork clashes with the
  design (the Lean mark is thin black line art that vanishes on a dark bar), put
  it on a field that suits it instead of editing the artwork.
- `assets/udine_seal_wikipedia.png` is still tracked but unused. It came from a
  non-free Wikipedia file whose description page says other uses "may be
  copyright infringement". Do not reference it, and do not reintroduce it.
- Institutional marks (IMT, Udine) require prior authorization for third-party
  use, which is exactly what publishing this repo enables. Treat that as an open
  question, not a settled one.

## Conventions

- Match the surrounding style: two-space indent in `.tex`, `% ---` separator
  banners above each section of the `.sty`.
- Comments explain non-obvious decisions and the reason behind a magic number.
  Do not restate what the code does.
- Do not add packages, error handling, or abstractions that were not asked for.
  Every new dependency is one more thing that can be missing on someone's TeX
  installation.
- Commit subjects are imperative with a type prefix, as in the existing history:
  `feature:`, `fix:`, `chore:`. No emoji, no attribution trailers.
