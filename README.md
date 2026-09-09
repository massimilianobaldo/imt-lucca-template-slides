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
\documentclass[aspectratio=169,11pt,t]{beamer}
\usetheme{imtlucca}
```

Beamer centers frame content vertically by default, which leaves a short slide floating in the middle with a dead band under the title.
Using the option `t` top-aligns it so content starts just below the title rule.
Frames that should be centered pass it per frame, as in `\begin{frame}[c]{Figure}`.

Theme options:

| Option | Default | Effect |
|---|---|---|
| `sectionpages` | `true` | full-page divider before every `\section` |
| `footer` | `true` | footer on regular slides |
| `assetpath` | `assets/` | where the logo files live, trailing slash included |

Set `assetpath` to empty if you install the theme and its logos into a texmf
tree, so that bare file names are resolved by kpathsea instead.

## Logos

The title slide shows the IMT logo, plus an optional second logo for a
co-institution:

```latex
\imtcologo[11mm]{your_institution.png}   % add a co-institution logo
\imtlogo[11mm]{imt_lucca_horizontal.pdf} % change the primary logo
\imtlogo{}                               % no primary logo
```

Placement follows from how many logos there are. A single logo sits at the top
right. With a co-institution logo the two marks take a corner each, the IMT one
top left and the second top right, inset by the same margin. Two logos read as a
balanced pair when both are horizontal lockups at a matched height, which is
what `main.tex` does.

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

## Features

### Recap grid

`recap` lays out labelled panels two per row for a one-slide summary of the
talk. Each `\recapitem` takes a label and its text:

```latex
\begin{frame}{In summary}
  \vfill
  \begin{recap}
    \recapitem{Problem}{State the gap your work addresses.}
    \recapitem{Methodology}{Name the approach, not its details.}
    \recapitem{Results}{Give the single number that matters.}
    \recapitem{Conclusions and future work}{Say what comes next.}
  \end{recap}
  \vfill
\end{frame}
```

All panels get the same width and height, so the grid stays aligned however
unevenly the text falls. The panel count is not fixed at four: three give a full
row plus one panel, six give three rows. Panels are sized to their content
rather than to the slide, so `\vfill` on both sides centers the grid in the
frame body.

Keep each panel to one sentence. Four panels leave roughly two lines each, and a
bullet list inside a panel (which does work) shrinks into something nobody reads
from the back of the room.

### Results formalized in Lean

`leanbox` marks a theorem, lemma, or proposition that has been proved and
implemented in the [Lean](https://lean-lang.org/) proof assistant. The Lean logo
appears at the right end of the title bar. The first argument is the kind of
result, the second its name; leave the name empty to drop the parentheses.

```latex
\begin{leanbox}{Theorem}{Soundness}
  If $\Gamma \vdash e : \tau$ then $e$ evaluates to a value of type $\tau$.
\end{leanbox}

\begin{leanbox}{Lemma}{}
  Every well-typed term is either a value or takes a step.
\end{leanbox}
```

The box is built with `tcolorbox`, which the theme loads without package
options. Add libraries with `\tcbuselibrary{...}`; a second
`\usepackage[...]{tcolorbox}` would raise an option clash.

The logo in `assets/lean_logo.png` is the official artwork, used unmodified. It
is thin black line art, so the theme places it on a white field inside the dark
title bar rather than recoloring it, and the ™ symbol is left in place. See
[Logos and trademarks](#logos-and-trademarks) before publishing or presenting.

## Fonts

The theme uses Inter through the CTAN `inter` package, which works with
pdfLaTeX. If `inter` is not installed it falls back to Latin Modern Sans, so the
template always compiles.

## Logos and trademarks

**None of the logo files in `assets/` are covered by this repository's license.**
They belong to their respective owners and are bundled only so that the template
renders as intended. Each carries its own conditions, summarized below as of
8 September 2026. This summary is not legal advice: check the linked sources
before you present with these slides or redistribute a fork.

### IMT School for Advanced Studies Lucca

`imt_lucca_horizontal.pdf`, `imt_lucca_vertical.pdf`

"The use of the name and logo of the IMT School by third parties is only
permitted with its prior authorisation." Authorization is requested from the
Communication Office at `commev@imtlucca.it`, a graphic draft must be submitted
to the same office for approval, and use must follow the Visual Identity Manual.
Source: [Visual identity, logo and patronage](https://www.imtlucca.it/en/visual-identity-logo-and-patronage).

### University of Udine

`logo-uniud.jpg`

The logo may be used by internal university structures and by external parties
that have been granted patronage (`concessione del patrocinio`). Use must follow
the university's Manuale d'immagine, and requests go to `urp@uniud.it`. Source:
[Uso del logo di Ateneo](https://www.uniud.it/it/servizi/servizi-comunicazione/urp/uso-logo).

`logo-uniud.jpg` is the official lockup, seal plus wordmark plus payoff,
obtained from the university's own website. An earlier version of this template
used a seal taken from the English Wikipedia file `Uniudlogo.png`, which is
hosted there as a **non-free logo under a fair-use rationale**: its description
page states that "any other uses of this image, on Wikipedia or elsewhere, may
be copyright infringement." Do not reintroduce that file. Source:
[File:Uniudlogo.png](https://en.wikipedia.org/wiki/File:Uniudlogo.png).

### Lean

`lean_logo.png`

The Lean logo is a registered trademark of the Lean Focused Research
Organization in the United States and Europe. The bundled file is the official
artwork from [lean-lang.org/logos](https://lean-lang.org/logos/), used
unmodified. The
[trademark policy](https://lean-lang.org/trademark-policy/) permits accurate
statements without prior approval, such as saying that a result is proved in the
Lean programming language, which is what `leanbox` asserts. It requires that the
™ symbol is never removed or obscured, and it requires explicit permission for
derived logos, for use of the mark inside another trademark, and for merchandise
offered for sale. Redistributing the artwork inside a template repository is not
addressed either way by the policy.

### If you fork this template

Replace the institutional logos with your own, or obtain authorization from each
holder first. `\imtlogo{}` drops the primary logo and deleting the `\imtcologo`
line drops the second one, so the title slide works with no institutional
artwork at all.
