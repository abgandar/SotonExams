%%
%% This is file `uosexam.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% uosexam.dtx  (with options: `class')
%%Font change 25 October 2007
%%
%% This file is part of the uosexam class distribution
%%
%% Modified by Alexander Wittig (2019):
%%  - add class option for supplementary exams
%%  - load siunitx package automatically along with all the amsmath packages
%%  - rename the \year command to \examyear (clashes with too many built ins)
%%  - add counter for total marks in each question, the exam and number of questions
%%  - add defaults for front page blurb about the exam paper instructions pre-populated with correct counter values
%%  - modify front page layout to more closely resemble Word layout (minus their shitty spacing)
%%  - modify headers and footers to more closely resemble Word layout 
%%  - add the formulasheet environment
%%  - add the \pmark and \pmarks{} commands to assign partial marks in answers. These are summed up and compared to the total marks for each part.
%%
%% ToDo:
%%  - automatically pre-populate front matter with correct blurb when there are sections in the exam
%%
\NeedsTeXFormat{LaTeX2e}[1996/12/01]
\ProvidesClass{uosexam}[2019/02/04 v1.7 LaTeX document class]
\def\baseclass{book}

% Document class options
\usepackage{ifthen}
\newboolean{supplementary}
\newboolean{withAnswers}
\newboolean{withAEB}
\newboolean{withCF}
\newboolean{withDict}
\newboolean{withCalc}
\DeclareOption{supplementary}{\setboolean{supplementary}{true}}
\DeclareOption{main}{\setboolean{supplementary}{false}}
\DeclareOption{answers}{\setboolean{withAnswers}{true}}
\DeclareOption{no-answers}{\setboolean{withAnswers}{false}}
\DeclareOption{astrobooklet}{\setboolean{withAEB}{true}}
\DeclareOption{no-astrobooklet}{\setboolean{withAEB}{false}}
\DeclareOption{calvertfarrar}{\setboolean{withCF}{true}}
\DeclareOption{no-calvertfarrar}{\setboolean{withCF}{false}}
\DeclareOption{dictionary}{\setboolean{withDict}{true}}
\DeclareOption{no-dictionary}{\setboolean{withDict}{false}}
\DeclareOption{calculator}{\setboolean{withCalc}{true}}
\DeclareOption{no-calculator}{\setboolean{withCalc}{false}}
% set default options
\ExecuteOptions{main,no-astrobooklet,no-answers,calvertfarrar,dictionary,calculator}

% handle passed options
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\baseclass}}
\def\@checkoptions#1#2{
  \edef\@curroptions{\@ptionlist{\@currname.\@currext}}
  \@tempswafalse
  \@tfor\@this:=#2\do{
    \@expandtwoargs\in@{,\@this,}{,\@curroptions,}
    \ifin@ \@tempswatrue \@break@tfor \fi}
  \let\@this\@empty
  \if@tempswa \else \PassOptionsToClass{#1}{\baseclass}\fi
}
\@checkoptions{10pt}{{10pt}{11pt}{12pt}}
\PassOptionsToClass{a4paper}{\baseclass}
\ProcessOptions\relax

\LoadClass{\baseclass}

\usepackage{version,lastpage,fancyhdr}

% Base font Helvetica (required)
\usepackage{fix-cm}
\usepackage[scaled]{helvet}
\renewcommand*\familydefault{\sfdefault}

