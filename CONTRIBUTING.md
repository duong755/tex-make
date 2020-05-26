# Contributing

## How to contribute

### Help reporting a bug

Before submitting a bug, make sure that you have googled about your problems, and search for it in our [GitHub Issues](https://github.com/git-tex/tex-make/issues).

Since this project just makes use of others tools: `Makefile`, `ChkTeX`, `latexindent.pl`... so maybe the problems come from them (no offense). Or probably I have configured them wrong.

Please use the [GitHub Issues](https://github.com/git-tex/tex-make/issues) to report bugs.

### Make some changes

If you want to change something, have new features, please create an issue first. In that issue, we can discuss to reach an agreement or cancel it.

Anyway, no matter what you are doing - fixing a bug, creating a new feature... please create an issue first.

### Submitting Pull Request

Before submitting your pull request, make sure that the following has been done:

-   Your code follow our [Code of Conduct](./CODE_OF_CONDUCT.md)
-   Test on our sample document.
-   Run the linter.
-   Format the source code.

### Contribution Prerequisites

-   The latest version of `TeX Live`.
-   GNUmake.
-   Git and experience with it.

## Codebase structure

(The following structure is created by [`tree`](<https://wikipedia.org/wiki/Tree_(command)>))

```
.
├── chapter0
│   └── chapter0.tex
├── chapter1
│   ├── chapter1.tex
│   ├── section1
│   │   └── section1.tex
│   ├── section2
│   │   └── section2.tex
│   └── section3
│       └── section3.tex
├── .chktexrc
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── custom.cls
├── .editorconfig
├── .gitignore
├── indentconfig.yaml
├── LICENSE
├── main.tex
├── Makefile
└── README.md

```

At the root, we have the "entry file" `main.tex`, `custom.cls`, `indentconfig.yaml`, `Makefile`, `.chktexrc`, `.editorconfig` - which are very important while using the template.

The content of the sample document are splitted into chapters, sections and put in the corresponding directories.

## The Ideas Behind

### `\usepackage[subpreambles=true]{standalone}` is awesome

It is very common to break large file into smaller ones. Before created this project, I had to find out how to create and work with a `multiple files project with TeX`.

I obtained some solutions for that, which include:

-   `\input{}`
-   `\include{}`
-   [Package `subfiles`](https://ctan.org/pkg/subfiles)
-   [Package `standalone`](https://ctan.org/pkg/standalone)

I have chosen package `standalone` for this project. But first, let me summarize the advantages and disadvantages of these solutions (from **StackOverflow** and **Overleaf**):

-   `\input{filename}`: this is equivalent to the content the file.
-   `\include{filename}`: almost identical to `\input{filename}`, but it does a `\clearpage` before and after the command.

`\input{}` can be nested, but `\include{}` cannot.

Both `\input{}` and `\include{}` are not usable for files that has preamble or `\begin{document}`. So you have to provide all the packages you need in the root file.

-   Package `subfiles` allows us to use `\begin{document}` in the subfiles but the subfiles can not have their own preambles. With this, subfiles can be nested.
-   Package `standalone` provide `\import{path}{filename}` and `\subimport{path}{filename}`. Beside allowing `\begin{document}` in the subfiles, this package allows the subfiles to have their own preambles. `standalone` also can be nested, but it looks more naturally, in my opinion.

So that's why I have chosen package `standalone`. It is the most flexible. With this package, I can build PDF for just the part that I work with, not the entire document, and I can freely load the packages that my part needs. But of course, this solution has caveat - _performance_. But for now I don't mind it. Maybe, the project will serve both solution: `\input` and `standlone`, `\input` for the whole document, `standlone` for parts of it.

### Chapters, Sections and so on

As you have seen the codebase structure, I put the content of the chapters in `chapter{number}` directories.
And each directories has its own "entry file", which might import smaller subfiles.

At first, I wanted the name of the entry file will always be `main.tex`, and it is ok, and the recipe in `Makefile` can be simpler. But I don't want get confused between various of entry files so I decided that the entry file and its directory will have the same name.
