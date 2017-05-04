% 定义模板样式
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{sysuthesis}[2017/05/02 v4.4.0 Sun Yat-Sen University undergraduate thesis document class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}
\ProcessOptions\relax

\LoadClass[
  %fontset=adobe,
  fontset=fandol,  % texlive自带，可移植字体库，只有常用的6763个汉字
  %fontset=ubuntu,
  %fontset=mac,
  %fontset=windows,
  a4paper,
  %openright,
  openany,
  zihao=-4
]{ctexbook}

% 配置英文字体
\RequirePackage{fontspec}
\setmainfont{Times New Roman}

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
\RequirePackage[section]{placeins}
\RequirePackage[chinese, onelanguage,linesnumbered,algochapter,ruled,vlined]{packages/algorithm2e}
\RequirePackage{enumitem}
\RequirePackage{bbm}
\RequirePackage{bm}
\RequirePackage[notlof,notlot,nottoc,numbib]{tocbibind} %table of content
\RequirePackage{tocloft}
\RequirePackage{wrapfig}
\RequirePackage{colortbl}
\RequirePackage{xcolor}
\RequirePackage{array}
\RequirePackage{makecell}
\RequirePackage[bottom, perpage]{footmisc}
\RequirePackage{setspace}

% Insert a TRUE blank page which has no header or footer
\let\origdoublepage\cleardoublepage
\newcommand{\clearemptydoublepage}{
  \clearpage{
    \pagestyle{empty}
    \origdoublepage
  }
}

% 设定时间为中文日期
\ctexset{today=small}

\AtBeginDocument{
  \hypersetup{
    citecolor=green,
    filecolor=black,
    linkcolor=black,
    urlcolor=black,
    CJKbookmarks=true,
    pdftitle={\@ctitle},
    pdfauthor={\@cauthor},
    pdfkeywords={\@ckeywords},
    pdfcreator={LaTeX with hyperref package, using SYSU undergraduate Thesis LaTeX Template}
  }
}
\pagestyle{fancy}

% list environment,
\setlist[enumerate]{nosep}
\renewcommand\labelenumi{\theenumi}
\setlist[itemize]{nosep}
\setlist[description]{nosep}