% set up various headers and footers
\renewcommand{\headrulewidth}{0.0pt}
\fancypagestyle{first}{
    \fancyhf{}
    \fancyfoot[L]{\small Version saved: \today}
    \fancyfoot[C]{\small Copyright~\copyright~{\arabic{examyearplus1}}~\univname}
    \fancyfoot[R]{\small Number of pages:~\pageref{LastPage}}
}
\fancypagestyle{body}{
    \fancyhf{}
    \fancyhead[C]{\Large Page~\thepage~of~\pageref{LastPage}}
    \fancyhead[RO]{\Large \ucode W1}
    \fancyhead[LE]{\Large \ucode W1}
   \fancyfoot[RO]{\Large \textbf{TURN OVER}}
   \fancyfoot[C]{\small Copyright~\copyright~{\arabic{examyearplus1}}~\univname}
}
\fancypagestyle{last}{
    \fancyhf{}
    \fancyhead[C]{\Large Page~\thepage~of~\pageref{LastPage}}
    \fancyhead[RO]{\Large \ucode W1}
    \fancyhead[LE]{\Large \ucode W1}
    \fancyfoot[C]{\Large \textbf{END OF PAPER}}
    \ifthenelse{\totvalue{fsheets} > 0}{
        \fancyfoot[R]{\Large \textbf{Formula sheet overleaf}}
    }{}
}
\fancypagestyle{appendix}{
    \fancyhf{}
    \fancyhead[C]{\Large Page~\thepage~of~\pageref{LastPage}}
    \fancyhead[RO]{\Large \ucode W1}
    \fancyhead[LE]{\Large \ucode W1}
   \fancyfoot[RO]{\Large \textbf{TURN OVER}}
   \fancyfoot[C]{\small Copyright~\copyright~{\arabic{examyearplus1}}~\univname}
}
\fancypagestyle{appendixlast}{
    \fancyhf{}
    \fancyhead[C]{\Large Page~\thepage~of~\pageref{LastPage}}
    \fancyhead[RO]{\Large \ucode W1}
    \fancyhead[LE]{\Large \ucode W1}
   \fancyfoot[C]{\small Copyright~\copyright~{\arabic{examyearplus1}}~\univname}
}

% line spacing and margins
\usepackage{setspace,vmargin}
\singlespacing
\setlength{\parindent}{0pt}
\setlength{\parskip}{2.0ex plus0.5ex minus0.2ex}
\setmarginsrb   { 2.8cm}  % left margin
                        { 2.5cm}  % top margin
                        { 2.8cm}  % right margin
                        { 3.4cm}  % bottom margin
                        {  20pt}  % head height
                        {  25pt}  % head sep
                        {  17pt}  % foot height
                        {  25pt}  % foot sep

