% lexnote.cls — Personal note class wrapping ctexart / ctexrep / ctexbook
% Usage: \documentclass{lexnote}               % ctexart + law (default)
%        \documentclass[style=ml]{lexnote}     % ctexart + ML
%        \documentclass[rep]{lexnote}          % ctexrep + law
%        \documentclass[book]{lexnote}         % ctexbook + law
%        \documentclass[book,style=ml]{lexnote}% ctexbook + ML

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{lexnote}[2026/04/05 Personal note class with colored section boxes]

% ── Options ─────────────────────────────────────────────────
\RequirePackage{kvoptions}
\RequirePackage{etoolbox}
\SetupKeyvalOptions{family=lexnote,prefix=lexnote@}
\DeclareStringOption[law]{style}
\DeclareBoolOption[false]{rep}
\DeclareBoolOption[false]{book}
\ProcessKeyvalOptions*

% Clear class options so they don't leak to ctex/zhnum (LaTeX2e + LaTeX3)
\let\@classoptionslist\@empty
\@ifundefined{@raw@classoptionslist}{}{%
  \let\@raw@classoptionslist\@empty
}

% ── Load Base Class ─────────────────────────────────────────
\newif\iflexnote@haschapter
\iflexnote@book
  \LoadClass[scheme=plain]{ctexbook}
  \lexnote@haschaptertrue
\else\iflexnote@rep
  \LoadClass[scheme=plain]{ctexrep}
  \lexnote@haschaptertrue
\else
  \LoadClass[scheme=plain]{ctexart}
\fi\fi

% ── Page Layout ──────────────────────────────────────────────
\RequirePackage[
  a4paper,
  margin=1in,
]{geometry}

% ── Typography & Spacing ────────────────────────────────────
\RequirePackage{parskip}
\RequirePackage{microtype}
\RequirePackage{fontspec}
\ifdefstring{\lexnote@style}{ml}{%
  \setCJKmainfont{Songti SC}
}{%
  \setmainfont{Calibri}
  \setCJKmainfont{Kaiti SC}
}

% ── Colors ──────────────────────────────────────────────────
\RequirePackage{xcolor}
\ifdefstring{\lexnote@style}{ml}{%
  \definecolor{accent}{HTML}{4A3DCC}      % purple-blue
  \definecolor{lightbg}{HTML}{F5F3FF}     % very light purple
  \definecolor{chapterbg}{HTML}{F0E8FF}   % light purple
  \definecolor{sectionbg}{HTML}{E8E0FF}   % soft purple
  \definecolor{subsectionbg}{HTML}{D6E4FF} % soft blue
}{%
  \definecolor{accent}{HTML}{2E6B8A}      % teal
  \definecolor{lightbg}{HTML}{F0F4F7}     % light background
  \definecolor{chapterbg}{HTML}{D5F5E3}   % light green
  \definecolor{sectionbg}{HTML}{D6EAF8}   % light blue
  \definecolor{subsectionbg}{HTML}{FADBD8} % light red/orange
}

% ── Math ────────────────────────────────────────────────────
\RequirePackage{amsmath,amssymb,mathtools,amsthm}

% ── Headers & Footers ──────────────────────────────────────
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\small\textcolor{gray}{\@title}}
\fancyhead[R]{\small\textcolor{gray}{\@date}}
\fancyfoot[C]{\small\textcolor{gray}{\thepage}}
\renewcommand{\headrulewidth}{0.4pt}

% ── Hyperlinks ──────────────────────────────────────────────
\RequirePackage{hyperref}
\hypersetup{
  colorlinks=true,
  linkcolor=accent,
  urlcolor=accent,
  citecolor=accent,
}

% ── Table of Contents ───────────────────────────────────────
\RequirePackage{tocloft}
\iflexnote@haschapter
  \setlength{\cftchapindent}{0em}
  \setlength{\cftchapnumwidth}{2em}
\fi
\setlength{\cftsecindent}{1.5em}
\setlength{\cftsubsecindent}{3em}
\setlength{\cftsubsubsecindent}{4.5em}
\setlength{\cftsecnumwidth}{1.5em}
\setlength{\cftsubsecnumwidth}{1.5em}
\renewcommand{\cftsecfont}{\scshape}

% ── Section Numbering ───────────────────────────────────────
\iflexnote@haschapter
  \ctexset{chapter/name = {}}
\fi
\ifdefstring{\lexnote@style}{ml}{%
  % ML style: plain 1, 2, 3 numbering
}{%
  % Law style: A, B, C / a, b, c numbering
  \renewcommand{\thesection}{\Alph{section}}
  \renewcommand{\thesubsection}{\alph{subsection}}
}

% ── Section Styling ─────────────────────────────────────────
\RequirePackage{titlesec}

