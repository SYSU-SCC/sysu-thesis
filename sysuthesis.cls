\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{sysuthesis}
	[2017/01/05 v0.1 Sun Yat-Sen University undergraduate thesis document class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}
\ProcessOptions\relax
\LoadClass[adobefonts,a4paper,openany,cs4size,hyperref]{ctexbook}
%\LoadClass[winfonts,a4paper,openany,cs4size,hyperref]{ctexbook}%在windows编译且希望使用微软的字体时请把adobefonts改为winfonts
\RequirePackage[margin=1in,headsep=.2in, headheight=2in]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{booktabs}
\RequirePackage{calc}
\RequirePackage{graphicx}
\RequirePackage[labelsep=space]{caption}
\RequirePackage[font=footnotesize]{subcaption}
\RequirePackage{amsmath,amssymb,amsthm}
\RequirePackage{listings}
\RequirePackage{longtable}
\RequirePackage{endnotes}
\RequirePackage[section]{placeins}
\RequirePackage[chinese, onelanguage,linesnumbered,algochapter,ruled,vlined]{packages/algorithm2e}%不需要描述算法时把这行去掉
\RequirePackage{enumitem}
\RequirePackage[bottom]{footmisc}
\RequirePackage{bbm}
\RequirePackage{bm}
\RequirePackage{setspace}
\RequirePackage[notlof,notlot,nottoc,numbib]{tocbibind} %table of content 
\RequirePackage{tocloft}
\RequirePackage{wrapfig}
\RequirePackage{colortbl}
\RequirePackage{xcolor}
\RequirePackage{array}

\AtBeginDocument{ % we setup hyperreferrence here because we get ctitle and cauthor util the begin of document
	\hypersetup{
	colorlinks=true, citecolor=green,
	filecolor=black, linkcolor=black,
	urlcolor=black, CJKbookmarks=true,
	xetex=true, pdftitle={\@ctitle},
	pdfauthor={\@cauthor}, pdfkeywords={\@ckeywords},
	pdfcreator={LaTeX with hyperref package, using SYSU undergraduate Thesis LaTeX Template}}}

\pagestyle{fancy}

% list environment, 
\setlist[enumerate]{nosep}
\renewcommand\labelenumi{\theenumi)}
\setlist[itemize]{nosep}
\setlist[description]{nosep}