% counters
\usepackage{fmtcount, totcount}
\newcounter{examyear}
\newcounter{examyearplus1}
\newcounter{semnumber}
\newtotcounter{sec}
\newcounter{question}[sec]
\regtotcounter{question}
\newtotcounter{questions}
\newtotcounter{questionpages}
\newcounter{subquestion}[question]
\counterwithin*{figure}{question}
\newcounter{answermarks}
\newcounter{marks}[question]
\newtotcounter{totalmarks}
\newtotcounter{fsheets}
\newcounter{submarks}[question]
\renewcommand{\thequestion}{\protect\ifthenelse{\value{sec} > 0}{\Alph{sec}.}{}\arabic{question}}
\newcommand*{\safeNUMBERstringnum}[1]{\ifthenelse{#1>-1}{\NUMBERstringnum{#1}}{??}}

% enumeration labels
\renewcommand{\labelenumi}{(\roman{enumi})}
\renewcommand{\labelenumii}{(\roman{enumii})}

% PDF package
\usepackage[pdfpagemode={UseNone},bookmarks=true,bookmarksopen=false,
   bookmarksopenlevel=0,bookmarksnumbered=true,hypertexnames=false,
   linkcolor={blue},citecolor={blue},urlcolor={red},
   pdfstartview={FitV}, pdfpagelayout={TwoColumnLeft},colorlinks=false,hidelinks]{hyperref}
\pdfstringdefDisableCommands{
   \let\\\space
   \let\spacefactor\space
   \let\@m\space
}

% math packages
\usepackage{amsmath,amsfonts,amssymb,amscd,amsthm,xspace,siunitx}
\theoremstyle{plain}
\newtheorem{example}{Example}[sec]
\newtheorem{theorem}{Theorem}[sec]
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{axiom}[theorem]{Axiom}
\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}
\theoremstyle{remark}
\newtheorem{remark}[theorem]{Remark}

% graphics packages
\usepackage{graphicx, eso-pic, color, colortbl}

% Formula Sheet
\newenvironment{formulasheet}
{
    \pagestyle{appendix}
    \stepcounter{fsheets}
    \setcounter{figure}{0}
    \setcounter{table}{0}
    \renewcommand{\thefigure}{FS.\arabic{figure}}
    \renewcommand{\thetable}{FS.\arabic{table}}
     \begin{center}\textbf{\LARGE Equations and Constants}\end{center}
}
{
    \ifthenelse{\equal{\thepage}{\pageref{LastPage}}}
    {\thispagestyle{appendixlast}}
    {}
    \clearpage
}

% Partial marks (use in answers)
\newcommand{\pmarks}[1]{\addtocounter{answermarks}{#1} {\color{red} \lbrack+#1\rbrack}}
\newcommand{\pmark}{\pmarks{1}}

% Part marks
\renewcommand{\marks}[1]
{
    \hspace*{\fill}
    \nolinebreak[1]
    \hspace*{\fill}
    \ifthenelse{\value{answermarks} = 0 \OR \value{submarks} = 0 \OR \value{submarks} = \value{answermarks}}
    {\textbf{{[#1~marks]}}}
    {{\color{red}\textbf{{[#1~marks]}}}}
    \par
}

% Total question marks
\newcommand{\totalmarks}[1]
{
    \hspace*{\fill}
    \nolinebreak[1]
    \hspace*{\fill}
    \textbf{{[Total: #1~marks]}}\par
}

% Section
\renewcommand{\section}{
     \stepcounter{sec}
     \begin{center}\textbf{\LARGE Section \Alph{sec}}\end{center}
}

% Part of question
\renewcommand{\part}[1][0]{
    \ifthenelse{\value{submarks} > 0}{\marks{\thesubmarks}\setcounter{submarks}{0}}{}
    \addtocounter{submarks}{#1}
    \addtocounter{marks}{#1}
    \item
}

% Parts environment
\newenvironment{parts}{
\begin{enumerate}}
{\ifthenelse{\value{submarks} > 0}{\marks{\thesubmarks}\setcounter{submarks}{0}}{}\end{enumerate}}

% Question environment
\newenvironment{question}[1]{
    \stepcounter{question}
    \stepcounter{questions}
    \newcommand{\totalmark}{#1}
    \textbf{Question~\thequestion}
}
{
    \setcounter{questionpages}{\value{page}}
    \ifthenelse{\equal{\thepage}{\pageref{LastPage}} \OR \equal{\thepage}{\totvalue{questionpages}}}
    {\thispagestyle{last}}
    {}

    \ifthenelse{\value{marks} = 0}       % handle questions without any parts
    {
        \ifthenelse{\value{answermarks} = 0 \OR \totalmark = \value{answermarks}}
        {
            \totalmarks{\totalmark}
        }
        {
            \ClassWarningNoLine{UoSExam}{Answer marks don't add up! (Section \Alph{sec} Question \arabic{question})}
            {\color{red} \totalmarks{\totalmark}}
        }
    }
    {
        \ifthenelse{\value{marks} = \totalmark}
        {
            \totalmarks{\totalmark}
        }
        {
            \ClassWarningNoLine{UoSExam}{Marks don't add up! (Section \Alph{sec} Question \arabic{question})}
            {\color{red} \totalmarks{\totalmark}}
        }
    }
    \addtocounter{totalmarks}{\totalmark}
    \clearpage
}

% Answer environment
\ifthenelse{\boolean{withAnswers}}{
    \renewcommand{\arrayrulewidth}{1pt}
    \newenvironment{answer}
    {
        \begin{flushleft}
        {\vskip 5pt \hrule height 1pt \vskip 0pt\relax}
        \normalsize\bfseries
        \setcounter{answermarks}{0}
    }
    {
        {\vskip 3.4pt \hrule height 1pt \vskip -5.4pt\relax}
        \end{flushleft}
        \ifthenelse{\value{answermarks} = 0 \OR \value{submarks} = 0 \OR \value{submarks} = \value{answermarks}}
        {}
        {
            \ClassWarningNoLine{UoSExam}{Answer marks don't add up! (Section \Alph{sec} Question \arabic{question})}
        }
    }
    \makeatletter
    \ifthenelse{\equal{\thepage}{1}}{
        \AddToShipoutPicture{
            \put(370,350){
            \makebox(0,0){\rotatebox{55}{\textcolor[gray]{0.9}{\fontsize{5cm}{5cm}\fontseries{m}\selectfont{Answers}}}}
            }
        }
    }{}
    \makeatother
}
{\excludeversion{answer}}

% Figures
\usepackage[centerlast,large]{caption}
\setlength{\captionmargin}{20pt}
\renewcommand{\thefigure}{\thequestion.\arabic{figure}}
\renewcommand{\thetable}{\thequestion.\arabic{table}}
\newcommand{\fref}[1]{Figure~\ref{#1}}
\newcommand{\tref}[1]{Table~\ref{#1}}
\newcommand{\eref}[1]{Equation~\ref{#1}}
\newcommand{\sref}[1]{Section~\ref{#1}}
\renewcommand{\topfraction}{0.85}
\renewcommand{\textfraction}{0.1}
\renewcommand{\floatpagefraction}{0.75}
\usepackage[scriptsize]{subfigure}
\usepackage{booktabs,rotating}

% Bibliography
\def\thebibliography#1{
      \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}
      \list{\@biblabel{\@arabic\c@enumiv}}
           {\settowidth\labelwidth{\@biblabel{#1}}
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000
      \sfcode`\.\@m}

     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}
      \endlist}

\reversemarginpar

% Front matter
\newcommand*{\addresses}[1]{\def\addressnames{#1}}
\newcommand*{\university}[1]{\def\univname{#1}}
\newcommand*{\UNIVERSITY}[1]{\def\UNIVNAME{#1}}
\newcommand*{\department}[1]{\def\deptname{#1}}
\newcommand*{\DEPARTMENT}[1]{\def\DEPTNAME{#1}}
\newcommand*{\group}[1]{\def\groupname{#1}}
\newcommand*{\GROUP}[1]{\def\GROUPNAME{#1}}
\newcommand*{\faculty}[1]{\def\facname{#1}}
\newcommand*{\FACULTY}[1]{\def\FACNAME{#1}}
\newcommand*{\subject}[1]{\def\subjectname{#1}}
\newcommand*{\keywords}[1]{\def\keywordnames{#1}}
\newcommand*{\semester}[1]{\setcounter{semnumber}{#1}}
\newcommand*{\duration}[1]{\def\durationmins{#1}}
\newcommand*{\unitcode}[1]{\def\ucode{#1}}
\newcommand*{\unitTitle}[1]{\def\utit{#1}}
\newcommand*{\calculator}[1]{\def\calcoption{#1}}
\newcommand*{\examyear}[1]{\setcounter{examyear}{#1}
                         \setcounter{examyearplus1}{#1}
                         \stepcounter{examyearplus1}
}
\newcommand*{\QtoA}[1]{\def\qtba{#1}}
\newcommand{\NumberOfQuestions}[1]{\def\QTBA{#1}}
\newcommand{\MarkingScheme}[1]{\def\mscheme{#1}}
\newcommand{\instructions}[1]{\def\sinstr{#1}}
\newcommand{\specialInstructions}[1]{\def\sinstrx{#1}}
\newcommand*{\authors}[1]{\def\auths{#1}}

% Set some defaults
\university  {\texorpdfstring{\href{http://www.soton.ac.uk}
                {University of Southampton}}
                {University of Southampton}}
\UNIVERSITY  {\texorpdfstring{\href{http://www.soton.ac.uk}
                {UNIVERSITY OF SOUTHAMPTON}}
                {UNIVERSITY OF SOUTHAMPTON}}
\department  {\texorpdfstring{\href{http://www.ecs.soton.ac.uk}
                {School of Engineering}}
                {School of Engineering}}
\DEPARTMENT  {\texorpdfstring{\href{http://www.ecs.soton.ac.uk}
                {SCHOOL OF ENGINEERING}}
                {SCHOOL OF ENGINEERING}}
\group       {\texorpdfstring{\href{http://www.isis.ecs.soton.ac.uk}
                {Astronautics Group}}
                {Astronautics Group}}
\GROUP       {\texorpdfstring{\href{http://www.isis.ecs.soton.ac.uk}
                {ASTRONAUTICS GROUP}}
                {ASTRONAUTICS GROUP}}
\faculty     {\texorpdfstring{\href{http://www.engineering.soton.ac.uk}
                {Faculty of Engineering and Physical Sciences}}
                {Faculty of Engineering and Physical Sciences}}
\FACULTY     {\texorpdfstring{\href{http://www.engineering.soton.ac.uk}
                {FACULTY OF ENGINEERING AND PHYSICAL SCIENCES}}
                {FACULTY OF ENGINEERING AND PHYSICAL SCIENCES}}
\QtoA{\totvalue{questions}}
\NumberOfQuestions{
\ifthenelse{\totvalue{questions} = -1}{\ClassWarningNoLine{UoSExam}{Rerun LaTeX to obtain correct count of questions!}}{}
\ifthenelse{\qtba > \totvalue{questions}}{\ClassWarningNoLine{UoSExam}{Questions to answer larger than number of questions in exam!}}{}

This paper contains \textbf{\safeNUMBERstringnum{\totvalue{questions}}} \ifthenelse{\totvalue{questions} = 1}{question}{questions}.
%\ifthenelse{\totvalue{sec} > 0}{ in \textbf{\safeNUMBERstringnum{\totvalue{sec}}} sections.}{}

Answer 
\ifthenelse{\qtba = \totvalue{questions}}
    {\textbf{ALL} questions.}
    {\textbf{\safeNUMBERstringnum{\qtba}} of the \textbf{\safeNUMBERstringnum{\totvalue{questions}}} questions.}
}
\MarkingScheme{
\ifthenelse{\totvalue{totalmarks} = -1}{\ClassWarningNoLine{UoSExam}{Rerun LaTeX to obtain correct count of total marks!}}{}
An outline marking scheme is shown in brackets to the right of each question. This exam is marked out of \textbf{\total{totalmarks} marks}.}
\instructions {
    \ifthenelse{\boolean{withCF}}{\framebox[\textwidth]{An Engineering Data Book by Calvert and Farrar is provided}}{}

    \ifthenelse{\boolean{withAEB}}{\framebox[\textwidth]{A University of Southampton astronautics equation booklet is provided}}{}

    \ifthenelse{\totvalue{fsheets} > 0}{Note that a formula sheet with equations and/or numerical constants is provided at the end of this paper.}{}
    
    \ifthenelse{\boolean{withDict}}{A foreign language direct `Word to Word' translation dictionary (paper version ONLY) is permitted, provided it contains no notes, additions or annotations.}{}
}
\specialInstructions {}
\calculator{Only University approved calculators are permitted.}

% Assemble title page
  \renewcommand{\maketitle}{
    \hypersetup{pdftitle={\utit}}
    \hypersetup{pdfsubject={}}
    \hypersetup{pdfauthor={\auths}}
    \hypersetup{pdfkeywords={}}
    \Large
    \thispagestyle{first}
    \UNIVNAME \hfill \ucode W1
    \bigskip
    \rule{\textwidth}{1pt}
    \bigskip
    \ifthenelse{\boolean{supplementary}}
    {SUPPLEMENTARY~EXAMINATION~\arabic{examyear}/\arabic{examyearplus1}}
    {SEMESTER~\arabic{semnumber}~EXAMINATION~\arabic{examyear}/\arabic{examyearplus1}}

    {TITLE: \MakeUppercase{\utit}}

    \bigskip
    {DURATION:~\durationmins~mins}
    \\ \bigskip
    \rule{\textwidth}{1pt}
        {\QTBA\par}
        {\mscheme\par}
        \vspace{1cm}
        {\sinstr\par\sinstrx\par}
        \ifthenelse{\boolean{withCalc}}{
            \vspace{1cm}
            {\calcoption\par}
        }{}
    \vfill
    \newpage
    \pagestyle{body}

    % doesn't seem to work if done earlier:
    \sisetup{detect-all = true, detect-inline-weight = math, detect-inline-family = math, detect-display-math = true, math-rm = \mathrm}

    \clearpage
  }

\endinput
%%
%% End of file `uosexam.cls'.
