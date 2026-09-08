# IMT School for Advanced Studies Lucca Beamer Template

A Beamer theme following the IMT School for Advanced Studies Lucca visual identity, with an optional slot for a co-institution logo on the title slide.

## Layout

| File | Role |
|---|---|
| `main.tex` | presentation starting point |
| `beamerthemeimtlucca.sty` | theme file: colors, fonts, title page, frame titles, footer, section pages |
| `assets/` | logo directory |
| `Makefile` | auxiliar file for build, watch, lint, clean |

## Build

```sh
make          # list the targets
make pdf      # build main.pdf
make watch    # rebuild on every save
```

Auxiliary files go to `build/`; the finished PDF lands next to `main.tex`.
Run `make check-deps` to see whether your TeX installation has everything.
Compiling `main.tex` with pdfLaTeX in TeXstudio or Overleaf works too, with no
configuration: the `.sty` sits in the project root where LaTeX already looks.

## Using the theme

```latex
\documentclass[aspectratio=169,11pt]{beamer}
\usetheme{imtlucca}
```

Theme options:

| Option | Default | Effect |
|---|---|---|
| `sectionpages` | `true` | full-page divider before every `\section` |
| `footer` | `true` | footer on regular slides |
| `assetpath` | `assets/` | where the logo files live, trailing slash included |

Set `assetpath` to empty if you install the theme and its logos into a texmf
tree, so that bare file names are resolved by kpathsea instead.

## Logos

The title slide shows the IMT logo, plus an optional second logo to its right:

```latex
\imtcologo[13mm]{your_institution.png}   % add a co-institution logo
\imtlogo[12mm]{imt_lucca_horizontal.pdf} % change the primary logo
\imtlogo{}                               % no logos at all
```

File names are resolved against `assetpath`. The optional argument is the
rendered height. Regular slides carry no logos; the footer shows the speaker on
the left, the short title in the center, and the slide number on the right.

## Metadata

The optional arguments are what appear in the footer:

```latex
\title[Short title]{Presentation Title}
\author[Speaker]{Speaker Name \and Second Author}
\institute[IMT Lucca]{IMT School for Advanced Studies Lucca}
\date{Venue \\ \today}
```

## Colors and helpers

Colors: `IMTDarkBlue`, `IMTOrange`, `IMTAccentBlue`, `IMTBackground`,
`IMTBlack`, `IMTMutedText`, `IMTRule`.

Helpers: `\highlight{...}` for orange emphasis, `\bluehighlight{...}` for
secondary emphasis, and the `takeawaybox` environment for a boxed conclusion.

## Fonts

The theme uses Inter through the CTAN `inter` package, which works with
pdfLaTeX. If `inter` is not installed it falls back to Latin Modern Sans, so the
template always compiles.
