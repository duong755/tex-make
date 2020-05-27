# ![](https://latex.codecogs.com/gif.latex?%5CTeX) make

## Thanks

I would like to thank to creators, maintainers of the open source projects: `TeX Live`, `Git`, `latexindent.pl`, `ChkTeX`, `GNU Makefile`. Without them, this project won't exist.

## Introduction

TeX Make is a toolset for creating, building document:

-   [`Git`](https://git-scm.com)
-   [`TeX Live`](https://tug.org/texlive)
    -   [`latexindent.pl`](https://github.com/cmhughes/latexindent.pl)
    -   [`ChkTeX`](https://ctan.org/pkg/chktex)
-   [`Makefile`](https://www.gnu.org/software/make/manual/make.html)

This repo provides a sample document that leverage all above tools:

-   `Git`: version control, tracking changes, remove auxiliary files, collaboration...
-   `TeX Live`: compiling TeX source code.
-   `latexindent.pl`: formatting TeX source code.
-   `ChkTeX`: linting TeX source code.
-   `Makefile`: provide recipe for compiling and other ultilities.

If you would like to contribute or find out the essential, the idea of this project, please see [CONTRIBUTING.md](./CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md).

## Prerequisites

-   [`TeX Live`](http://tug.org/texlive/acquire-netinstall.html) (`ChkTeX` and `latexindent.pl` are available as part of `TeX Live`)
-   [`Git`](https://git-scm.com)

I strongly recommend users to install `TeX Live` via `.exe` (for Windows), `.tar.gz` (for other platforms) instead of any package manager.

For Windows users, `Git` must be installed with `Git bash`, since all scripts used in `Makefile` are not compatible with Windows command prompt nor Powershell.

### Linux, Mac, UNIX

-   Nothing more (since GNUmake is available)

### Windows

-   GNUmake (with MinGW)

## How to use

:warning: Don't delete `.editorconfig` or remove the `[Makefile]` part from it - your `Makefile` will might not work anymore, since `Makefile` uses tabs instead of spaces for indentation.

1. Install `TeX Live`, `Git`, `Makefile`.
2. Downloads or clone this repository.
3. Run `make updatecls` to make the `.cls` file available.
4. At the project root, run `make` to compile the whole document.
5. Run `make <directory-name> -B` to compile part of the document which put in `<directory-name>`.
6. Run `make formatall` to format `.tex`, `.cls`, `.sty` files. You can tweak the format configuration in `indentconfig.yaml`
7. Run `make chktex` to lint `.tex` files. Lint configuration is put in `.chktexrc`.
8. Run `make cleanaux` to remove auxiliary files, `make cleanoutput` to remove `.pdf`, `.dvi` files.
9. Customize (next).

## Customize

As I have tested, all these configurations are good enough to work with.

But if you want to change something to fit your needs, you can tweak the following files:

-   `custom.cls`
-   `indentconfig.yaml`
-   `.chktexrc`
-   `Makefile`:
    -   Create your own rules.
    -   Remove rules.
    -   Change the recipes.

And of course, you can create your own document.
