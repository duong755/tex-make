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
-   GNUmake and PowerShell.
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
├── .latexmkrc
├── LICENSE
├── main.tex
├── Makefile
├── make.ps1
└── README.md
```

At the root, we have the "entry file" `main.tex`, `custom.cls`, `indentconfig.yaml`, `Makefile`, `.chktexrc`, `.editorconfig` - which are very important while using the template.

I call `main.tex` the _root file_.

The content of the sample document are splitted into chapters, sections and put in the corresponding directories.
