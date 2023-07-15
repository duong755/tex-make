\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{custom}

\LoadClass[oneside]{book}

\RequirePackage{import}
\RequirePackage[subpreambles=true]{standalone}

\RequirePackage{fancyhdr}
\RequirePackage{xcolor}
\RequirePackage{titlesec}
\RequirePackage{chngcntr}
\RequirePackage{subcaption}
\RequirePackage{booktabs}

\renewcommand{\familydefault}{\sfdefault}
\setcounter{chapter}{-1}

\pagestyle{fancy}
\setlength{\headheight}{16pt}
\lhead{}
\rhead{\leftmark}
\lfoot{}
\cfoot{\thepage}
\rfoot{}

\titleformat{\chapter}[display]{\flushright\bf\huge\color{red}}{\chaptertitlename\ \thechapter}{10pt}{}
\titleformat{\section}{\bf\Large\color{red}}{\thesection}{10pt}{}
\titleformat{\subsection}{\bf\large\color{red}}{\thesubsection}{10pt}{}
\titleformat{\subsubsection}{\bf\normalsize\color{red}}{\thesubsubsection}{10pt}{}

%%%%%%%%%%%%%%%%%%%%
\newtheoremstyle{theorem}%
{3pt}% Space above
{3pt}% Space below 
{\itshape\color{blue}}% Body font
{}% Indent amount
{\bfseries\color{blue}}% Theorem head font
{.}% Punctuation after theorem head
{.5em}% Space after theorem head 
{}% Theorem head spec (can be left empty, meaning ‘normal’)

\newtheoremstyle{proposition}
{3pt}
{3pt}
{\itshape\/}
{}
{\bfseries\color{blue}}
{.}
{.5em}
{}

\newtheoremstyle{lemma}
{3pt}
{3pt}
{\itshape\/}
{}
{\bfseries\color{blue}}
{.}
{.5em}
{}

\newtheorem{example}
{3pt}
{3pt}
{}
{}
{\bfseries\color{red}}
{.}
{.5em}
{}