\ifdefstring{\lexnote@style}{ml}{%
  % ML style: plain headings, no colored boxes
  \iflexnote@haschapter
    \titleformat{\chapter}[hang]
      {\fontsize{18pt}{21.6pt}\selectfont\bfseries}{\thechapter}{1em}{}
  \fi
  \titleformat{\section}
    {\fontsize{14pt}{16.8pt}\selectfont\bfseries}{\thesection}{1em}{}
  \titleformat{\subsection}
    {\fontsize{10pt}{12pt}\selectfont\bfseries}{\thesubsection}{1em}{}
}{%
  % Law style: colored boxes
  \iflexnote@haschapter
    \newcommand{\chapterbox}[1]{%
      \parbox{\dimexpr\textwidth-2\fboxsep}{\thechapter\hspace{1em}#1}}
    \titleformat{\chapter}[hang]
      {\fontsize{18pt}{21.6pt}\selectfont\bfseries}{}{0pt}{\chapterbox}
  \fi
  \newcommand{\sectionbox}[1]{%
    \colorbox{sectionbg}{\parbox{\dimexpr\textwidth-2\fboxsep}{\thesection\hspace{1em}\textsc{#1}}}}
  \newcommand{\subsectionbox}[1]{%
    \colorbox{subsectionbg}{\parbox{\dimexpr\textwidth-2\fboxsep}{\thesubsection\hspace{1em}#1}}}
  \titleformat{\section}
    {\fontsize{14pt}{16.8pt}\selectfont\bfseries}{}{0pt}{\sectionbox}
  \titleformat{\subsection}
    {\fontsize{10pt}{12pt}\selectfont\bfseries}{}{0pt}{\subsectionbox}
}

% ── Boxes ───────────────────────────────────────────────────
\RequirePackage[most]{tcolorbox}

% Note box
\newtcolorbox{notebox}[1][Note]{%
  colback=lightbg,
  colframe=accent,
  fonttitle=\bfseries,
  title={#1},
  boxrule=0.5pt,
  arc=2pt,
}

% Definition box
\newtcolorbox{defbox}[1][Definition]{%
  colback=white,
  colframe=accent!60!black,
  fonttitle=\bfseries,
  title={#1},
  boxrule=0.5pt,
  arc=2pt,
  left=6pt, right=6pt,
}

% ── Custom Title Block ──────────────────────────────────────
\renewcommand{\maketitle}{%
  \begin{center}
    {\LARGE\bfseries\color{accent}\@title\par}
    \vskip 0.5em
    {\large\@author\quad\textcolor{gray}{|}\quad\@date\par}
  \end{center}
  \vskip 1em
  \hrule height 0.4pt
  \vskip 1em
}

% ── Shorthand Commands ──────────────────────────────────────
\newcommand{\keyword}[1]{\textbf{\textcolor{accent}{#1}}}
\newcommand{\todo}[1]{\textcolor{red}{\textbf{[TODO: #1]}}}

% ── Theorem-style Boxes ─────────────────────────────────────
\tcbuselibrary{theorems}

\ifdefstring{\lexnote@style}{ml}{%
  % ── ML style: Theorem / Lemma / Definition / Remark ──────
  \iflexnote@haschapter
    \newtcbtheorem[number within=chapter]{Theorem}{Theorem}{
      colback=accent!8,colframe=accent!70,fonttitle=\bfseries,left=6pt}{thm}
    \newtcbtheorem[number within=chapter]{Lemma}{Lemma}{
      colback=blue!6,colframe=blue!50,fonttitle=\bfseries,left=6pt}{lem}
    \newtcbtheorem[number within=chapter]{Definition}{Definition}{
      colback=accent!5,colframe=accent!40,fonttitle=\bfseries,left=6pt}{def}
    \newtcbtheorem[number within=chapter]{Remark}{Remark}{
      colback=gray!8,colframe=gray!40,fonttitle=\bfseries,left=6pt}{rem}
  \else
    \newtcbtheorem[number within=section]{Theorem}{Theorem}{
      colback=accent!8,colframe=accent!70,fonttitle=\bfseries,left=6pt}{thm}
    \newtcbtheorem[number within=section]{Lemma}{Lemma}{
      colback=blue!6,colframe=blue!50,fonttitle=\bfseries,left=6pt}{lem}
    \newtcbtheorem[number within=section]{Definition}{Definition}{
      colback=accent!5,colframe=accent!40,fonttitle=\bfseries,left=6pt}{def}
    \newtcbtheorem[number within=section]{Remark}{Remark}{
      colback=gray!8,colframe=gray!40,fonttitle=\bfseries,left=6pt}{rem}
  \fi
  \newenvironment{thm}[1][]{\begin{Theorem}{#1}{}}{\end{Theorem}}
  \newenvironment{lem}[1][]{\begin{Lemma}{#1}{}}{\end{Lemma}}
  \newenvironment{defn}[1][]{\begin{Definition}{#1}{}}{\end{Definition}}
  \newenvironment{rem}[1][]{\begin{Remark}{#1}{}}{\end{Remark}}
}{%
  % ── Law style: Statute / Case / Rule ─────────────────────
  \iflexnote@haschapter
    \newtcbtheorem[number within=chapter]{Statute}{Statute}{
      colback=black!20,colframe=black!60,fonttitle=\bfseries,left=6pt}{statute}
    \newtcbtheorem[number within=chapter]{Case}{Case}{
      colback=purple!10,colframe=purple!60,fonttitle=\bfseries,left=6pt}{case}
    \newtcbtheorem[number within=chapter]{Rule}{Rule}{
      colback=teal!15,colframe=teal!15,fonttitle=\bfseries,coltitle=black,left=6pt}{rul}
  \else
    \newtcbtheorem[number within=section]{Statute}{Statute}{
      colback=black!20,colframe=black!60,fonttitle=\bfseries,left=6pt}{statute}
    \newtcbtheorem[number within=section]{Case}{Case}{
      colback=purple!10,colframe=purple!60,fonttitle=\bfseries,left=6pt}{case}
    \newtcbtheorem[number within=section]{Rule}{Rule}{
      colback=teal!15,colframe=teal!15,fonttitle=\bfseries,coltitle=black,left=6pt}{rul}
  \fi
  \newenvironment{statute}[1][]{\begin{Statute}{#1}{}}{\end{Statute}}
  \newenvironment{case}[1][]{\begin{Case}{#1}{}}{\end{Case}}
  \newenvironment{rul}[1][]{\begin{Rule}{#1}{}}{\end{Rule}}
}

\endinput