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

I strongly recommend users to install `TeX Live` via `.exe` (for Windows), `.tar.gz` (for others) instead of any package manager.

For Windows users, `Git` must be installed with `Git bash`, since all scripts used in `Makefile` are not compatible with Windows command prompt nor Powershell.

### Linux, Mac, UNIX

-   Nothing more (since GNUmake is available)

### Windows

-   GNUmake (with MinGW)

## How to use

:warning: Don't delete `.editorconfig` or remove the `[Makefile]` part from it - your `Makefile` will might not work anymore, since `Makefile` uses tabs instead of spaces for indentation.

In your shell (terminal), use the command: `make <target>`.

The `Makefile` file, in this repository, provides the following targets:

-   `all`:
    -   This is the default target if no target is provided.
    -   In this case, `make all` or `make` compile and build the whole document.
-   `clean`:
    -   In this case, `make clean` removes untracked files and files that ignored by `Git`.
-   `cleanaux`:
    -   `make cleanaux` removes auxiliary files that generated while compiling.
-   `cleanoutput`:
    -   `make cleanoutput` remove `pdf` and `dvi` files.
-   `chktex`:
    -   This finds possible errors in your TeX source code, forces you to write your code in a consistent style. The configuration for this is contained in `.chktexrc`.
-   `formatall`:
    -   This formats your source code by using `latexindent.pl`, which is configurable with `indentconfig.yaml` file. Just like `chktex`, you should format your code to ensure consistency.
-   `updatecls`:
    -   The template repository provides its own `.cls` file. In order to use this `.cls` anywhere, this target copies it to an appropriate place.
-   `%` (pattern rule):
    -   For those who are not so familiar with `Makefile`: you might consider `%` as a wildcard for any string. More specific, if you run `make <target>`, where `<target>` doesn't match `all`, `clean`, `formatall`,... it will use this pattern rule `%`.
    -   In this case, the pattern rule is used to compile subfiles of the document. I have splitted the whole document into chapters, chapters to smaller sections and put them in the corresponding directories.
    -   This rule depends **heavily** on how I organize the project structure and the packages I use (`standalone`, `import`). See [CONTRIBUTING.md](./CONTRIBUTING.md) to understand the idea.
    -   For examples:
    -   To compile `chapter0`, run:
    ```shell
    make chapter0 -B
    ```
    -   `make` won't run if the target name is identical to any directory path or file name so `-B` is required.
    -   To compile `section2` of `chapter1`, run:
    ```shell
    make chapter1/section2 -B
    ```

## Customize

As I tested, all these configurations are good enough to work with.

But if you want to change something to fit your needs, you can tweak the following files:

-   `custom.cls`
-   `indentconfig.yaml`
-   `.chktexrc`
-   `Makefile`:
    -   Create your own rules.
    -   Remove rules.
    -   Change the recipes.

And of course, you can create your own document.
