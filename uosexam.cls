%%
%% This is file `uosexam.cls',
%%
%% This file is based on the uosexam class distribution
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
%%  - align table and figure captions with faculty guidelines
%%  - add LuaTeX with basic linear algebra support
%%
%% ToDo:
%%  - automatically pre-populate front matter with correct blurb when there are sections in the exam
%%
\NeedsTeXFormat{LaTeX2e}[1996/12/01]
\ProvidesClass{uosexam}[2019/02/04 v1.7 LaTeX document class]
\def\baseclass{book}

% Document class options
\usepackage{ifthen}
\newboolean{draft}
\newboolean{supplementary}
\newboolean{withAnswers}
\newboolean{withAEB}
\newboolean{withCF}
\newboolean{withDict}
\newboolean{withCalc}
\DeclareOption{draft}{\setboolean{draft}{true} \PassOptionsToClass{\CurrentOption}{\baseclass}}
\DeclareOption{final}{\setboolean{draft}{false}}
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
\ExecuteOptions{main,final,no-astrobooklet,no-answers,calvertfarrar,dictionary,calculator}

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
\@checkoptions{11pt}{{10pt}{11pt}{12pt}}
\PassOptionsToClass{a4paper}{\baseclass}
\ProcessOptions\relax

\LoadClass{\baseclass}

\usepackage[aux]{rerunfilecheck}
\usepackage{version,lastpage,fancyhdr,fix-cm,ifluatex,framed}

\ifluatex
    \usepackage{fontspec}
    \setsansfont{TeX Gyre Heros} % Helvetica replacement, requires TeXLive fonts to be available in operating system
    \usepackage{luacode,luapackageloader}
\else
    \usepackage[scaled]{helvet}
\fi

% Set base font to Helvetica
\renewcommand*\familydefault{\sfdefault}

% set up various headers and footers
\renewcommand{\headrulewidth}{0.0pt}
\fancypagestyle{first}{
    \fancyhf{}
    \fancyfoot[L]{\small Saved: \today}
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
\usepackage[pdfpagemode={UseNone}, bookmarks=true, bookmarksopen=false,
   bookmarksopenlevel=0, bookmarksnumbered=true, hypertexnames=false,
   pdfstartview={FitV}, pdfpagelayout={TwoColumnLeft}, hidelinks, unicode = true]{hyperref}
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

% Print either "mark" or "marks" depending on count
\newcommand{\markword}[1]
{%
    \ifthenelse{#1 = 1}{mark}{marks}%
}

% Print part marks
\renewcommand{\marks}[1]
{
    \hspace*{\fill}
    \nolinebreak[1]
    \hspace*{\fill}
    \ifthenelse{\value{answermarks} = 0 \OR \value{submarks} = 0 \OR \value{submarks} = \value{answermarks}}
    {\textbf{{[#1~\markword{#1}]}}}
    {{\color{red}\textbf{{[#1~\markword{#1}]}}}}
    \par
}

% Print total question marks
\newcommand{\totalmarks}[1]
{
    \hspace*{\fill}
    \nolinebreak[1]
    \hspace*{\fill}
    \textbf{{[Total: #1~\markword{#1}]}}\par
}

% Section
\renewcommand{\section}{
     \stepcounter{sec}
     \begin{center}\textbf{\LARGE Section \Alph{sec}}\end{center}
}

% Part of question (* variant doesn't count marks towards question total)
%\makeatletter
\renewcommand{\part}{%
             \@ifstar
                  \partStar%
                  \partNormal%
%\makeatother
}

% Special part of question (marks not counted, e.g. bonus question)
\newcommand{\partStar}[1][0]{
    \ifthenelse{\value{submarks} > 0}{\marks{\thesubmarks}\setcounter{submarks}{0}\pagebreak[1]}{}		%  includes slight hint to break page before starting a new part
    \addtocounter{submarks}{#1}
    \item
}

% Normal part of question (marks count towards question total)
\newcommand{\partNormal}[1][0]{
    \addtocounter{marks}{#1}
    \partStar[#1]
}

% Parts environment
\newenvironment{parts}{
\begin{enumerate}}
{\ifthenelse{\value{submarks} > 0}{\marks{\thesubmarks}\setcounter{submarks}{0}}{}\end{enumerate}}

% Special question environment without counting marks (e.g. bonus questions)
% Note: there's no need to (but also no harm in) using \part* within a bonus question.
\newenvironment{question*}[1]{
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
    \clearpage
}

% Normal question environment (marks count towards exam total)
\newenvironment{question}[1]{
    \begin{question*}{#1}
}
{
    \addtocounter{totalmarks}{\totalmark}
    \end{question*}
}

% Redefined \pagebreak command to print marks of open parts if needed before breaking
\def\aroundto#1#2#3{\toks0={#2}\toks1=\expandafter{#1}\toks2={#3}\edef#1{\the\toks0 \the\toks1 \the\toks2}}
\aroundto\pagebreak{\ifthenelse{\value{submarks} > 0}{\marks{\thesubmarks}\setcounter{submarks}{0}}{}}{}

% Answer environment
\ifthenelse{\boolean{withAnswers}}{
    \renewcommand{\arrayrulewidth}{1pt}
    \newenvironment{answer}
    {
        % in case someone adds tables or figures in the answers, make sure they are counted within the answer section and don't interfere with counting outside
        \edef\oldtablecount{\arabic{table}}
        \edef\oldfigurecount{\arabic{figure}}
        \setcounter{table}{100}
        \setcounter{figure}{100}
        \setcounter{answermarks}{0}
        \begin{flushleft}
        {\vskip 5pt \hrule height 1pt \vskip 0pt\relax}
        \normalsize\bfseries
    }
    {
        \vskip 3.4pt \hrule height 1pt \vskip -5.4pt\relax
        \end{flushleft}
        \setcounter{table}{\oldtablecount}
        \setcounter{figure}{\oldfigurecount}
        \ifthenelse{\value{answermarks} = 0 \OR \value{submarks} = 0 \OR \value{submarks} = \value{answermarks}}
        {}
        {
            \ClassWarningNoLine{UoSExam}{Answer marks don't add up! (Section \Alph{sec} Question \arabic{question})}
        }
    }
}
{\excludeversion{answer}}

% Add background
\ifthenelse{\( \boolean{draft} \OR \boolean{withAnswers} \) \AND \( \value{page}=1 \)}
{
    \AddToShipoutPicture{
        \put(370,350){
            \makebox(0,0){
                \rotatebox{55}{
                    \textcolor[gray]{0.8}{
                        \fontsize{5cm}{5cm}\fontseries{m}\selectfont
                        \ifthenelse{\boolean{draft}}{Draft}{}
                        \ifthenelse{\boolean{withAnswers}}{Answers}{}
                    }
                }
            }
        }
    }
}
{}

% Figures (something is strange with the font sizes, they all need to be Large to match body text)
\usepackage{floatrow}
\floatsetup[figure]{font=Large}
\floatsetup[table]{style=plaintop,font=Large}
\usepackage[centerlast,Large,bf]{caption}
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
\newcommand*{\university}[1]{\def\univname{#1}}
\newcommand*{\UNIVERSITY}[1]{\def\UNIVNAME{#1}}
\newcommand*{\subject}[1]{\def\subjectname{#1}}
\newcommand*{\semester}[1]{\setcounter{semnumber}{#1}}
\newcommand*{\duration}[1]{\def\durationmins{#1}}
\newcommand*{\unitcode}[1]{\def\ucode{#1}}
\newcommand*{\unitTitle}[1]{\def\utit{#1}}
\newcommand*{\calculator}[1]{\def\calcoption{#1}}
\newcommand*{\examyear}[1]{\setcounter{examyear}{#1}
                         \setcounter{examyearplus1}{#1}
                         \stepcounter{examyearplus1}
}
\newcommand*{\authors}[1]{\def\auths{#1}}
\newcommand*{\QtoA}[1]{\def\qtba{#1}}
\newcommand{\NumberOfQuestions}[1]{\def\QTBA{#1}}
\newcommand{\MarkingScheme}[1]{\def\mscheme{#1}}
\newcommand{\specialMarkingScheme}[1]{\def\smscheme{#1}}
\newcommand{\provided}[1]{\def\sprov{#1}}
\newcommand{\specialProvided}[1]{\def\sprovx{#1}}
\newcommand{\instructions}[1]{\def\sinstr{#1}}
\newcommand{\specialInstructions}[1]{\def\sinstrx{#1}}
\newcommand{\isprovided}[1]{\framebox[\textwidth]{\parbox{\textwidth}{\centering {#1}}}\par}

% Set some defaults
\university  {\texorpdfstring{\href{http://www.soton.ac.uk}
                {University of Southampton}}
                {University of Southampton}}
\UNIVERSITY  {\texorpdfstring{\href{http://www.soton.ac.uk}
                {UNIVERSITY OF SOUTHAMPTON}}
                {UNIVERSITY OF SOUTHAMPTON}}
\QtoA{\totvalue{questions}}
\NumberOfQuestions{
\ifthenelse{\totvalue{questions} = -1}{\ClassWarningNoLine{UoSExam}{Rerun LaTeX to obtain correct count of questions!}}{}
\ifthenelse{\qtba > \totvalue{questions}}{\ClassWarningNoLine{UoSExam}{Questions to answer larger than number of questions in exam!}}{}
\par
This paper contains \textbf{\safeNUMBERstringnum{\totvalue{questions}}} \ifthenelse{\totvalue{questions} = 1}{question}{questions}.
%\ifthenelse{\totvalue{sec} > 0}{ in \textbf{\safeNUMBERstringnum{\totvalue{sec}}} sections.}{}
%\@for\@i:={\qtba}\do{    {\@i} questions in section.  } 				%\expandafter
\par
Answer 
\ifthenelse{\qtba = \totvalue{questions}}
    {\textbf{ALL} questions.}
    {\textbf{\safeNUMBERstringnum{\qtba}} of the \textbf{\safeNUMBERstringnum{\totvalue{questions}}} questions.}
}
\MarkingScheme{
\ifthenelse{\totvalue{totalmarks} = -1}{\ClassWarningNoLine{UoSExam}{Rerun LaTeX to obtain correct count of total marks!}}{}
An outline marking scheme is shown in brackets to the right of each question. This exam is marked out of \textbf{\total{totalmarks} marks}.
}
\provided{
    \ifthenelse{\boolean{withCF}}{\isprovided{An Engineering Data Book by Calvert and Farrar is provided}}{}
    \ifthenelse{\boolean{withAEB}}{\isprovided{A University of Southampton astronautics equation booklet is provided}}{}
}
\instructions{
    \ifthenelse{\totvalue{fsheets} > 0}{Note that a formula sheet with equations and/or numerical constants is provided at the end of this paper.\par}{}
    \ifthenelse{\boolean{withDict}}{A foreign language direct `Word to Word' translation dictionary (paper version ONLY) is permitted, provided it contains no notes, additions or annotations.\par}{}
}
\specialMarkingScheme{}
\specialProvided{}
\specialInstructions{}
\calculator{Only University approved calculators are permitted.}

% Assemble title page
\renewcommand{\maketitle}{
    \hypersetup{pdftitle={\utit}, pdfauthor={\auths}}
    \Large
    \thispagestyle{first}
    \UNIVNAME \hfill \ucode W1
    \bigskip
    \rule{\textwidth}{1pt}
    \bigskip
    \ifthenelse{\boolean{supplementary}}
    {SUPPLEMENTARY~EXAMINATION~\arabic{examyear}/\arabic{examyearplus1}}
    {SEMESTER~\arabic{semnumber}~EXAMINATION~\arabic{examyear}/\arabic{examyearplus1}}%
    \ifthenelse{\boolean{withAnswers}}
    { -- ANSWERS}
    {}

    {TITLE: \MakeUppercase{\utit}}

    \bigskip
    {DURATION:~\durationmins~mins}
    \\ \bigskip
    \rule{\textwidth}{1pt}
        {\QTBA\par}
        {\mscheme\par\smscheme\par}
        \vspace{1cm plus 0cm minus 0.4cm}
        {\sprov\par\sprovx\par}
        {\sinstr\par\sinstrx\par}
        \ifthenelse{\boolean{withCalc}}{
            \vspace{1cm plus 0cm minus 0.4cm}
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