% 页眉、页脚、脚注设定
\renewcommand{\headrulewidth}{1pt}
\renewcommand{\footrulewidth}{0pt}
\renewcommand{\chaptermark}[1]{ \markboth{#1}{} }
% 采用带圈数字符号代替*号脚注
\xeCJKsetcharclass{`①}{`⑩}{1}
% 默认页面页眉页脚样式
\fancypagestyle{plain}{
  \fancyhf{}
  \fancyfoot[C]{\zihao{-5}\thepage} % 页码位于页脚居中

  % 左右两栏页眉，左为论文题目右为当前章
  \fancyhead[L]{\zihao{-5}\@ctitle}
  \fancyhead[R]{\zihao{-5}\leftmark}

  % 居中式页眉，可以选择为论文题目或当前章
  %\fancyhead[C]{\zihao{-5}\@ctitle}
  %\fancyhead[C]{\zihao{-5}\leftmark}
}
\pagestyle{plain}

% 中英文摘要页面样式
\fancypagestyle{cAbstract}{
  \fancyhead[L]{\zihao{-5}\@ctitle}
  \fancyhead[R]{\zihao{-5}摘要}
}
\fancypagestyle{eAbstract}{
  \fancyhead[L]{\zihao{-5}\@etitle}
  \fancyhead[R]{\zihao{-5}ABSTRACT}
}

\fancypagestyle{listoffiguretable}{\fancyhead[R]{\zihao{-5}插图与表格目录}}

% figure and table setting
\renewcommand{\thefigure}{\thechapter-\arabic{figure}}
\setlength\heavyrulewidth{0.2em}
\captionsetup{font=small,format=hang}


% 目录设定，使用tocloft宏包
\setcounter{secnumdepth}{2} % depth of toc, 2
\setcounter{tocdepth}{1}

% 目录标题：3号宋体加粗
\renewcommand{\cfttoctitlefont}{\hfill\zihao{3}\songti\bfseries}
\renewcommand{\cftlottitlefont}{\hfill\zihao{3}\songti\bfseries}
\renewcommand{\cftloftitlefont}{\hfill\zihao{3}\songti\bfseries}

% 目录中章节标题：四号黑体
\renewcommand{\cftchapfont}{\zihao{4}\heiti}
\renewcommand{\cftchappagefont}{\zihao{4}\heiti}

% 目录中其他内容：小四号宋体
\renewcommand{\cftsecfont}{\zihao{-4}\songti}
\renewcommand{\cftsecpagefont}{\zihao{-4}\songti}
\renewcommand{\cftsubsecfont}{\zihao{-4}\songti}
\renewcommand{\cftsubsecpagefont}{\zihao{-4}\songti}
\setlength{\cftsecindent}{2.3em}    % 小节缩进, 对齐章标题空隙

% 插图目录
\renewcommand{\listfigurename}{插图目录}
\renewcommand{\cftfigfont}{\zihao{-4}\songti}
\renewcommand{\cftfigpagefont}{\zihao{-4}\songti}

% 表格目录
\renewcommand{\listtablename}{表格目录}
\renewcommand{\cfttabfont}{\zihao{-4}\songti}
\renewcommand{\cfttabpagefont}{\zihao{-4}\songti}

\renewcommand{\cftaftertoctitle}{\hfill}
\renewcommand{\cftafterlottitle}{\hfill}
\renewcommand{\cftafterloftitle}{\hfill}
\renewcommand{\cftnodots}{\cftdotsep}   % 使用点指示页数

\addtolength{\cftchapnumwidth}{3\ccwd}
\newcommand\mybold[1]{\textit{\textbf{#1}}}

% 相关信息宏定义
\newcommand\ctitle[1]{\def\@ctitle{#1}}
\newcommand\etitle[1]{\def\@etitle{#1}} % declare variables to store info
\newcommand\covertitlefirst[1]{\def\@covertitlefirst{#1}}
\newcommand\covertitlesecond[1]{\def\@covertitlesecond{#1}}
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
\newtheoremstyle{dotless}{3pt}{3pt}{\kaishu}{2em}{\heiti}{}{\ccwd}{}
\theoremstyle{dotless}
\newtheorem{theorem}{{定理}}[chapter]
\newtheorem{proposition}{{命题}}[chapter]
\newtheorem{lemma}{{引理}}[chapter]
\newtheorem{corollary}{{推论}}[chapter]
\newtheorem{definition}{{定义}}[chapter]
\newtheorem{remark}{{注记}}[chapter]
\newtheorem{eg}{例}[chapter]

\renewcommand{\proofname}{{\heiti 证明}}
\renewcommand{\@biblabel}[1]{[#1]\hfill}

\renewenvironment{proof}[1][\proofname]{\par
  \pushQED{\qed}
  \kaishu \topsep6\p@\@plus6\p@\relax
  \trivlist
  \item[\hskip\labelsep
        \itshape
    #1]\ignorespaces
}{
  \popQED\endtrivlist\@endpefalse
}

% 参考文献引用标记格式：右上角，带方括号
\RequirePackage[square,super]{natbib}

\renewcommand\maketitle {
  \begin{titlepage}
    \begin{center}
      \includegraphics[width=10cm]{image/SYSULogo} \\
      \songti
      \vspace{\baselineskip}
      \zihao{-0}\textbf{本科生毕业论文（设计）} \\
      \zihao{2}\textbf{\textrm{Undergraduate Graduation Thesis（Design）}} \\
      \vspace{2\baselineskip}

      {\fontsize{15}{10}\selectfont
      \begin{tabular}{l}
          \makebox[2.7cm]{题目 Title:\hfill} \underline{\makebox[8.3cm]{\hfill\zihao{3}\textbf\@covertitlefirst\hfill}}\\\vspace{1pt}\\
          \makebox[2.7cm]{\hfill} \underline{\makebox[8.3cm]{\hfill\zihao{3}\textbf\@covertitlesecond\hfill}}\\\vspace{1pt}\\
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
          \makebox[4cm]{Supervisor (Title):\hfill} \underline{\makebox[7cm]{\hfill\@cmentor\hspace{2.7cm}}}
      \end{tabular}
      }
      \vfill

      \zihao{-3}
      {\centering
        \hspace{2\ccwd}时间：\today   \\ % 使用最后一次编译的日期, 实现日期的自动化
        Date:\hspace{0.5\ccwd} Month\hspace{2\ccwd} Day\hspace{1\ccwd} Year
      }

    \end{center}
  \end{titlepage}
  %\clearemptydoublepage   % 空白页
}

% 下面是更好的封面，但不符合学校要求，暂且注释保留
% \renewcommand\maketitle {
%   \begin{titlepage}
%     \begin{center}
%       \includegraphics[width=10cm]{image/SYSULogo} \\
%       \songti
%       \vspace{\baselineskip}
%       \zihao{-0}\textbf{本科生毕业论文（设计）} \\
%       \zihao{-2}\textbf{\textrm{Undergraduate Graduation Thesis（Design）}} \\
%       \vspace{2\baselineskip}
%
%       \zihao{3}\textbf{\@title}
%       \vspace{2\baselineskip}
%
%       {\fontsize{15}{10}\selectfont
%       \begin{tabular}{l}
%         \makebox[4.8cm]{院\hspace{2\ccwd}系:} \underline{\makebox[15em]{\hfill\@cschool\hfill}} \\
%         \makebox[4.8cm]{School (Department)} \\
%         \vspace{8pt} \\
%
%         \makebox[4.8cm]{专\hspace{2\ccwd}业:} \underline{\makebox[15em]{\hfill\@cmajor\hfill}} \\
%         \makebox[4.8cm]{Major} \\
%         \vspace{8pt} \\
%
%         \makebox[4.8cm]{学生姓名:} \underline{\makebox[15em]{\hfill\@cauthor\hfill}} \\
%         \makebox[4.8cm]{Student Name} \\
%         \vspace{8pt} \\
%
%         \makebox[4.8cm]{学\hspace{2\ccwd}号:} \underline{\makebox[15em]{\hfill\@studentid\hfill}} \\
%         \makebox[4.8cm]{Student No.} \\
%         \vspace{8pt} \\
%
%         \makebox[4.8cm]{指导教师(职 称):} \underline{\makebox[15em]{\hfill\@cmentor\hfill}} \\
%         \makebox[4.8cm]{Supervisor (Title)} \\
%       \end{tabular}
%       }
%       \vfill
%
%       \zihao{-3}
%       {\centering
%         时间: \today    % 使用最后一次编译的日期, 实现日期的自动化
%       }
%     \end{center}
%   \end{titlepage}
%   \clearpage
%   %\clearemptydoublepage   % 空白页
% }

\newcommand\makedisclaim{
  \ctexset {
    chapter = {
      titleformat = {\zihao{-2}\fangsong\bfseries},
      beforeskip = {10pt},
      afterskip = {40pt}
    }
  }
  \input{docs/disclaim}
  \thispagestyle{empty}
  \clearpage
  %\clearemptydoublepage   % 空白页
}

% 中文摘要、关键字标题：5号黑体并加方括号
% 中文摘要、关键字内容：5号楷体
\newcommand\makecabstract{
  \ctexset{
    section = {
      titleformat = {\zihao{4}\heiti},
      beforeskip = {10pt},
      afterskip = {20pt}
    }
  }

  % 使用隐藏目录项的section及添加为chapter形式目录的方法来去掉在openright环境中中英文摘要间出现空白页的情况
  %\section*{摘\hspace{\ccwd}要}
  %\addcontentsline{toc}{chapter}{摘\hspace{\ccwd}要}

  % 有些老师要求摘要前添加论文题目信息，因此保留此项
  %\begin{flushleft}
  %  \zihao{-4}
  %  \textbf{论文题目}：\mbox{ }\@ctitle \\
  %  \textbf{专\hspace{2\ccwd}业}： \mbox{ }\@cmajor \\
  %  \textbf{学生姓名}：\mbox{ }\@cauthor \\
  %  \textbf{学\hspace{2\ccwd}号}：\mbox{ }\@studentid \\
  %  \textbf{指导教师}：\mbox{ }\@cmentor \\
  %\end{flushleft}

  \zihao{5}\kaishu
  \paragraph{\zihao{5}\heiti\textbf{[摘\hspace{\ccwd}要]}}
  \@cabstract
  \paragraph{\zihao{5}\heiti[关键词]}\@ckeywords
}

% 英文摘要、关键字标题：小四号新罗马体(Time New Roman)加粗并加方括号
% 英文摘要、关键字内容：小四号新罗马体(Time New Roman)
\newcommand\makeeabstract{
  \ctexset{
    section = {
      titleformat = {\zihao{4}\bfseries},
      beforeskip = {10pt},
      afterskip = {20pt}
    }
  }

  %\section*{ABSTRACT}
  %\addcontentsline{toc}{chapter}{ABSTRACT}

  %\begin{flushleft}
  %  \zihao{-4}
  %  \makebox[2.6cm]{\textbf{Title:}\hfill} \@etitle\\
  %  \makebox[2.6cm]{\textbf{Major:}\hfill} \@emajor \\
  %  \makebox[2.6cm]{\textbf{Name:}\hfill} \@eauthor\\
  %  \makebox[2.6cm]{\textbf{Student ID:}\hfill} \@studentid \\
  %  \makebox[2.6cm]{\textbf{Supervisor:}\hfill} \@ementor
  %\end{flushleft}

  \zihao{-4}
  \paragraph{\textbf{[Abstract]}}
  \@eabstract
  \paragraph{\textbf{[Keywords]}}\@ekeywords
}

\newcommand\makeabstract{
  \setcounter{page}{1}
  \makecabstract
  \thispagestyle{cAbstract}
  \clearpage

  \makeeabstract
  \thispagestyle{eAbstract}
  \clearpage
  %\cleardoublepage
}

\newcommand\makelistoffiguretable{
  \clearpage
  \listoffigures
  \listoftables
  \thispagestyle{listoffiguretable}
  \cleardoublepage
}

\renewcommand\mainmatter{
  \@mainmattertrue
  \pagenumbering{arabic}
  \ctexset {
    chapter = {
      %fixskip = true,
      beforeskip = {10pt},
      afterskip = {20pt},
      format = {\centering},
      nameformat = {\zihao{4}\heiti},
      titleformat = {\zihao{4}\heiti}
    },
    section = {
      %fixskip = true,
      beforeskip = {20pt},
      afterskip = {10pt},
      format = {},
      nameformat = {\zihao{4}\heiti},
      titleformat = {\zihao{4}\heiti}
    },
    subsection = {
      %fixskip = true,
      beforeskip = {20pt},
      afterskip = {10pt},
      format = {},
      nameformat = {\zihao{4}\heiti},
      titleformat = {\zihao{4}\heiti}
    }
  }

  \zihao{-4}\songti \linespread{1.5}\selectfont
}

\renewcommand\backmatter{
  \@mainmatterfalse
  \fancypagestyle{plain}{ \fancyhead[R]{\zihao{-5} \leftmark} }
  \pagestyle{plain}
}

% 参考文献
% 标题小五号黑体加冒号
% 内容小五号宋体
\newcommand\makereferences{
  \begingroup
    \ctexset {
      chapter = {
        aftertitle = {：},
        format = {},
        titleformat = {\zihao{-5}\heiti}
      }
    }

    % 引用样式
    %\bibliographystyle{ieeetr}     % 国际标准样式
    \bibliographystyle{gbt7714-2005}  % 国标文后参考文献著录规则
    %\bibliographystyle{sysuthesis}   % 历史遗留模板
    {\zihao{-5}\rmfamily\bibliography{main}}  % 引用文献列表
  \endgroup
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
  \gdef\CTEX@prechapter{\CTEX@preappendix}
  \gdef\CTEX@thechapter{\CTEX@appendix@number}
  \gdef\CTEX@postchapter{}
  \ctexset {
    chapter = {
      format = {\centering},
      nameformat = {\zihao{4}\heiti},
      titleformat = {\zihao{4}\heiti},
    },
    section = {
      format = {\centering},
      nameformat = {\zihao{4}\heiti},
      titleformat = {\zihao{4}\heiti}
    },
    subsection = {
      format = {\centering},
      nameformat = {\zihao{4}\heiti},
      titleformat = {\zihao{4}\heiti}
    }
  }
}

% 配置超链接。
% hyperref一般要求是导言区最后一个宏包，才能正常工作
% 若把该宏包提前，则会引起附录列表跳转到第一章的问题
% TODO: 重构宏包引入顺序以让代码语义聚集
\RequirePackage[hidelinks, hyperfootnotes=true]{hyperref}
\RequirePackage{footnotebackref}

\renewcommand{\@fnsymbol}[1]{
  \ifcase#1\or \text{①}\or \text{②}\or \text{③}\or  \text{④}\or \text{⑤}\or \text{⑥}\or \text{⑦}\or \text{⑧} \or \text{⑨} \or \text{⑩}
  \else
    \@ctrerr
  \fi
}
\renewcommand{\thefootnote}{\fnsymbol{footnote}}
