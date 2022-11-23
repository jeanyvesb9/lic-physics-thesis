\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{thesis-class}[2022/01/01 v1 Thesis Class]

\pdfvariable minorversion=6

\RequirePackage{xkeyval, xifthen}

%%
% Declare we're tufte-thesis-beaucamp
\newcommand{\@tufte@class}{memoir}% the base LaTeX class
\newcommand{\@tufte@pkgname}{thesis}% the name of the package

%%
% Define some shortcut macros for error/warning/info logging.
\RequirePackage{hardwrap}
\GenerateClassLogMacros[@tufte]{\@tufte@pkgname}
\newcommand{\@tufte@debug@info}[1]{\ifthenelse{\boolean{@tufte@debug}}{\@tufte@info{#1}}{}}
\newcommand{\@tufte@debug@info@noline}[1]{\ifthenelse{\boolean{@tufte@debug}}{\@tufte@info@noline{#1}}{}}

%%
% `debug' option -- provides more information in the .log file for use in
% troubleshooting problems
\newboolean{@tufte@debug}
\DeclareOptionX[tufte]<common>{debug}{\setboolean{@tufte@debug}{true}}


\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{memoir}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions\relax

\LoadClass[%
    a4paper,
    10pt,
    oneside,
]{\@tufte@class}


% --- Localication setup
\usepackage[spanish, es-tabla]{babel}
\decimalpoint




%%%=====================================================================================
%%% General setup %%%
%%%=====================================================================================

%%% --- `sidenote', `marginnote', `caption', `citation' alinment options
% Each allows one of {\justifying, \RaggedLeft, \RaggedRight, \@tufte@justification@outer}.

\newcommand*{\@tufte@sidenote@justification}{\justifying}
\newcommand*{\@tufte@marginnote@justification}{\justifying}
\newcommand*{\@tufte@caption@justification}{\justifying}
\newcommand*{\@tufte@citation@justification}{\justifying}

% Improved letterspacing for smallcaps and allcaps
\newboolean{@tufte@letterspace}
\setboolean{@tufte@letterspace}{true}

%%
% `symmetric' option -- puts marginpar space to the outside edge of the page
%   Note: this option forces the twoside option (see the .cls files)
\newboolean{@tufte@symmetric}
\setboolean{@tufte@symmetric}{false}



%%%=====================================================================================
%%% Aux Macros %%%
%%%=====================================================================================

% Write our own aliases for the \checkoddpage and \ifoddpage or \ifcpoddpage commands
\newboolean{@tufte@odd@page}
\setboolean{@tufte@odd@page}{true}
\newcommand*{\@tufte@checkoddpage}{%
  \checkoddpage%
  \ifoddpage%
    \setboolean{@tufte@odd@page}{true}%
  \else%
    \setboolean{@tufte@odd@page}{false}%
  \fi%
}

%%
% Compute lengths used for full-width displays

\newlength{\@tufte@overhang}% used by the fullwidth environment and the running heads
\newlength{\@tufte@fullwidth}
\newlength{\@tufte@caption@fill}

\newcommand{\TufteRecalculate}{%
  \setlength{\@tufte@overhang}{\marginparwidth}
  \addtolength{\@tufte@overhang}{\marginparsep}

  \setlength{\@tufte@fullwidth}{\textwidth}
  \addtolength{\@tufte@fullwidth}{\marginparsep}
  \addtolength{\@tufte@fullwidth}{\marginparwidth}

  \setlength{\@tufte@caption@fill}{\textwidth}
  \addtolength{\@tufte@caption@fill}{\marginparsep}
}

\AtBeginDocument{\TufteRecalculate}

% Forces the outer edge of the caption to be set ragged.  
% Therefore, on verso pages it's ragged left, and on recto pages it's ragged right.

\newcommand*{\@tufte@justification@caption@outer}{%
  \ifthenelse{\boolean{@tufte@float@recto}}%
    {\RaggedRight}%
    {\RaggedLeft}%
}

\newcommand*{\@tufte@justification@outer}{%
  \@tufte@checkoddpage%
  \ifthenelse{\boolean{@tufte@odd@page}}%
    {\RaggedRight}%
    {\RaggedLeft}%
}

\providecommand\blankpage{\newpage\hbox{}\thispagestyle{empty}\newpage}
\providecommand\setinputpath[1]{%
    \makeatletter
    \def\input@path{{#1}}
    \graphicspath{{#1}}
    \makeatother
}

% Redefine \cleardoublepage to always be like on the "twoside" mode
\def\cleardoublepage{\clearpage\ifodd\c@page\else
  \hbox{}
  \thispagestyle{empty}
  \newpage
  \if@twocolumn\hbox{}\newpage\fi\fi}


%%
% Globally sets the length

\newcommand*{\gsetlength}[2]{%
  \setlength{#1}{#2}%
  \global#1=#1\relax%
}

%%
% Globally sets a boolean

\newcommand*{\gsetboolean}[2]{% based on code from ifthen pkg
  \lowercase{\def\@tempa{#2}}%
  \@ifundefined{@tempswa\@tempa}%
    {\PackageError{ifthen}{You can only set a boolean to `true' or `false'}\@ehc}%
    {\@ifundefined{#1\@tempa}%
      {\PackageError{ifthen}{Boolean #1 undefined}\@ehc}%
      {\global\csname#1\@tempa\endcsname}%
    }%
}

%%
% A function that removes leading and trailling spaces from the supplied macro.
% Based on code written by Michael Downes (See ``Around the Bend'', #15.)
% Executing \@tufte@trim@spaces\xyzzy will result in the contents of \xyzzy
% being trimmed of leading and trailing white space.

\catcode`\Q=3
\def\@tufte@trim@spaces#1{%
  % Use grouping to emulate a multi-token afterassignment queue
  \begingroup%
  % Put `\toks 0 {' into the afterassignment queue
  \aftergroup\toks\aftergroup0\aftergroup{% 
  % Apply \trimb to the replacement text of #1, adding a leading
  % \noexpand to prevent brace stripping and to serve another purpose
  % later.
  \expandafter\@tufte@trim@b\expandafter\noexpand#1Q Q}%
  % Transfer the trimmed text back into #1.
  \edef#1{\the\toks0}%
}

% \trimb removes a trailing space if present, then calls \@tufte@trim@c to
% clean up any leftover bizarre Qs, and trim a leading space. In
% order for \trimc to work properly we need to put back a Q first.
\def\@tufte@trim@b#1 Q{\@tufte@trim@c#1Q}

% Execute \vfuzz assignment to remove leading space; the \noexpand
% will now prevent unwanted expansion of a macro or other expandable
% token at the beginning of the trimmed text. The \endgroup will feed
% in the \aftergroup tokens after the \vfuzz assignment is completed.
\def\@tufte@trim@c#1Q#2{\afterassignment\endgroup \vfuzz\the\vfuzz#1}
\catcode`\Q=11








%%%=====================================================================================
%%% Layout the Page
%%%=====================================================================================
\RequirePackage{geometry}

\setlrmarginsandblock{19mm}{80mm}{*}
%\setlrmarginsandblock{26mm}{211pt}{*}
\setmarginnotes{5mm}{58mm}{1em} % Originally {9mm}{12pc}{10pt}

\setulmarginsandblock{6pc}{8pc}{*}

\setheadfoot{1.25\baselineskip}{10mm}
\setheaderspaces{*}{8mm}{*}

\checkandfixthelayout

%%
% Tighten up space between displays (e.g., a figure or table) and make symmetric

\setlength\abovedisplayskip{6pt plus 2pt minus 4pt}
\setlength\belowdisplayskip{6pt plus 2pt minus 4pt}
%\setlength\belowcaptionskip{-10pt}

%%
% The default minimum amount of space between \marginnotes is 10 pt.
\setlength\marginparpush{18pt}

%%%=====================================================================================
%%% Color Definitions
%%%=====================================================================================
\RequirePackage[dvipsnames]{xcolor}

\definecolor{Burgundy}{cmyk}{0, 1, 0.78, 0.44}
%\definecolor{Burgundy}{RGB}{144, 0, 32}
\definecolor{RoyalBlue}{cmyk}{1, 0.5, 0, 0}
\definecolor{Black}{cmyk}{0, 0, 0, 0}
\definecolor{alertred}{cmyk}{0, 0.85, 0.85, 0.2}
%\definecolor{alertred}{rgb}{0.80, 0.12, 0.12}
\definecolor{linkgreen}{cmyk}{1, 0, 1, 0.35}
%\definecolor{linkgreen}{RGB}{0, 166, 0}


%%%=====================================================================================
%%% Fonts Formatting %%%
%%%=====================================================================================

\RequirePackage[T1]{fontenc}

\DisemulatePackage{setspace} % Because we're using the memoir baseclass
\RequirePackage{setspace} % For doublespacing, and other linespacing
\RequirePackage[nopatch={eqnum,footnote}, babel=true]{microtype}

\RequirePackage{charter} % normal Serif font
%\RequirePackage{cabin} % normal Sans Serif font
%\RequirePackage{beramono} % monospace font

%\RequirePackage{fontspec}
%\setmainfont{XCharter}
%\setsansfont[Renderer=Basic, Scale=0.90]{TeX Gyre Heros}
%\setmonofont[Renderer=Basic]{TeX Gyre Cursor}
%
% Due to some missing characters:
%\RequirePackage{newunicodechar}
%\newfontfamily\latinmodernfont{Latin Modern Roman}
%\newunicodechar{^^^^2192}{{\latinmodernfont\symbol{"2192}}} % →
%\newunicodechar{^^^^221a}{{\latinmodernfont\symbol{"221A}}} % →


%\RequirePackage[bitstream-charter]{mathdesign}
%% fix mathdesigns redefinition of hrulefill
%% see https://tex.stackexchange.com/a/135356/37762
%\def\hrulefill{\leavevmode\leaders \hrule height \rulethickness \hfill\kern\z@}

% set mathcal font 
% see https://tex.stackexchange.com/a/496198/37762
\SetMathAlphabet{\mathcal}{normal}{OMS}{zplm}{m}{n}


%%
% Set the font sizes and baselines to match Tufte's books

% REMEMBER TO CHANGE THE memoir DEFAULT FONT SIZE!!!!

\renewcommand\tiny{\@setfontsize\tiny\@vipt\@viipt}
%\renewcommand\tiny{\@setfontsize\tiny\@vpt\@vipt}
\renewcommand\scriptsize{\@setfontsize\scriptsize\@viipt\@viiipt}

\let\memoirFootnotesize\footnotesize
\renewcommand\footnotesize{%
   \memoirFootnotesize
   \@setfontsize\footnotesize\@viiipt{10}% Originally \@viiipt{9}
}

\let\memoirSmall\small
\renewcommand\small{%
   \memoirSmall
   \@setfontsize\small\@ixpt{11}% Prev \@ixpt{12}
}

\let\memoirNormalsize\normalsize
\renewcommand\normalsize{%
   \memoirNormalsize
   \@setfontsize\normalsize\@xpt{14}%
}
\normalbaselineskip=14pt
\normalsize

\renewcommand\large{\@setfontsize\large\@xipt{15}}
%\renewcommand\large{\@setfontsize\large\@xipt{13.6}}
\renewcommand\Large{\@setfontsize\Large\@xiipt{16}}
%\renewcommand\Large{\@setfontsize\Large\@xiipt{14.5}}
\renewcommand\LARGE{\@setfontsize\LARGE\@xivpt{18}}
%\renewcommand\LARGE{\@setfontsize\LARGE\@xivpt{18}}
\renewcommand\huge{\@setfontsize\huge\@xviipt{22}}
%\renewcommand\huge{\@setfontsize\huge\@xxpt{30}}
\renewcommand\Huge{\@setfontsize\Huge\@xxpt{25}}
%\renewcommand\Huge{\@setfontsize\Huge\@xxiv{36}}

\setlength\leftmargini   {1pc}
\setlength\leftmarginii  {1pc}
\setlength\leftmarginiii {1pc}
\setlength\leftmarginiv  {1pc}
\setlength\leftmarginv   {1pc}
\setlength\leftmarginvi  {1pc}
\setlength\labelsep      {.5pc}
\setlength\labelwidth    {\leftmargini}
\addtolength\labelwidth{-\labelsep}

%%
% \RaggedRight allows hyphenation

\setlength{\parindent}{1.0pc}%
\setlength{\parskip}{0pt}%
\RequirePackage{ragged2e}
\setlength{\RaggedRightRightskip}{\z@ plus 0.08\hsize}

% Paragraph indentation and separation for normal text
\newcommand{\@tufte@reset@par}{%
  \setlength{\RaggedRightParindent}{1.0pc}%
  \setlength{\JustifyingParindent}{1.0pc}%
  \setlength{\parindent}{1pc}%
  \setlength{\parskip}{0pt}%
}
\@tufte@reset@par

% Paragraph indentation and separation for marginal text
\newcommand{\@tufte@margin@par}{%
  \setlength{\RaggedRightParindent}{0.5pc}%
  \setlength{\JustifyingParindent}{0.5pc}%
  \setlength{\parindent}{0.5pc}%
  \setlength{\parskip}{0pt}%
}

%%
% Font for margin items

% Use sans serif fonts for margin items
\newboolean{@tufte@sfsidenotes}
\setboolean{@tufte@sfsidenotes}{false}

\ifthenelse{\boolean{@tufte@sfsidenotes}}
  {\newcommand{\@tufte@marginfont}{\normalfont\footnotesize\sffamily}}
  {\newcommand{\@tufte@marginfont}{\normalfont\footnotesize}}

\newcommand*{\@tufte@sidenote@font}{\@tufte@marginfont}
\newcommand*{\@tufte@caption@font}{\@tufte@marginfont}
\newcommand*{\@tufte@marginnote@font}{\@tufte@marginfont}
\newcommand*{\@tufte@citation@font}{\@tufte@marginfont}

\newcommand*{\setsidenotefont}[1]{\renewcommand*{\@tufte@sidenote@font}{#1}}
\newcommand*{\setcaptionfont}[1]{%
  \renewcommand*{\@tufte@caption@font}{#1}%
  \captionnamefont{\@tufte@caption@font}%
  \captiontitlefont{\@tufte@caption@font}%
}
\newcommand*{\setmarginnotefont}[1]{\renewcommand*{\@tufte@marginnote@font}{#1}}
\newcommand*{\setcitationfont}[1]{\renewcommand*{\@tufte@citation@font}{#1}}

% Since the memoir class fucks up with the caption formatting...
\AtBeginDocument{\setcaptionfont{\@tufte@marginfont}}




\RequirePackage{fvextra} % fvextra (required by minted) has to be loaded before csquotes
\RequirePackage{csquotes} % Fancy quotemarks


%%
% Improved letterspacing of small caps and all-caps text.
% We'll use the `letterspace' package

\DeclareTextFontCommand{\textsmallcaps}{\scshape}

\RequirePackage{textcase} % provides \MakeTextUppercase and \MakeTextLowercase
\def\allcapsspacing{\@tufte@warning{Proper spacing of ALL-CAPS letters has not been set up.}}
\def\smallcapsspacing{\@tufte@warning{Proper spacing of small-caps letters has not been set up.}}
\newcommand{\allcaps}[1]{\allcapsspacing{\MakeTextUppercase{#1}}}
\newcommand{\smallcaps}[1]{\smallcapsspacing{\MakeTextLowercase{#1}}}

\newcommand{\@tufte@letterspacing@letterspace}{%
  % Set up letterspacing (using microtype package)
  \renewcommand{\allcapsspacing}[1]{\textls[200]{##1}}%
  \renewcommand{\smallcapsspacing}[1]{\textls[50]{##1}}%
  \renewcommand{\allcaps}[1]{\allcapsspacing{\MakeTextUppercase{##1}}}%
  \renewcommand{\smallcaps}[1]{\smallcapsspacing{\textsmallcaps{\MakeTextLowercase{##1}}}}%
  \renewcommand{\textsc}[1]{\smallcapsspacing{\textsmallcaps{##1}}}%
  \newcommand{\smallcapslsstyle}[1]{\edef\MT@letterspace@{##1}\lsstyle\scshape\MakeTextLowercase}
  \newcommand{\smallcapsstyle}{\scshape\MakeTextLowercase}
}

\ifthenelse{\boolean{@tufte@letterspace}}{%
  \@tufte@letterspacing@letterspace%
}{}



%%%=====================================================================================
%%% Title Styles
%%%=====================================================================================

\setsecnumdepth{subsection}
%\setsecnumdepth{subsubsection}

\RequirePackage{titlesec}

% Helper for \lsstyle, to make a modal version of \textls
\newcommand\lsstylehelp[1]{\edef\MT@letterspace@{#1}\lsstyle}

\titleformat{\chapter}%
  [display]% shape
  {\color{darkgray}}% format applied to label+text
  {\fontsize{72pt}{96pt}\selectfont\thechapter}% label
  {0pt}% horizontal separation between label and title body
  {\huge\rmfamily\itshape\color{darkgray}}% before the title body
  [\nobreak\vspace*{-10pt}\hrulefill]% after the title body
\titlespacing*{\chapter}{0pt}{0pt}{\baselineskip}

\titleformat{\section}%
  [hang]% shape
  {\normalfont\color{darkgray}\LARGE\smallcapslsstyle{50}}% format applied to label+text
  {\large\thesection}% label
  {1em}% horizontal separation between label and title body
  {}% before the title body
  []% after the title body
\titlespacing*{\section}{0pt}{3.5ex plus 1ex minus .2ex}{2.3ex plus .2ex}

\titleformat{\subsection}%
  [hang]% shape
  {\normalfont\color{darkgray}\Large\smallcapslsstyle{50}}% format applied to label+text
  {\large\thesubsection}% label
  {1em}% horizontal separation between label and title body
  {}% before the title body
  []% after the title body
\titlespacing*{\subsection}{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus.2ex}

\titleformat{\subsubsection}%
  [hang]% shape
  {\normalfont\color{darkgray}\Large\smallcapsstyle}% format applied to label+text
  {\large\thesubsubsection}% label
  {1em}% horizontal separation between label and title body
  {}% before the title body
  []% after the title body
\titlespacing*{\subsubsection}{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus.2ex}

\titleformat{\paragraph}%
  [hang]% shape
  {\normalfont\color{darkgray}\itshape}% format applied to label+text
  {\theparagraph}% label
  {1em}% horizontal separation between label and title body
  {}% before the title body
  []% after the title body
\titlespacing*{\paragraph}{0pt}{1.5em}{1em}



%%%=====================================================================================
%%% Page Headers and Footers
%%%=====================================================================================

\nouppercaseheads
\makepagestyle{thesis}
\makepsmarks{thesis}{%
  \nouppercaseheads
  \createmark{chapter}{both}{nonumber}{}{}
  \createmark{section}{right}{nonumber}{}{}
  \createplainmark{toc}{both}{\contentsname}
  \createplainmark{lof}{both}{\listfigurename}
  \createplainmark{lot}{both}{\listtablename}
  \createplainmark{bib}{both}{\bibname}
  \createplainmark{index}{both}{\indexname}
  \createplainmark{glossary}{both}{\glossaryname}
}
\makerunningwidth{thesis}[480pt]{480pt}
\makeheadposition{thesis}{flushright}{flushleft}{flushright}{flushleft}
\makeevenhead{thesis}{\small\thepage\hspace{1em}\scshape{\smallcapsstyle{50}\leftmark}}{}{}
\makeoddhead{thesis}{}{}{\small\scshape{\smallcapslsstyle{50}\rightmark}\hspace{1em}\thepage}

%%% Set the default page style
\pagestyle{thesis}

\makepagestyle{fullwidth}
\makepsmarks{fullwidth}{%
  \nouppercaseheads
  \createmark{chapter}{both}{nonumber}{}{}
  \createmark{section}{right}{nonumber}{}{}
  \createplainmark{toc}{both}{\contentsname}
  \createplainmark{lof}{both}{\listfigurename}
  \createplainmark{lot}{both}{\listtablename}
  \createplainmark{bib}{both}{\bibname}
  \createplainmark{index}{both}{\indexname}
  \createplainmark{glossary}{both}{\glossaryname}
}
\makerunningwidth{fullwidth}[480pt]{480pt}
\makeheadposition{fullwidth}{flushright}{flushleft}{flushright}{flushleft}
\makeevenhead{fullwidth}{\small\thepage\hspace{1em}\textsc{\smallcapslsstyle{50}\leftmark}}{}{}
\makeoddhead{fullwidth}{}{}{\small\textsc{\smallcapslsstyle{50}\rightmark}\hspace{1em}\thepage}

\makepagestyle{plain}
\makerunningwidth{plain}[480pt]{480pt}
\makeheadposition{plain}{flushright}{flushleft}{flushright}{flushleft}
\makeevenfoot{plain}{\small\thepage}{}{}
\makeoddfoot{plain}{}{}{\small\thepage}

\makepagestyle{fullwidthplain}
\makerunningwidth{fullwidthplain}[480pt]{480pt}
\makeheadposition{fullwidthplain}{flushright}{flushleft}{flushright}{flushleft}
\makeevenfoot{fullwidthplain}{\small\thepage}{}{}
\makeoddfoot{fullwidthplain}{}{}{\small\thepage}

\aliaspagestyle{part}{empty}
\aliaspagestyle{chapter}{plain}



%%%=====================================================================================
%%% Sidenotes:
%%%=====================================================================================

%%
% Transform existing \footnotes into \sidenotes
% Sidenote: ``Where God meant footnotes to go.'' ---Tufte

\RequirePackage{optparams}% for our new sidenote commands -- provides multiple optional arguments for commands

\providecommand{\footnotelayout}{\@tufte@sidenote@font\@tufte@sidenote@justification}
\renewcommand{\footnotelayout}{\@tufte@sidenote@font\@tufte@sidenote@justification}

% Override footmisc's definition to set the sidenote marks (numbers) inside the
% sidenote's text block.
\long\def\@makefntext#1{\@textsuperscript{\@tufte@sidenote@font\tiny\@thefnmark}\,\footnotelayout#1}

% Set the in-text footnote mark in the same typeface as the body text itself.
\def\@makefnmark{\hbox{\@textsuperscript{\normalfont\footnotesize\@thefnmark}}}

\providecommand*{\multiplefootnotemarker}{3sp}
\providecommand*{\multfootsep}{,}

\renewcommand{\@footnotemark}{%
  \leavevmode%
  \ifhmode%
    \edef\@x@sf{\the\spacefactor}%
    \@tufte@check@multiple@sidenotes%
    \nobreak%
  \fi%
  \@makefnmark%
  \ifhmode\spacefactor\@x@sf\fi%
  \relax%
}

\newcommand{\@tufte@check@multiple@sidenotes}{%
  \ifdim\lastkern=\multiplefootnotemarker\relax%
    \edef\@x@sf{\the\spacefactor}%
    \unkern%
    \textsuperscript{\multfootsep}%
    \spacefactor\@x@sf\relax%
  \fi
}

\renewcommand\@footnotetext[2][0pt]{%
  \marginpar{%
    \hbox{}\vspace*{#1}%
    \def\baselinestretch {\setspace@singlespace}%
    \reset@font\footnotesize%
    \@tufte@margin@par% use parindent and parskip settings for marginal text
    \vspace*{-1\baselineskip}\noindent%
    \protected@edef\@currentlabel{%
       \csname p@footnote\endcsname\@thefnmark%
    }%
    \color@begingroup%
       \@makefntext{%
         \ignorespaces#2%
       }%
    \color@endgroup%
  }%
}%

%
% Define \sidenote command.  Can handle \cite.

\newlength{\@tufte@sidenote@vertical@offset}
\setlength{\@tufte@sidenote@vertical@offset}{0pt}

% #1 = footnote num, #2 = vertical offset, #3 = footnote text
\long\def\@tufte@sidenote[#1][#2]#3{%
  %\let\cite\@tufte@infootnote@cite%   use the in-sidenote \cite command
  %\gdef\@tufte@citations{}%           clear out any old citations
  \let\cite\citeonly
  \ifthenelse{\NOT\isempty{#2}}{%
    \gsetlength{\@tufte@sidenote@vertical@offset}{#2}%
  }{%
    \gsetlength{\@tufte@sidenote@vertical@offset}{0pt}%
  }%
  \ifthenelse{\isempty{#1}}{%
    % no specific footnote number provided
    \stepcounter\@mpfn%
    \protected@xdef\@thefnmark{\thempfn}%
    \@footnotemark\@footnotetext[\@tufte@sidenote@vertical@offset]{#3}%
  }{%
    % specific footnote number provided
    \begingroup%
      \csname c@\@mpfn\endcsname #1\relax%
      \unrestored@protected@xdef\@thefnmark{\thempfn}%
    \endgroup%
    \@footnotemark\@footnotetext[\@tufte@sidenote@vertical@offset]{#3}%
  }%
  %\@tufte@print@citations%            print any citations
  \let\cite\@tufte@normal@cite%       go back to using normal in-text \cite command
  \unskip\ignorespaces%               remove extra white space
  \kern-\multiplefootnotemarker%      remove \kern left behind by sidenote
  \kern\multiplefootnotemarker\relax% add new \kern here to replace the one we yanked
}

\newcommand{\sidenote}{\optparams{\@tufte@sidenote}{[][0pt]}}
\renewcommand{\footnote}{\optparams{\@tufte@sidenote}{[][0pt]}}


%%
% Sidenote without the footnote mark

\newcommand\marginnote[2][0pt]{%
  %\let\cite\@tufte@infootnote@cite%   use the in-sidenote \cite command
  %\gdef\@tufte@citations{}%           clear out any old citations
  \let\cite\citeonly
  \marginpar{\hbox{}\vspace*{#1}\@tufte@marginnote@font\@tufte@marginnote@justification\@tufte@margin@par\vspace*{-1\baselineskip}\noindent #2}%
  %\@tufte@print@citations%            print any citations
  \let\cite\@tufte@normal@cite%       go back to using normal in-text \cite command
}





%%%=====================================================================================
%%% Figures and Tables with captions:
%%%=====================================================================================

%%
% Margin figure environment

\renewenvironment{marginfigure}[1][-1.2ex]%
  {\begin{@tufte@margin@float}[#1]{figure}\noindent}
  {\end{@tufte@margin@float}}


%%
% Margin table environment

\renewenvironment{margintable}[1][-1.2ex]%
  {\begin{@tufte@margin@float}[#1]{table}\noindent}
  {\end{@tufte@margin@float}}





% Boxes to temporarily store our float and caption
\newsavebox{\@tufte@figure@box}
\newsavebox{\@tufte@caption@box}

% New length for tweaking float captions
\newlength{\@tufte@caption@vertical@offset}
\setlength{\@tufte@caption@vertical@offset}{0pt}

% Store the caption and label contents
\newcommand{\@tufte@stored@shortcaption}{}
\newcommand{\@tufte@stored@caption}{}
\newcommand{\@tufte@stored@label}{}

\long\def\@tufte@caption[#1][#2]#3{%
  \ifthenelse{\isempty{#1}}%
    {\gdef\@tufte@stored@shortcaption{#3}}%
    {\gdef\@tufte@stored@shortcaption{#1}}%
  \gsetlength{\@tufte@caption@vertical@offset}{-#2}% we want a positive offset to lower captions
  \gdef\@tufte@stored@caption{#3}%
}

\let\fullwidthCaption\caption
\newboolean{@tufte@stored@fullwidthCaptionFlag}
\long\def\@tufte@fullwidthCaption[#1]#2{
  \gsetboolean{@tufte@stored@fullwidthCaptionFlag}{true}
  \ifthenelse{\isempty{#1}}%
    {\gdef\@tufte@stored@shortcaption{#2}}%
    {\gdef\@tufte@stored@shortcaption{#1}}%
  \gdef\@tufte@stored@caption{#2}%
}

\newcommand{\@tufte@label}[1]{%
  \gdef\@tufte@stored@label{#1}%
}

\newcommand{\@tufte@fps}{}

\newboolean{@tufte@float@star}
\newlength{\@tufte@float@contents@width}

%%
% Define a float environment to place the captions in the margin space

\newenvironment{@tufte@float}[3][htbp]%
  {% begin @tufte@float
    % Should this float be full-width or just text-width?
    \gsetboolean{@tufte@stored@fullwidthCaptionFlag}{false}
    \ifthenelse{\equal{#3}{star}}%
      {\gsetboolean{@tufte@float@star}{true}}%
      {\gsetboolean{@tufte@float@star}{false}}%
    % Check page side (recto/verso) and store detected value -- can be overriden in environment contents
    \@tufte@checkoddpage%
    \ifthenelse{\boolean{@tufte@odd@page}}%
      {\gsetboolean{@tufte@float@recto}{true}\@tufte@float@debug{Detected page: [recto/odd]}}%
      {\gsetboolean{@tufte@float@recto}{false}\@tufte@float@debug{Detected page: [verso/even]}}%
    % If the float placement specifier is 'b' and only 'b', then bottom-align the mini-pages, otherwise top-align them.
    \renewcommand{\@tufte@fps}{#1}%
    \@tufte@float@debug{Allowed positions: [#1]}%
    \ifthenelse{\equal{#1}{b}\OR\equal{#1}{B}}%
      {\renewcommand{\floatalignment}{b}\@tufte@float@debug{Presumed position: [bottom]}}%
      {\renewcommand{\floatalignment}{t}\@tufte@float@debug{Presumed position: [top]}}%
    % Capture the contents of the \caption and \label commands to use later
    \global\let\@tufte@orig@caption\caption%
    \global\let\@tufte@orig@label\label%
    \renewcommand{\caption}{\optparams{\@tufte@caption}{[][0pt]}}%
    \renewcommand{\fullwidthCaption}{\optparams{\@tufte@fullwidthCaption}{[]}}%
    \renewcommand{\label}[1]{\@tufte@label{##1}}%
    \@tufte@orig@float{#2}[#1]%
    \ifthenelse{\boolean{@tufte@float@star}}%
      {\setlength{\@tufte@float@contents@width}{\@tufte@fullwidth}}%
      {\setlength{\@tufte@float@contents@width}{\textwidth}}%
    \begin{lrbox}{\@tufte@figure@box}%
      \begin{minipage}[\floatalignment]{\@tufte@float@contents@width}\hbox{}%
  }{% end @tufte@float
      \ifthenelse{\boolean{@tufte@stored@fullwidthCaptionFlag}}{%
        \par%
        \begin{minipage}{\@tufte@float@contents@width}%
          \@tufte@orig@caption[\@tufte@stored@shortcaption]{\@tufte@stored@caption}%
          \@tufte@orig@label{\@tufte@stored@label}%
        \end{minipage}%
        \par%
      }{%
        \par\hbox{}\vspace{-\baselineskip}\ifthenelse{\prevdepth>0}{\vspace{-\prevdepth}}{}% align baselines of boxes
      }%
      \end{minipage}%
    \end{lrbox}%
    % build the caption box
    \ifthenelse{\not\boolean{@tufte@stored@fullwidthCaptionFlag}}{%
      \begin{lrbox}{\@tufte@caption@box}%
        \begin{minipage}[\floatalignment]{\marginparwidth}\hbox{}%
          \ifthenelse{\NOT\equal{\@tufte@stored@caption}{}}{\@tufte@orig@caption[\@tufte@stored@shortcaption]{\@tufte@stored@caption}}{}%
          \ifthenelse{\NOT\equal{\@tufte@stored@label}{}}{\@tufte@orig@label{\@tufte@stored@label}}{}%
          \par\vspace{-\prevdepth}%% TODO: DOUBLE-CHECK FOR SAFETY
        \end{minipage}%
      \end{lrbox}%
      % now typeset the stored boxes
      \begin{fullwidth}%
        \begin{minipage}[\floatalignment]{\linewidth}%
          \ifthenelse{\boolean{@tufte@float@star}}%
            {\@tufte@float@fullwidth[\@tufte@caption@vertical@offset]{\@tufte@figure@box}{\@tufte@caption@box}}%
            {\@tufte@float@textwidth[\@tufte@caption@vertical@offset]{\@tufte@figure@box}{\@tufte@caption@box}}%
        \end{minipage}%
      \end{fullwidth}%
    }{%
      \begin{fullwidth}%
        \begin{minipage}[\floatalignment]{\linewidth}%
          \ifthenelse{\boolean{@tufte@float@star}}%
            {\usebox{\@tufte@figure@box}}%
            {}%
        \end{minipage}%
      \end{fullwidth}%
    }%
    \@tufte@orig@endfloat% end original LaTeX float environment
    % output debug info
    \ifthenelse{\boolean{@tufte@debug}}{%
      \typeout{^^J^^J----------- Tufte-LaTeX float information ----------}%
      \ifthenelse{\equal{\@tufte@stored@label}{}}%
        {\typeout{Warning: Float unlabeled!}}%
        {\typeout{Float label: [\@tufte@stored@label]}}%
      \typeout{Page number: [\thepage]}%
      \def\MessageBreak{^^J}%
      \typeout{\@tufte@float@debug@info}%
      \ifthenelse{\boolean{@tufte@symmetric}}%
        {\typeout{Symmetric: [true]}}%
        {\typeout{Symmetric: [false]}}%
      \typeout{----------------------------------------------------^^J^^J}%
    }{}%
    % reset commands and temp boxes and captions
    \gdef\@tufte@float@debug@info{}%
    \let\caption\@tufte@orig@caption%
    \let\fullwidthCaption\@tufte@orig@caption%
    \let\label\@tufte@orig@label%
    \begin{lrbox}{\@tufte@figure@box}\hbox{}\end{lrbox}%
    \begin{lrbox}{\@tufte@caption@box}\hbox{}\end{lrbox}%
    \gdef\@tufte@stored@shortcaption{}%
    \gdef\@tufte@stored@caption{}%
    \gdef\@tufte@stored@label{}%
    \gsetlength{\@tufte@caption@vertical@offset}{0pt}% reset caption offset
  }

\newcommand{\@tufte@float@textwidth}[3][0pt]{%
  \ifthenelse{\NOT\boolean{@tufte@symmetric}\OR\boolean{@tufte@float@recto}}{%
    % asymmetric or page is odd, so caption is on the right
    \hbox{%
      \usebox{#2}%
      \hspace{\marginparsep}%
      \smash{\raisebox{#1}{\usebox{#3}}}%
    }%
    \@tufte@float@debug{Caption position: [right]}%
  }{% symmetric pages and page is even, so caption is on the left
    \hbox{%
      \smash{\raisebox{#1}{\usebox{#3}}}%
      \hspace{\marginparsep}%
      \usebox{#2}%
    }%
    \@tufte@float@debug{Caption position: [left]}%
  }%
}

\newcommand{\@tufte@float@fullwidth}[3][0pt]{%
  \ifthenelse{\equal{\floatalignment}{b}}%
    {% place caption above figure
      \ifthenelse{\NOT\boolean{@tufte@symmetric}\OR\boolean{@tufte@float@recto}}%
        {\hfill\smash{\raisebox{#1}{\usebox{#3}}}\par\usebox{#2}\@tufte@float@debug{Caption position: [above right]}}% caption on the right
        {\smash{\raisebox{#1}{\usebox{#3}}}\hfill\par\usebox{#2}\@tufte@float@debug{Caption position: [above left]}}% caption on the left
    }{% place caption below figure
      \ifthenelse{\NOT\boolean{@tufte@symmetric}\OR\boolean{@tufte@float@recto}}%
        {\usebox{#2}\par\hfill\smash{\raisebox{#1}{\usebox{#3}}}\@tufte@float@debug{Caption position: [below right]}}% caption on the right
        {\usebox{#2}\par\smash{\raisebox{#1}{\usebox{#3}}}\hfill\@tufte@float@debug{Caption position: [below left]}}% caption on the left
    }%
}





%%
% Redefine the figure environment to place the captions in the margin space

\renewenvironment{figure}[1][htbp]%
  {\ifvmode\else\unskip\fi\begin{@tufte@float}[#1]{figure}{}}
  {\end{@tufte@float}}


%%
% Redefine the table environment to place the captions in the margin space

\renewenvironment{table}[1][htbp]
  {\ifvmode\else\unskip\fi\begin{@tufte@float}[#1]{table}{}}
  {\end{@tufte@float}}


\newlength{\fulllinewidth}
%%
% Full-width figure

\renewenvironment{figure*}[1][htbp]%
  {\ifvmode\else\unskip\fi\begin{@tufte@float}[#1]{figure}{star}\setlength{\fulllinewidth}{\linewidth}}
  {\end{@tufte@float}}


%%
% Full-width table

\renewenvironment{table*}[1][htbp]%
  {\ifvmode\else\unskip\fi\begin{@tufte@float}[#1]{table}{star}\setlength{\fulllinewidth}{\linewidth}}
  {\end{@tufte@float}}


%%
% Format the captions in a style similar to the sidenotes

\long\def\@caption#1[#2]#3{%
  \par%
  \addcontentsline{\csname ext@#1\endcsname}{#1}%
    {\protect\numberline{\csname the#1\endcsname}{\ignorespaces #2}}%
  \begingroup%
    \@parboxrestore%
    \if@minipage%
      \@setminipage%
    \fi%
    \@tufte@caption@font\@tufte@caption@justification%
    \noindent\csname fnum@#1\endcsname: \ignorespaces#3\par%
    %\@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par
  \endgroup}




%%%=====================================================================================
%%% Citations and Bibliography:
%%%=====================================================================================

% Setup biblatex

\RequirePackage[
    backend=biber,
    bibencoding=utf8,
    hyperref=true,
    maxbibnames=20,
    maxcitenames=1,
    %giveninits=true,
    style=alphabetic,
    sorting=nyt,
    sortcites=false,
    citetracker=true,
    pagetracker=true,
    backref,
]{biblatex}

\DefineBibliographyStrings{spanish}{%
  andothers = {et\addabbrvspace al\adddot}
}

\DeclareFieldFormat*{title}{\mkbibquote{#1}}
\DeclareFieldFormat*{citetitle}{\mkbibquote{#1}}

%\renewcommand*{\bibfont}{\small}

\providecommand{\doi}[1]{\textsc{doi:} #1}% pre-defining this so it may be used before the \bibliography command it issued

%%
% Citations should go in the margin as sidenotes

% We will use the precite field as an offset

%%
% Normal \cite behavior

% https://tex.stackexchange.com/questions/74931/biblatexs-textcite-inserts-a-breaking-space-between-author-names-and-citation-n
\renewcommand{\namelabeldelim}{\addnbspace}

%% https://tex.stackexchange.com/a/444830/37762
\newcommand*{\scbx@registerkey}{%
  \ifcsundef{cbx@instcount@curr@\the\c@refsection @\thefield{entrykey}}
    {\csnumgdef{cbx@instcount@curr@\the\c@refsection @\thefield{entrykey}}{0}}
    {}%
  \csnumgdef{cbx@instcount@last@\the\c@refsection @\thefield{entrykey}}{%
    \csuse{cbx@instcount@curr@\the\c@refsection @\thefield{entrykey}}}%
  \csnumgdef{cbx@instcount@curr@\the\c@refsection @\thefield{entrykey}}{\value{instcount}}}

\def\iflastciteonsamepage{%
  \ifsamepage
    {\number\csuse{cbx@instcount@curr@\the\c@refsection @\thefield{entrykey}}}
    {\number\csuse{cbx@instcount@last@\the\c@refsection @\thefield{entrykey}}}}

\newcommand*{\scbx@savepunctstate}{%
  \let\scbx@saved@unitpunct\blx@unitpunct
  \let\scbx@saved@tgl@unit\etb@tgl@blx@unit
  \let\scbx@saved@tgl@block\etb@tgl@blx@block
  \let\scbx@saved@tgl@insert\etb@tgl@blx@insert
  \let\scbx@saved@tgl@lastins\etb@tgl@blx@lastins
  \let\scbx@saved@tgl@keepunit\etb@tgl@blx@keepunit
}

\newcommand*{\scbx@restorepunctstate}{%
  \global\let\blx@unitpunct\scbx@saved@unitpunct
  \global\let\etb@tgl@blx@unit\scbx@saved@tgl@unit
  \global\let\etb@tgl@blx@block\scbx@saved@tgl@block
  \global\let\etb@tgl@blx@insert\scbx@saved@tgl@insert
  \global\let\etb@tgl@blx@lastins\scbx@saved@tgl@lastins
  \global\let\etb@tgl@blx@keepunit\scbx@saved@tgl@keepunit
}

\newcommand*{\scbx@resetpunctstate}{%
  \let\blx@unitpunct\@empty
  \global\togglefalse{blx@block}%
  \global\togglefalse{blx@unit}%
  \global\togglefalse{blx@insert}%
  \global\togglefalse{blx@lastins}%
  \global\togglefalse{blx@keepunit}%
}

\RequirePackage{xparse}

%\ExplSyntaxOn
%\NewDocumentCommand{\iflengthTF}{mmm}
%{
%  % regex from https://stackoverflow.com/a/23872060/923955
%  % with modifications for expl3 and for adding a unit
%  \regex_match:nnTF
%    {\A [+\-]? ((\d+(\.\d*)?)|(\.\d+)) \s* (pt|pc|in|bp|cm|mm|dd|cc|sp|ex|em) \Z} % regex
%    {#1} % test string
%    {#2} % true text
%    {#3} % false text
%}
%\cs_new_eq:NN \strcompare \str_if_eq:eeTF
%\ExplSyntaxOff

%\newboolean{@tufte@cite@offset@validflag}

\newbibmacro{sidecite}{%
  \scbx@savepunctstate%
  \scbx@resetpunctstate%
  %\renewcommand{\@tufte@cite@offset}{\iffieldundef{prenote}{0em}{\thefield{prenote}}}%
  %\StrLen{\@tufte@cite@offset}[\mystringlen]
  \edef\@tufte@cite@offset{\iffieldundef{prenote}{0em}{\thefield{prenote}}}%
  \ifthenelse{\not\equal{\@tufte@cite@offset}{-}}{%
    %\edef\@tufte@cite@offset@valid{\iflengthTF{\@tufte@cite@offset}{}{}}%
    %\gsetboolean{@tufte@cite@offset@validflag}{\@tufte@cite@offset@valid}%
    \marginnote[\@tufte@cite@offset]{%
      \toggletrue{blx@footnote}%
      \footnotesize%
      \printtext[labelalphawidth]{%
        \printfield{labelprefix}%
        \printfield{labelalpha}%
        \printfield{extraalpha}%
      }%
      \setunit{\addnbspace}%
      \printnames{labelname}%
      \setunit{\printdelim{nametitledelim}}%
      \printfield[citetitle]{labeltitle}%
      %\@tufte@cite@offset@valid%
      %\ifthenelse{\boolean{@tufte@cite@offset@validflag}}{AA}{BB}%
      %\iflengthTF{\@tufte@cite@offset}{a}{b}
      %\edef\temp{\iflengthTF{\@tufte@cite@offset}{%
      %  \setboolean{@tufte@cite@offset@validflag}{true}%
      %}{%
      %  \setboolean{@tufte@cite@offset@validflag}{false}%
      %}%
      %}
      %\ifthenelse{\boolean{@tufte@cite@offset@validflag}}{A}{B}
      %\ifthenelse{\tufte@cite}{A}{B}
      %\ifthenelse{\expandafter\iflengthTF\expandafter{\@tufte@cite@offset}}{A}{B}
      %\edef\lalala{\iflengthTF{\@tufte@cite@offset}}%
      %\ifthenelse{\lalala}{A}{B}
    }%
  }{}%
  \scbx@restorepunctstate%
}

\DeclareCiteCommand{\@tufte@normal@cite}[\mkbibbrackets]%
  %{\usebibmacro{prenote}}
  {}%
  {\scbx@registerkey%
   \ifciteindex%
     {\indexfield{indextitle}}%
     {}%
   \usebibmacro{cite}%
   \iflastciteonsamepage%
     {}%
     {\usebibmacro{sidecite}}}%
  {\multicitedelim}%
  {\usebibmacro{postnote}}%

\DeclareCiteCommand{\citeonly}[\mkbibbrackets]%
  {}%
  {\ifciteindex%
     {\indexfield{indextitle}}%
     {}%
   \usebibmacro{cite}}%
  {\multicitedelim}%
  {\usebibmacro{postnote}}%

\DeclareCiteCommand{\cbx@textcite}%
  {\usebibmacro{textcite:init}}%
  {\scbx@registerkey%
   \usebibmacro{citeindex}%
   \usebibmacro{textcite}%
   \iflastciteonsamepage%
     {}%
     {\usebibmacro{sidecite}}}%
  {}%
  {\usebibmacro{textcite:postnote}}%


%%
% Set the default \cite style.  This is set and reset by the \sidenote command.
\let\cite\@tufte@normal@cite

\DeclareMultiCiteCommand{\cites}[\mkbibbrackets]
  {\@tufte@normal@cite}
  {\multicitedelim}



%\newcounter{@tufte@num@bibkeys}%
%
%%%
%% Normal \cite behavior
%\newcommand{\@tufte@normal@cite}[2][0pt]{%
%  % Snag the last bibentry in the list for later comparison
%  \let\@temp@last@bibkey\@empty%
%  \@for\@temp@bibkey:=#2\do{\let\@temp@last@bibkey\@temp@bibkey}%
%  \sidenote[][#1]{%
%    % Loop through all the bibentries, separating them with semicolons and spaces
%    \normalsize\normalfont\@tufte@citation@font%
%    \setcounter{@tufte@num@bibkeys}{0}%
%    \@for\@temp@bibkeyx:=#2\do{%
%      \ifthenelse{\equal{\@temp@last@bibkey}{\@temp@bibkeyx}}%
%        {\ifthenelse{\equal{\value{@tufte@num@bibkeys}}{0}}{}{and\ }%
%         \@tufte@trim@spaces\@temp@bibkeyx% trim spaces around bibkey
%         \bibentry{\@temp@bibkeyx}}%
%        {\@tufte@trim@spaces\@temp@bibkeyx% trim spaces around bibkey
%         \bibentry{\@temp@bibkeyx};\ }%
%      \stepcounter{@tufte@num@bibkeys}%
%    }%
%  }%
%}


%%%
%% Macros for holding the list of cite keys until after the \sidenote
%
%\gdef\@tufte@citations{}% list of cite keys
%\newcommand\@tufte@add@citation[1]{\relax% adds a new bibkey to the list of cite keys
%  \ifx\@tufte@citations\@empty\else
%    \g@addto@macro\@tufte@citations{,}% separate by commas
%  \fi
%  \g@addto@macro\@tufte@citations{#1}
%}
%
%\newcommand{\@tufte@print@citations}[1][0pt]{% puts the citations in a margin note
%  % Snag the last bibentry in the list for later comparison
%  \let\@temp@last@bibkey\@empty%
%  \@for\@temp@bibkey:=\@tufte@citations\do{\let\@temp@last@bibkey\@temp@bibkey}%
%  \marginpar{%
%    \hbox{}\vspace*{#1}%
%    \@tufte@citation@font%
%    \@tufte@citation@justification%
%    \@tufte@margin@par% use parindent and parskip settings for marginal text
%    \vspace*{-1\baselineskip}%
%    % Loop through all the bibentries, separating them with semicolons and spaces
%    \setcounter{@tufte@num@bibkeys}{0}%
%    \@for\@temp@bibkeyx:=\@tufte@citations\do{%
%      \ifthenelse{\equal{\@temp@last@bibkey}{\@temp@bibkeyx}}%
%        {\ifthenelse{\equal{\value{@tufte@num@bibkeys}}{0}}{}{and\ }%
%         \@tufte@trim@spaces\@temp@bibkeyx% trim spaces around bibkey
%         \bibentry{\@temp@bibkeyx}}%
%        {\@tufte@trim@spaces\@temp@bibkeyx% trim spaces around bibkey
%         \bibentry{\@temp@bibkeyx};\ }%
%      \stepcounter{@tufte@num@bibkeys}%
%    }%
%  }%
%}
%
%%%
%% \cite behavior when executed within a sidenote
%
%\newcommand{\@tufte@sidenote@citations}{}% contains list of \cites in sidenote
%\newcommand{\@tufte@infootnote@cite}[1]{%
%  \@tufte@add@citation{#1}
%}




%%%=====================================================================================
%%% Other Environments
%%%=====================================================================================


%%
% Full-page-width area

\newenvironment{fullwidth}
  {\ifthenelse{\boolean{@tufte@symmetric}}%
     {\begin{adjustwidth*}{}{-\@tufte@overhang}}%
     {\begin{adjustwidth}{}{-\@tufte@overhang}}%
  }%
  {\ifthenelse{\boolean{@tufte@symmetric}}%
    {\end{adjustwidth*}}%
    {\end{adjustwidth}}%
  }

%%
% \newthought environments
\newskip\newthoughtskipamount
\newthoughtskipamount=1.0\baselineskip plus 0.5ex minus 0.2ex
\providecommand\newthoughtbreak{\par\ifdim\lastskip<\newthoughtskipamount
  \removelastskip\penalty-100\newthoughtskip\fi}
\newcommand{\newthoughtskip}{\vspace\newthoughtskipamount}

\providecommand\newthought[1]{%
    \nopagebreak
    \newthoughtbreak
    \noindent%
    {\llap{\color{black!30}\scriptsize\raisebox{1pt}{$\blacktriangleright$}\quad}}%
    \textsc{#1}%
}
\providecommand\newthoughtpar[1]{\nopagebreak\newthought{#1}\par\nopagebreak\noindent\ignorespaces}


%%
% Redefine the display environments (quote, quotation, etc.)
\renewenvironment{verse}
               {\let\\\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1pc%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1pc}%
                \small%
                \item\relax}
               {\endlist}
\renewenvironment{quotation}
               {\list{}{\listparindent 1pc%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \small%
                \item\relax\noindent\ignorespaces}
               {\endlist}
\renewenvironment{quote}
               {\list{}{\rightmargin\leftmargin}%
                \small%
                \item\relax}
               {\endlist}







%%%=====================================================================================
%%% Floats setup
%%%=====================================================================================

\RequirePackage{float}

%%
% The placeins package provides the \FloatBarrier command.  This forces
% LaTeX to place all of the floats before proceeding.  We'll use this to
% keep the float (figure and table) numbers in sequence.
\let\@tufte@global@orig@section\section
\let\noFBSection\@tufte@global@orig@section
\let\@tufte@global@orig@subsection\subsection
\let\noFBSubsection\@tufte@global@orig@subsection
\RequirePackage[section]{placeins}

%%
% Margin float environment

\newsavebox{\@tufte@margin@floatbox}
\newenvironment{@tufte@margin@float}[2][-1.2ex]%
  {\FloatBarrier% process all floats before this point so the figure/table numbers stay in order.
  \begin{lrbox}{\@tufte@margin@floatbox}%
  \begin{minipage}{\marginparwidth}%
    \@tufte@caption@font%
    \def\@captype{#2}%
    \hbox{}\vspace*{#1}%
    \@tufte@caption@justification%
    \@tufte@margin@par%
    \noindent%
  }
  {\end{minipage}%
  \end{lrbox}%
  \marginpar{\usebox{\@tufte@margin@floatbox}}%
  }


%%
% A collection of macros to be used with the new Tufte-style float environments.
% \setfloatalignment forces the caption placement to be treated as top, bottom, etc.
% \forcerectofloat forces the float to be treated as if it were appearing on a recto page.
% \forceversofloat does the same, but for verso pages.

\newcommand{\@tufte@float@debug@info}{}% contains debug info generated as the float is processed
\newcommand{\@tufte@float@debug}[1]{% adds debug info to the queue for output
  \ifthenelse{\equal{\@tufte@float@debug@info}{}}%
    {\def\@tufte@float@debug@info{#1}}%
    {\g@addto@macro\@tufte@float@debug@info{\MessageBreak#1}}%
}

\newcommand{\floatalignment}{x}% holds the current float alignment (t, b, h, p)
\newcommand{\setfloatalignment}[1]{\global\def\floatalignment{#1}\@tufte@float@debug{Forcing position: [#1]}}% manually sets the float alignment
\newboolean{@tufte@float@recto}
\newcommand{\forcerectofloat}{\gsetboolean{@tufte@float@recto}{true}\@tufte@float@debug{Forcing page: [recto]}}
\newcommand{\forceversofloat}{\gsetboolean{@tufte@float@recto}{false}\@tufte@float@debug{Forcing page: [verso]}}


% Save original LaTeX float environment
\let\@tufte@orig@float\@float
\let\@tufte@orig@endfloat\end@float







%%
% A couple commands to incresae the number of floats you can use at a time.

\def\morefloats{% provides a total of 52 floats
  \ifthenelse{\isundefined{\bx@S}}{%
    \@tufte@debug@info@noline{Adding 34 more float slots.}
    \newinsert\bx@S
    \newinsert\bx@T
    \newinsert\bx@U
    \newinsert\bx@V
    \newinsert\bx@W
    \newinsert\bx@X
    \newinsert\bx@Y
    \newinsert\bx@Z
    \newinsert\bx@a
    \newinsert\bx@b
    \newinsert\bx@c
    \newinsert\bx@d
    \newinsert\bx@e
    \newinsert\bx@f
    \newinsert\bx@g
    \newinsert\bx@h
    \newinsert\bx@i
    \newinsert\bx@j
    \newinsert\bx@k
    \newinsert\bx@l
    \newinsert\bx@m
    \newinsert\bx@n
    \newinsert\bx@o
    \newinsert\bx@p
    \newinsert\bx@q
    \newinsert\bx@r
    \newinsert\bx@s
    \newinsert\bx@t
    \newinsert\bx@u
    \newinsert\bx@v
    \newinsert\bx@w
    \newinsert\bx@x
    \newinsert\bx@y
    \newinsert\bx@z
    \gdef\@freelist{\@elt\bx@A\@elt\bx@B\@elt\bx@C\@elt\bx@D\@elt\bx@E
                    \@elt\bx@F\@elt\bx@G\@elt\bx@H\@elt\bx@I\@elt\bx@J
                    \@elt\bx@K\@elt\bx@L\@elt\bx@M\@elt\bx@N
                    \@elt\bx@O\@elt\bx@P\@elt\bx@Q\@elt\bx@R
                    \@elt\bx@S\@elt\bx@T\@elt\bx@U\@elt\bx@V
                    \@elt\bx@W\@elt\bx@X\@elt\bx@Y\@elt\bx@Z
                    \@elt\bx@a\@elt\bx@b\@elt\bx@c\@elt\bx@d\@elt\bx@e
                    \@elt\bx@f\@elt\bx@g\@elt\bx@h\@elt\bx@i\@elt\bx@j
                    \@elt\bx@k\@elt\bx@l\@elt\bx@m\@elt\bx@n
                    \@elt\bx@o\@elt\bx@p\@elt\bx@q\@elt\bx@r
                    \@elt\bx@s\@elt\bx@t\@elt\bx@u\@elt\bx@v
                    \@elt\bx@w\@elt\bx@x\@elt\bx@y\@elt\bx@z}%
  }{% we've already added another 34 floats, so we'll add 26 more, but that's it!
    \ifthenelse{\isundefined{\bx@AA}}{%
      \@tufte@debug@info@noline{Adding 26 more float slots.}
      \newinsert\bx@AA
      \newinsert\bx@BB
      \newinsert\bx@CC
      \newinsert\bx@DD
      \newinsert\bx@EE
      \newinsert\bx@FF
      \newinsert\bx@GG
      \newinsert\bx@HH
      \newinsert\bx@II
      \newinsert\bx@JJ
      \newinsert\bx@KK
      \newinsert\bx@LL
      \newinsert\bx@MM
      \newinsert\bx@NN
      \newinsert\bx@OO
      \newinsert\bx@PP
      \newinsert\bx@QQ
      \newinsert\bx@RR
      \newinsert\bx@SS
      \newinsert\bx@TT
      \newinsert\bx@UU
      \newinsert\bx@VV
      \newinsert\bx@WW
      \newinsert\bx@XX
      \newinsert\bx@YY
      \newinsert\bx@ZZ
      \gdef\@freelist{\@elt\bx@A\@elt\bx@B\@elt\bx@C\@elt\bx@D\@elt\bx@E
                      \@elt\bx@F\@elt\bx@G\@elt\bx@H\@elt\bx@I\@elt\bx@J
                      \@elt\bx@K\@elt\bx@L\@elt\bx@M\@elt\bx@N
                      \@elt\bx@O\@elt\bx@P\@elt\bx@Q\@elt\bx@R
                      \@elt\bx@S\@elt\bx@T\@elt\bx@U\@elt\bx@V
                      \@elt\bx@W\@elt\bx@X\@elt\bx@Y\@elt\bx@Z
                      \@elt\bx@a\@elt\bx@b\@elt\bx@c\@elt\bx@d\@elt\bx@e
                      \@elt\bx@f\@elt\bx@g\@elt\bx@h\@elt\bx@i\@elt\bx@j
                      \@elt\bx@k\@elt\bx@l\@elt\bx@m\@elt\bx@n
                      \@elt\bx@o\@elt\bx@p\@elt\bx@q\@elt\bx@r
                      \@elt\bx@s\@elt\bx@t\@elt\bx@u\@elt\bx@v
                      \@elt\bx@w\@elt\bx@x\@elt\bx@y\@elt\bx@z
                      \@elt\bx@AA\@elt\bx@BB\@elt\bx@CC\@elt\bx@DD\@elt\bx@EE
                      \@elt\bx@FF\@elt\bx@GG\@elt\bx@HH\@elt\bx@II\@elt\bx@JJ
                      \@elt\bx@KK\@elt\bx@LL\@elt\bx@MM\@elt\bx@NN
                      \@elt\bx@OO\@elt\bx@PP\@elt\bx@QQ\@elt\bx@RR
                      \@elt\bx@SS\@elt\bx@TT\@elt\bx@UU\@elt\bx@VV
                      \@elt\bx@WW\@elt\bx@XX\@elt\bx@YY\@elt\bx@ZZ}%
    }{%
      \@tufte@error{You may only call \string\morefloats\space twice. See the Tufte-LaTeX documentation for other workarounds}
        {There are already 78 float slots allocated. Try using \string\FloatBarrier\space or \string\clearpage\space to place some floats before creating more.}
    }%
  }%
}

%%
% Detect of the float package has been loaded

\AtBeginDocument{%
  \@ifpackageloaded{float}{%
    % Save the redefined float environment (instead of the LaTeX float environment)
    \let\@tufte@orig@float\@float
    \let\@tufte@orig@endfloat\end@float

    % Define Tuftian float styles (with the caption in the margin)
    \newcommand{\floatc@tufteplain}[2]{%
      \begin{lrbox}{\@tufte@caption@box}%
        \begin{minipage}[\floatalignment]{\marginparwidth}\hbox{}%
          \@tufte@caption@font{\@fs@cfont #1:} #2\par%
        \end{minipage}%
      \end{lrbox}%
      \smash{\hspace{\@tufte@caption@fill}\usebox{\@tufte@caption@box}}%
    }
    \newcommand{\fs@tufteplain}{%
      \def\@fs@cfont{\@tufte@caption@font}%
      \let\@fs@capt\floatc@tufteplain%
      \def\@fs@pre{}%
      \def\@fs@post{}%
      \def\@fs@mid{}%
      \let\@fs@iftopcapt\iftrue%
    }
    \let\fs@tufteplaintop=\fs@tufteplain
    \let\floatc@tufteplaintop=\floatc@tufteplain
    \newcommand\floatc@tufteruled[2]{%
      {\@fs@cfont #1} #2\par%
    }
    \newcommand\fs@tufteruled{%
      \def\@fs@cfont{\@tufte@caption@font}%
      \let\@fs@capt\floatc@tufteplain%
      \def\@fs@pre{\hrule height.8pt depth0pt width\textwidth \kern2pt}%
      \def\@fs@post{\kern2pt\hrule width\textwidth\relax}%
      \def\@fs@mid{}%
      \let\@fs@iftopcapt\iftrue%
    }
    \newcommand\fs@tufteboxed{%
      \def\@fs@cfont{}%
      \let\@fs@capt\floatc@tufteplain%
      \def\@fs@pre{%
        \setbox\@currbox\vbox{\hbadness10000
        \moveleft3.4pt\vbox{\advance\hsize by6.8pt
          \hrule \hbox to\hsize{\vrule\kern3pt
            \vbox{\kern3pt\box\@currbox\kern3pt}\kern3pt\vrule}\hrule}}
      }%
      \def\@fs@mid{\kern2pt}%
      \def\@fs@post{}%
      \let\@fs@iftopcapt\iftrue%
    }
  }{%
    % Nothing to do
  }
}






%%%=====================================================================================
%%% Figure Formatting
%%%====================================================================================

%%
% For compatibility with the subfig package, we'll set captions=false so that
% it doesn't load the caption package (which modifies our own caption
% formatting).

\RequirePackage[caption=false]{subfig}

% We have to \protect the \subref to be able to use it on the main caption
\let\@tufte@subfig@subref\subref
\renewcommand{\subref}[1]{\protect\@tufte@subfig@subref{#1}}

% Useful length variable for plots with many figures
\newlength{\individualPlotWidth}


%%%=====================================================================================
%%% Table Formatting
%%%=====================================================================================
\RequirePackage{tabularx}
\RequirePackage{booktabs}
\RequirePackage{colortbl}
\RequirePackage{multirow}
\RequirePackage{threeparttable}

%\setlength{\tabcolsep}{19pt}

% --- Fixed-length tabular column types:
\newcolumntype{L}[1]{>{\raggedright\arraybackslash}m{#1}}
\newcolumntype{C}[1]{>{\centering\arraybackslash}m{#1}}
\newcolumntype{R}[1]{>{\raggedleft\arraybackslash}m{#1}}


%%%=====================================================================================
%%% Lists and enumerations Formatting
%%%=====================================================================================

%%
% Require paralist package for tighter lists
\RequirePackage{paralist}

% Add rightmargin to compactenum

\def\@compactenum@{%
  \expandafter\list\csname label\@enumctr\endcsname{%
    \usecounter{\@enumctr}%
    \rightmargin=2em% added this
    \parsep\plparsep
    \itemsep\plitemsep
    \topsep\pltopsep
    \partopsep\plpartopsep
    \def\makelabel##1{\hss\llap{##1}}}}


%%%=====================================================================================
%%% Code display Formatting
%%%=====================================================================================

\RequirePackage{algorithm}
\RequirePackage[noend]{algpseudocode}
\newcommand*\Let[2]{\State{} #1 $\gets$ #2}
\algrenewcommand\alglinenumber[1]{%
    {\sffamily\footnotesize#1}}
\algrenewcommand\algorithmicrequire{\textbf{Precondition:}}
\algrenewcommand\algorithmicensure{\textbf{Postcondition:}}

\AtBeginDocument{
  % Set the float style to the Tuftian version
  \ifthenelse{\equal{\ALG@floatstyle}{plain}\OR\equal{\ALG@floatstyle}{ruled}\OR\equal{\ALG@floatstyle}{boxed}}{%
    \@tufte@info@noline{Switching algorithm float style from \ALG@floatstyle\space to tufte\ALG@floatstyle}%
    \floatstyle{tufte\ALG@floatstyle}%
    \restylefloat{algorithm}%
  }{}%
}

%\RequirePackage[newfloat]{minted}
%\newminted{c}{mathescape, linenos=true, numberblanklines=false, fontsize=\footnotesize}
%\newminted{sage}{mathescape, linenos=true, numberblanklines=false, fontsize=\footnotesize}


%\newenvironment{clisting}{\captionsetup{type=listing}}{}
%\SetupFloatingEnvironment{listing}{name=Code}

% make listings numbers non-copy-able
%\RequirePackage{accsupp}
%\newcommand{\noncopynumber}[1]{%
%    \BeginAccSupp{method=escape,ActualText={}}
%    #1
%    \EndAccSupp{}
%}


%%%=====================================================================================
%%% ToC, ToF and ToT Styling %%%
%%%=====================================================================================


%%% ToC, ToF and ToT styling %%%
\renewcommand{\chaptitlefont}{\huge\rmfamily\itshape\color{darkgray}}
%%% For ToC
\renewcommand*{\aftertoctitle}{\par\nobreak\vspace*{-10pt}\hrulefill\vskip\baselineskip}
%%% For ToF and ToT
\renewcommand*{\afterchaptertitle}{\par\nobreak\vspace*{-10pt}\hrulefill\vskip\afterchapskip}

\RequirePackage{ragged2e}
\settocdepth{section}

\renewcommand{\cftpartfont}{%
\bfseries\color{Burgundy}\MakeTextUppercase%
}
\settocpreprocessor{part}{%
\let\tempf@rtoc\f@rtoc%
\def\f@rtoc{%
\texorpdfstring{\MakeTextUppercase{\tempf@rtoc}}{\tempf@rtoc}}%
}

\renewcommand{\cftpartformatpnum}[1]{\small #1}
\renewcommand{\cftchapterformatpnum}[1]{\small #1}
\renewcommand{\cftsectionformatpnum}[1]{\small #1}
\renewcommand{\cftsubsectionformatpnum}[1]{\small #1}
\renewcommand{\cftchapterafterpnum}{\vspace{2pt}}
\renewcommand{\cftsectionafterpnum}{\vspace{2pt}}
\renewcommand{\cftsubsectionafterpnum}{\vspace{2pt}}

\renewcommand{\cftchapterfont}{%
\scshape\MakeTextLowercase%
}
\settocpreprocessor{chapter}{%
\let\tempf@rtoc\f@rtoc%
\def\f@rtoc{%
\texorpdfstring{\MakeTextLowercase{\tempf@rtoc}}{\tempf@rtoc}}%
}

\renewcommand{\cftsectionfont}{\small}

\renewcommand*\cftappendixname{\appendixname\ }

%%%=====================================================================================
%%% Index %%%
%%%=====================================================================================
% An index environment to mimic Tufte's indexes

\RequirePackage{multicol}
\renewenvironment{theindex}{%
  \ifthenelse{\equal{\@tufte@class}{book}}%
    {\chapter{\indexname}}%
    {\section*{\indexname}}%
  \begin{fullwidth}%
  \small%
  \parskip0pt%
  \parindent0pt%
  \let\item\@idxitem%
  \begin{multicols}{3}%
}{%
  \end{multicols}%
  \end{fullwidth}%
}
\renewcommand\@idxitem{\par\hangindent 2em}
\renewcommand\subitem{\par\hangindent 3em\hspace*{1em}}
\renewcommand\subsubitem{\par\hangindent 4em\hspace*{2em}}
\renewcommand\indexspace{\par\addvspace{1.0\baselineskip plus 0.5ex minus 0.2ex}\relax}%
\newcommand{\lettergroup}[1]{}% swallow the letter heading in the index


%%%=====================================================================================
%%% Abbreviations
%%%=====================================================================================

%\RequirePackage{abbrv, delimiters}
\RequirePackage{abbrv}


%%%=====================================================================================
%%% TODO notes
%%%=====================================================================================

\RequirePackage[%
    textsize=small,
    color=green!20!white,
    shadow,
]{todonotes}
\newcommand{\itodo}[1]{\todo[inline]{#1}}


%%%=====================================================================================
%%% References (HyperRef and CleverRef)
%%%=====================================================================================

%%% HyperRef %%%
\RequirePackage[unicode, hyperfootnotes=false, hypertexnames=false]{hyperref}
\hypersetup{%
    linktocpage,
    bookmarksdepth = section,
    colorlinks = true,
    linkcolor = Burgundy,
    urlcolor = Burgundy,
    citecolor = Burgundy,
    %hidelinks,
    %linkcolor = black,
    %urlcolor = black,
    %citecolor = black,
    pdfpagelayout = TwoPageLeft,
    pdfencoding = auto,
}

% Cleveref must be loaded after amsmath
\RequirePackage{amsmath} 

%%% CleverRef %%%
\RequirePackage[capitalise,nameinlink,spanish]{cleveref}

\crefname{table}{Tabla}{Tablas}
\crefname{section}{Sección}{Secciones}
\crefname{subsection}{Sección}{Secciones}
\crefname{subsubsection}{Sección}{Secciones}

\newcommand{\crefName}[1]{\cref{#1} (\nameref{#1})}


%%%=====================================================================================
%%% Theorem environments
%%%=====================================================================================

\RequirePackage{amsthm}

% newtheorems have to be declared after loading cleveref
% https://tex.stackexchange.com/a/19106/37762

\theoremstyle{definition}
\newtheorem{definition}{Definición}
\newtheorem{example}[definition]{Ejemplo}
%\newtheorem{exercise}[definition]{Exercise}
\newtheorem{property}[definition]{Propiedad}
%\newtheorem{question}[definition]{Question}
%\newtheorem{solution}[definition]{Solution}
%
%\theoremstyle{plain}
%\newtheorem{theorem}[definition]{Theorem}
%\newtheorem{proposition}[definition]{Proposition}
%\newtheorem{problem}[definition]{Problem}
%\newtheorem{lemma}[definition]{Lemma}
%\newtheorem{conjecture}[definition]{Conjecture}
%\newtheorem{corollary}[definition]{Corollary}
%\newtheorem*{claim}{Claim}
%\newtheorem{assumption}[definition]{Assumption}
%\newtheorem{hypothesis}[definition]{Hypothesis}
%\newtheorem{heuristic}[definition]{Heuristic}
%
\theoremstyle{remark}
\newtheorem{remark}[definition]{Observación}
\newtheorem{note}[definition]{Nota}
\newtheorem{case}[definition]{Caso}
%
\theoremstyle{plain}
%
\crefname{example}{Ejemplo}{Ejemplos}
%
%\crefname{theorem}{Theorem}{Theorems}
%\crefname{proposition}{Proposition}{Propositions}
%\crefname{problem}{Problem}{Problems}
%\crefname{lemma}{Lemma}{Lemmata}
%\crefname{conjecture}{Conjecture}{Conjectures}
%\crefname{corollary}{Corollary}{Corollaries}
%\crefname{claim}{Claim}{Claims}
%\crefname{assumption}{Assumption}{Assumptions}
%\crefname{hypothesis}{Hypothesis}{Hypotheses}
%\crefname{heuristic}{Heuristic}{Heuristics}

\crefname{property}{Propiedad}{Propiedades}




%%%=====================================================================================
%%% Other macros
%%%=====================================================================================

%%
% A handy command to disable hyphenation for short bits of text.
% Borrowed from Peter Wilson's `hyphenat' package.

\AtBeginDocument{%
  \@ifpackageloaded{hyphenat}{}{%
    \newlanguage\langwohyphens% define a language without hyphenation rules
    \providecommand{\nohyphens}[1]{{\language\langwohyphens #1}}% used for short bits of text
    \providecommand{\nohyphenation}{\language\langwohyphens}% can be used inside environments for longer text
  }%
}

%%
% Prints argument within hanging parentheses (i.e., parentheses that take
% up no horizontal space).  Useful in tabular environments.
\newcommand{\hangp}[1]{\makebox[0pt][r]{(}#1\makebox[0pt][l]{)}}

%%
% Prints an asterisk that takes up no horizontal space.
% Useful in tabular environments.
\newcommand{\hangstar}{\makebox[0pt][l]{*}}


% Prints the month name (e.g., January) and the year (e.g., 2008)
\newcommand{\monthyear}{%
  %\ifcase\month\or January\or February\or March\or April\or May\or June\or
  %July\or August\or September\or October\or November\or
  %December\fi\space\number\year
  \ifcase\month\or Enero\or Febrero\or Marzo\or Abril\or Mayo\or Junio\or
  Julio\or Agosto\or Septiembre\or Octubre\or Noviembre\or
  Deciembre\fi\space\number\year
}


% Prints an epigraph and speaker in sans serif, all-caps type.
\newcommand{\openepigraph}[2]{%
  %\sffamily\fontsize{14}{16}\selectfont
  \begin{fullwidth}
  \sffamily\large
  \begin{doublespace}
  \noindent\allcaps{#1}\\% epigraph
  \noindent\allcaps{#2}% author
  \end{doublespace}
  \end{fullwidth}
}

% Inserts a blank page
\providecommand{\blankpage}{\newpage\hbox{}\thispagestyle{empty}\newpage}


%\RequirePackage{units}

% Typesets the font size, leading, and measure in the form of 10/12x26 pc.
%\newcommand{\measure}[3]{#1/#2$\times$\unit[#3]{pc}}

% Macros for typesetting the documentation
\newcommand{\hlred}[1]{\textcolor{Maroon}{#1}}% prints in red
\newcommand{\hangleft}[1]{\makebox[0pt][r]{#1}}
\newcommand{\hairsp}{\hspace{1pt}}% hair space
\newcommand{\hquad}{\hskip0.5em\relax}% half quad space
\newcommand{\TODO}{\textcolor{red}{\bf TODO!}\xspace}
\renewcommand{\ie}{\textit{i.\hairsp{}e.}\xspace}
\renewcommand{\eg}{\textit{e.\hairsp{}g.}\xspace}
\newcommand{\na}{\quad--}% used in tables for N/A cells
\newcommand{\tuftebs}{\symbol{'134}}% a backslash in tt type in OT1/T1

% Index macros:
\RequirePackage{makeidx}

\newcommand{\doccmdnoindex}[2][]{\texttt{\tuftebs#2}}% command name -- adds backslash automatically (and doesn't add cmd to the index)
\newcommand{\doccmddef}[2][]{%
  \hlred{\texttt{\tuftebs#2}}\label{cmd:#2}%
  \ifthenelse{\isempty{#1}}%
    {% add the command to the index
      \index{#2 command@\protect\hangleft{\texttt{\tuftebs}}\texttt{#2}}% command name
    }%
    {% add the command and package to the index
      \index{#2 command@\protect\hangleft{\texttt{\tuftebs}}\texttt{#2} (\texttt{#1} package)}% command name
      \index{#1 package@\texttt{#1} package}\index{packages!#1@\texttt{#1}}% package name
    }%
}% command name -- adds backslash automatically
\newcommand{\doccmd}[2][]{%
  \texttt{\tuftebs#2}%
  \ifthenelse{\isempty{#1}}%
    {% add the command to the index
      \index{#2 command@\protect\hangleft{\texttt{\tuftebs}}\texttt{#2}}% command name
    }%
    {% add the command and package to the index
      \index{#2 command@\protect\hangleft{\texttt{\tuftebs}}\texttt{#2} (\texttt{#1} package)}% command name
      \index{#1 package@\texttt{#1} package}\index{packages!#1@\texttt{#1}}% package name
    }%
}% command name -- adds backslash automatically
\newcommand{\docopt}[1]{\ensuremath{\langle}\textrm{\textit{#1}}\ensuremath{\rangle}}% optional command argument
\newcommand{\docarg}[1]{\textrm{\textit{#1}}}% (required) command argument
\newenvironment{docspec}{\begin{quotation}\ttfamily\parskip0pt\parindent0pt\ignorespaces}{\end{quotation}}% command specification environment
\newcommand{\docenv}[1]{\texttt{#1}\index{#1 environment@\texttt{#1} environment}\index{environments!#1@\texttt{#1}}}% environment name
\newcommand{\docenvdef}[1]{\hlred{\texttt{#1}}\label{env:#1}\index{#1 environment@\texttt{#1} environment}\index{environments!#1@\texttt{#1}}}% environment name
\newcommand{\docpkg}[1]{\texttt{#1}\index{#1 package@\texttt{#1} package}\index{packages!#1@\texttt{#1}}}% package name
\newcommand{\doccls}[1]{\texttt{#1}}% document class name
\newcommand{\docclsopt}[1]{\texttt{#1}\index{#1 class option@\texttt{#1} class option}\index{class options!#1@\texttt{#1}}}% document class option name
\newcommand{\docclsoptdef}[1]{\hlred{\texttt{#1}}\label{clsopt:#1}\index{#1 class option@\texttt{#1} class option}\index{class options!#1@\texttt{#1}}}% document class option name defined
\newcommand{\docmsg}[2]{\bigskip\begin{fullwidth}\noindent\ttfamily#1\end{fullwidth}\medskip\par\noindent#2}
\newcommand{\docfilehook}[2]{\texttt{#1}\index{file hooks!#2}\index{#1@\texttt{#1}}}
\newcommand{\doccounter}[1]{\texttt{#1}\index{#1 counter@\texttt{#1} counter}}

\endinput