% header, footer, footnote setting
\renewcommand{\headrulewidth}{1pt}
\renewcommand{\footrulewidth}{0pt}
\renewcommand{\chaptermark}[1]{ \markboth{#1}{} }
\renewcommand{\thefootnote}{\fnsymbol{footnote}}
\fancypagestyle{plain}{
		\fancyhf{}
		\fancyfoot[C]{\zihao{-5}\thepage}
		\fancyhead[L]{\zihao{-5}\@title}
		\fancyhead[R]{\zihao{-5}\leftmark}
}
\pagestyle{plain}
\fancypagestyle{eAbstract}{\fancyhead[L]{\zihao{-5}\@etitle} }
\fancypagestyle{listoffiguretable}{\fancyhead[R]{\zihao{-5}插图与表格目录}}

% figure and table setting
\renewcommand{\thefigure}{\thechapter-\arabic{figure}}
\setlength\heavyrulewidth{0.2em}
\captionsetup{font=small,format=hang}

% table of content environtment setting, tocloft package
\setcounter{secnumdepth}{2} % depth of toc, 2
\setcounter{tocdepth}{1}
\setlength{\cftbeforetoctitleskip}{30pt} %skip setting
\setlength{\cftbeforelottitleskip}{30pt} 
\setlength{\cftbeforeloftitleskip}{30pt}
\setlength{\cftaftertoctitleskip}{30pt} 
\setlength{\cftafterlottitleskip}{30pt}
\setlength{\cftafterloftitleskip}{30pt}
\setlength{\cftbeforechapskip}{20pt}
\setlength{\cftparskip}{3pt}
\renewcommand{\cfttoctitlefont}{\hfill\zihao{-2}\songti\bfseries} %title font setting 
\renewcommand{\cftlottitlefont}{\hfill\zihao{-2}\songti\bfseries}
\renewcommand{\cftloftitlefont}{\hfill\zihao{-2}\songti\bfseries}
\renewcommand{\cftchapfont}{\zihao{-3}\songti} % chapter entry font
\renewcommand{\cftchappagefont}{\zihao{-3}\songti} % chapter page font 
\renewcommand{\cftsecfont}{\zihao{-4}\songti}% section entry font 
\renewcommand{\cftsecpagefont}{\zihao{-4}\songti}
\renewcommand{\cftsubsecfont}{\zihao{-4}\songti} 
\renewcommand{\cftsubsecpagefont}{\zihao{-4}\songti}
\renewcommand{\cftfigfont}{\zihao{-4}\songti} % list of figure font
\renewcommand{\cftfigpagefont}{\zihao{-4}\songti}
\renewcommand{\cfttabfont}{\zihao{-4}\songti} % list of table font
\renewcommand{\cfttabpagefont}{\zihao{-4}\songti}
\renewcommand{\cftaftertoctitle}{\hfill}
\renewcommand{\cftafterlottitle}{\hfill}
\renewcommand{\cftafterloftitle}{\hfill}
\renewcommand{\cftnodots}{\cftdotsep}% Chapter entry use dots leader in ToC
\renewcommand{\listfigurename}{插图目录}
\renewcommand{\listtablename}{表格目录}
\addtolength{\cftchapnumwidth}{3\ccwd}
\newcommand\mybold[1]{\textit{\textbf{#1}}}

% chinese title is built in
\newcommand\ctitle[1]{\def\@ctitle{#1}}
\newcommand\etitle[1]{\def\@etitle{#1}} % declare variables to store info
\newcommand\cauthor[1]{\def\@cauthor{#1}} % author name in cover
\newcommand\eauthor[1]{\def\@eauthor{#1}}
\newcommand\studentid[1]{\def\@studentid{#1}}
\newcommand\cschool[1]{\def\@cschool{#1}}
\newcommand\cmajor[1]{\def\@cmajor{#1}}
\newcommand\emajor[1]{\def\@emajor{#1}}
\newcommand\cmentor[1]{\def\@cmentor{#1}}
\newcommand\ementor[1]{\def\@ementor{#1}}
\newcommand\ckeywords[1]{\def\@ckeywords{#1}}
\newcommand\ekeywords[1]{\def\@ekeywords{#1}}
\newcommand\cabstract[1]{\def\@cabstract{#1}}
\newcommand\eabstract[1]{\def\@eabstract{#1}}

\newcommand{\norm}[1]{\left\lVert#1\right\rVert}
\newtheoremstyle{dotless}{3pt}{3pt}{\normalfont}{}{\bfseries}{}{ }{}
\theoremstyle{dotless}
\newtheorem{theorem}{{定理}}[chapter]
\newtheorem{proposition}{{命题}}[chapter]
\newtheorem{lemma}{{引理}}[chapter]
\newtheorem{corollary}{{推论}}[chapter]
\newtheorem{definition}{{定义}}[chapter]
\newtheorem{remark}{{注记}}[chapter]
\newtheorem{eg}{例}[chapter]

\renewcommand{\proofname}{{\heiti 证明}}
\renewcommand{\notesname}{{\zihao{-5}\heiti 注释：\hfill}}
%\renewcommand{\bibname}{{\zihao{-5}\heiti 参考文献：}}
\renewcommand{\@biblabel}[1]{[#1]\hfill}

\renewenvironment{proof}[1][\proofname]{\par
  \pushQED{\qed}
  \normalfont \topsep6\p@\@plus6\p@\relax
  \trivlist
  \item[\hskip\labelsep
        \itshape
    #1]\gnorespaces
}{
  \popQED\endtrivlist\@endpefalse
}

\xeCJKsetcharclass{`①}{`⑩}{1}
   \renewcommand{\@fnsymbol}[1]{%
    \ifcase#1\or \text{①}\or \text{②}\or \text{③}\or  \text{④}\or \text{⑤}\or \text{⑥}\or \text{⑦}\or \text{⑧} \or \text{⑨} \or \text{⑩} \else\@ctrerr\fi}
\renewcommand{\theendnote}{\fnsymbol{endnote}}

%
\renewcommand\maketitle{
	\begin{titlepage}
		\begin{center}
			\includegraphics[width=10cm]{image/logo.png}\\
			\songti
			\vspace{\baselineskip}
			\zihao{-0}\textbf{本科生毕业论文（设计）} \\ 
			\zihao{-2}\textbf{\textrm{Undergraduate Graduation Thesis（Design）}}\\
			\vspace{2\baselineskip}

			{\fontsize{15}{10}\selectfont
			\begin{tabular}{l}
				\makebox[2.7cm]{题目 Title:\hfill} \underline{\makebox[8.3cm]{\@ctitle\hfill}}\\\vspace{1pt}\\
				\hspace{2.7cm} \underline{\makebox[8.3cm]{\mbox{}\hfill}}\\
				\vspace{8pt} \\
				院\hspace{0.5\ccwd}系\\ 
				\makebox[4.8cm]{School (Department):\hfill} \underline{\makebox[6.2cm]{\hfill\@cschool\hfill}}\\
				\vspace{8pt} \\
				专\hspace{0.5\ccwd}业\\
				\makebox[1.7cm]{Major:\hfill} \underline{\makebox[9.3cm]{\hfill\@cmajor\hspace{3.3cm}}}\\
				\vspace{8pt} \\
				学生姓名 \\
				\makebox[3.4cm]{Student Name:\hfill} \underline{\makebox[7.6cm]{\hfill\@cauthor\hspace{3cm}}}\\
				\vspace{8pt} \\
				学\hspace{0.5\ccwd}号 \\
				\makebox[3cm]{Student No.:\hfill} \underline{\makebox[8cm]{\hfill\@studentid\hspace{3cm}}}\\
				\vspace{8pt} \\
				指导教师（职 称） \\ 
				\makebox[4cm]{Supervisor (Title):\hfill} \underline{\makebox[7cm]{\hfill\@cmentor\hspace{2.7cm}}}\\
			\end{tabular}
			}
			\vfill
			\zihao{-3}
			{\centering 
				时间： {2016} 年\hspace{0.3cm} {4} 月 \hspace{0.3cm}{24} 日 \\
				Date: {4} Month \hspace{0.3cm}{24} Day \hspace{0.3cm} {2016} Year}
		\end{center}
	\end{titlepage}
}

\newcommand\makedisclaim{
	\CTEXsetup[titleformat={\zihao{-2}\fangsong\bfseries}]{chapter}
	\CTEXsetup[beforeskip={10pt},afterskip={40pt}]{chapter}
	\input{docs/disclaim}
	\thispagestyle{empty}
	\clearpage
 }

\newcommand\makecabstract{
	\CTEXsetup[titleformat={\zihao{8}\songti\bfseries}]{chapter}
	\CTEXsetup[beforeskip={1pt},afterskip={1pt}]{chapter}%-3.5ex plus -1ex minus -.2ex
	\chapter[摘\hspace{\ccwd}要]{} 
	\begin{flushleft}
		\zihao{-4}
		\textbf{论文题目}：\mbox{ }\@ctitle \\
		\textbf{专\hspace{2\ccwd}业}： \mbox{ }\@cmajor \\
		\textbf{学生姓名}：\mbox{ }\@cauthor \\
		\textbf{学\hspace{2\ccwd}号}：\mbox{ }\@studentid \\
		\textbf{指导教师}：\mbox{ }\@cmentor \\
	\end{flushleft}
	
	\begin{center}
		\zihao{-2}\heiti\bfseries 摘\hspace{\ccwd}要
	\end{center}
	\zihao{-4}\linespread{1.5}\selectfont

	\@cabstract
	\paragraph{\textbf{关键词:}}\@ckeywords
}

\newcommand\makeeabstract{
	\CTEXsetup[titleformat={\zihao{8}\bfseries}]{chapter}
	\CTEXsetup[beforeskip={1pt},afterskip={1pt}]{chapter}%-3.5ex plus -1ex minus -.2ex
	\chapter[ABSTRACT]{} 
	
	\begin{flushleft}
		\zihao{-4}
		\makebox[2.6cm]{\textbf{Title:}\hfill} \@etitle\\
		\makebox[2.6cm]{\textbf{Major:}\hfill} \@emajor \\
		\makebox[2.6cm]{\textbf{Name:}\hfill} \@eauthor\\
		\makebox[2.6cm]{\textbf{Student ID:}\hfill} \@studentid \\
		\makebox[2.6cm]{\textbf{Supervisor:}\hfill} \@ementor 
	\end{flushleft}

	\begin{center}
		\zihao{-2}\textbf{Abstract}
	\end{center}
	\zihao{-4}

	\@eabstract

	\paragraph{\textbf{Keywords:}}\@ekeywords
}

\newcommand\makeabstract{
	\makecabstract
	\setcounter{page}{1}
	\makeeabstract
	\thispagestyle{eAbstract}
	\cleardoublepage
}

\newcommand\makelistoffiguretable{
	\clearpage
	\listoffigures%插图目录（不需要则可以把这两行去掉）
	\listoftables
	\thispagestyle{listoffiguretable}
	\clearpage
}

\renewcommand\mainmatter{
	\@mainmattertrue
	\pagenumbering{arabic}
	\fancypagestyle{plain}{
		\fancyhead[R]{\zihao{-5} 第\thechapter 章\mbox{  } \leftmark}
	}
	\pagestyle{plain}
	\CTEXsetup[beforeskip={10pt},afterskip={20pt}]{chapter}
	\CTEXsetup[nameformat={\zihao{-2}\heiti}]{chapter}
	\CTEXsetup[titleformat={\zihao{-2}\heiti}]{chapter}
	\CTEXsetup[format={}]{section}
	\CTEXsetup[nameformat={\zihao{3}\heiti}]{section}
	\CTEXsetup[titleformat={\zihao{3}\heiti}]{section}
	\CTEXsetup[format={}]{subsection}
	\CTEXsetup[nameformat={\zihao{4}\heiti}]{subsection}
	\CTEXsetup[titleformat={\zihao{4}\heiti}]{subsection}
	\zihao{-4}\songti \linespread{1.5}\selectfont
	
}

\renewcommand\backmatter{
	\@mainmatterfalse
	\fancypagestyle{plain}{ \fancyhead[R]{\zihao{-5} \leftmark} }
	\pagestyle{plain}
}

\renewcommand\appendix{\par
	\@mainmattertrue
	\fancypagestyle{plain}{
		\fancyfoot{}
		\fancyhead[R]{\zihao{-5} 附录\thechapter \leftmark}
	}
	\pagestyle{plain}
	\setcounter{chapter}{0}
	\setcounter{section}{0}
	\gdef\@chapapp{\appendixname}
	\gdef\thechapter{\@Alph\c@chapter}
	\gdef\CTEX@prechapter{\CTEX@appendixname}
	\gdef\CTEX@thechapter{\CTEX@appendixnumber}
	\gdef\CTEX@postchapter{}
	\CTEXsetup[format={\centering}]{chapter}
	\CTEXsetup[nameformat={\zihao{-2}\heiti}]{chapter}
	\CTEXsetup[titleformat={\zihao{-2}\heiti}]{chapter}
	\CTEXsetup[format={\centering}]{section}
	\CTEXsetup[nameformat={\zihao{3}\heiti}]{section}
	\CTEXsetup[titleformat={\zihao{3}\heiti}]{section}
	\CTEXsetup[format={}]{subsection}
	\CTEXsetup[nameformat={\zihao{4}\heiti}]{subsection}
	\CTEXsetup[titleformat={\zihao{4}\heiti}]{subsection}
}

\endinput
