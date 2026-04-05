# lexnote

Personal LaTeX note template for `ctexrep` / `ctexart`.

## Install

```bash
./setup.sh
```

This copies `lexnote.sty` to your `TEXMFHOME` so it's available globally.

## Usage

```latex
\documentclass{ctexart}  % or ctexrep
\usepackage{lexnote}              % default: law style
% \usepackage[style=ml]{lexnote}  % ML style
```

## Styles

| Style | Fonts | Colors | Environments |
|-------|-------|--------|-------------|
| `law` (default) | Calibri + Kaiti SC | Teal | `statute`, `case`, `rul` |
| `ml` | Computer Modern + Songti SC | Purple-blue | `thm`, `lem`, `defn`, `rem` |

Both styles include: `notebox`, `defbox`, `\keyword{}`, `\todo{}`.

## Requirements

- TeX Live / MacTeX with XeLaTeX
- CTeX bundle
