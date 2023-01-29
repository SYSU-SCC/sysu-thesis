% 定义模板样式
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{sysupptthesis}[2022/01/18 v1.0.0 Sun Yat-Sen University undergraduate thesis presentation class]

% 设置beamer的字体
\LoadClass[
    % fontset=ubuntu, % 生僻字可用思源字体，如“昇腾”
    fontset=fandol,
    aspectratio=169 % 设置宽屏，如不需要可以注释
]{ctexbeamer}


\newif\ifbeamer@secheader
\beamer@secheaderfalse 

% 全局英文字体设置
\RequirePackage{fontspec}
\renewcommand*{\rmdefault}{ntxtlf} % always TLF for math

% 取消注释以开启中文衬线字体
%\renewcommand*{\familydefault}{\rmdefault}

\setmainfont{Times New Roman}
\setsansfont{Times New Roman}



\RequirePackage{hyperref}
\RequirePackage{amsmath}
\RequirePackage{newtxmath}
\RequirePackage{tcolorbox}%box宏包
\RequirePackage{capt-of}
\RequirePackage{xcolor,multicol,booktabs,calligra}
\RequirePackage{graphicx,pstricks,listings,stackengine}

% 参考文献引用标记格式：右上角，带方括号
\RequirePackage{gbt7714}

\useoutertheme[footline=authorinstitutetitle,subsection=false]{smoothbars}
\makeatletter % [add curpage/total page at the bottom](http://tex.stackexchange.com/questions/100838/beamer-dresden-theme-miniframes-appeareance-and-frame-number-insertion)
\newcommand{\frameofframes}{/}
\newcommand{\setframeofframes}[1]{\renewcommand{\frameofframes}{#1}}
\setbeamertemplate{footline} 
  {%
    \begin{beamercolorbox}[colsep=1.5pt]{upper separation line foot}
    \end{beamercolorbox}
    \begin{beamercolorbox}[ht=2.5ex,dp=1.125ex,%
      leftskip=.3cm,rightskip=.3cm plus1fil]{author in head/foot}%
      \leavevmode{\usebeamerfont{author in head/foot}\insertshortauthor}%
      \hfill%
      {\usebeamerfont{institute in head/foot}\usebeamercolor[fg]{institute in head/foot}\insertshortinstitute}%
    \end{beamercolorbox}%
    \begin{beamercolorbox}[ht=2.5ex,dp=1.125ex,%
      leftskip=.3cm,rightskip=.3cm plus1fil]{title in head/foot}%
      {\usebeamerfont{title in head/foot}\insertshorttitle}%
      \hfill%
      {\usebeamerfont{frame number}\usebeamercolor[fg]{frame number}\insertframenumber~\frameofframes~\inserttotalframenumber}
    \end{beamercolorbox}%
    \begin{beamercolorbox}[colsep=1.5pt]{lower separation line foot}
    \end{beamercolorbox}
  }
\makeatother

\useinnertheme{circles}

%\useoutertheme{default}
%\useinnertheme[shadow=true]{rounded}

\xdefinecolor{SYSU}{RGB}{0, 86, 31}  %RGB#82318E   主要更换这个RGB 0.455,0.204,0.506
\setbeamercolor{footline}{bg=SYSU}
\setbeamercolor{frametitle}{bg=SYSU,fg=white}
\setbeamercolor{title}{bg=SYSU}
\setbeamerfont{frametitle}{size=\large}
%\setbeamertemplate{navigation symbols}{}
\setbeamertemplate{bibliography item}[text]
\setbeamertemplate{caption}[numbered]

\setbeamercolor{palette primary}{use=structure,fg=white,bg=structure.fg}
\setbeamercolor{palette secondary}{use=structure,fg=white,bg=structure.fg!75!black}
\setbeamercolor{palette tertiary}{use=structure,fg=white,bg=structure.fg!50!black}
\setbeamercolor{palette quaternary}{fg=white,bg=structure.fg!50!black}
%\setbeamercolor*{sidebar}{use=structure,bg=structure.fg}
\setbeamercolor{titlelike}{parent=palette primary}

%% try
\setbeamercolor{block title}{bg=SYSU,fg=white}
\setbeamercolor*{block title suppose}{use={normal text,suppose text},bg=white,fg=SYSU}
\setbeamercolor{fine separation line}{}
\setbeamercolor{item projected}{fg=white}
\setbeamercolor{palette sidebar primary}{use=normal text,fg=normal text.fg}
\setbeamercolor{palette sidebar quaternary}{use=structure,fg=structure.fg}
\setbeamercolor{palette sidebar secondary}{use=structure,fg=structure.fg}
\setbeamercolor{palette sidebar tertiary}{use=normal text,fg=normal text.fg}
%\setbeamercolor{palette sidebar quaternary}{fg=white}
\setbeamercolor{section in sidebar}{fg=brown}
\setbeamercolor{section in sidebar shaded}{fg=grey}
\setbeamercolor{separation line}{}
\setbeamercolor{sidebar}{bg=SYSU}
\setbeamercolor{sidebar}{parent=palette primary}
\setbeamercolor{structure}{fg=SYSU}
\setbeamercolor{subsection in sidebar}{fg=brown}
\setbeamercolor{subsection in sidebar shaded}{fg=grey}
\AtBeginSection[]{
	\begin{frame}
		\tableofcontents[sectionstyle=show/shaded,subsectionstyle=show/shaded/hide,subsubsectionstyle=show/shaded/hide]
	\end{frame}
}
\AtBeginSubsection[]{
	\begin{frame}
		\tableofcontents[sectionstyle=show/shaded,subsectionstyle=show/shaded/hide,subsubsectionstyle=show/shaded/hide]
	\end{frame}
}

% 参考文献
\newcommand\makereferences{
    \begingroup
    % 引用样式
    \bibliographystyle{gbt7714-numerical}
    \renewcommand{\section}[2]{} 
    \textcolor{SYSU}{{\small\songti\bibliography{pre}}}    % 引用文献列表
    \endgroup
}

% 定义定理定义环境
%定义颜色
%定义某个颜色，对应颜色代号查表
\definecolor{titlepurple}{HTML}{5758BB}%一级标题（目前：蓝紫色）
\definecolor{titlepurpleb}{HTML}{3A006F}%二级标题（目前：深紫色）
\definecolor{titlepurplec}{HTML}{006266}%三级标题（目前：墨绿色）
\definecolor{tab1}{HTML}{9698ED}%表格1
\definecolor{tab2}{HTML}{DBDCFF}%表格2
\definecolor{dy0}{HTML}{EA7500}%小标题定义专用（目前：橙黄色）
\definecolor{dl}{HTML}{007500}%小标题定理专用（目前：深绿色）
\definecolor{inference}{HTML}{343300}%小标题推论专用（目前：墨绿色）
\definecolor{ex}{HTML}{7158e2}%小标题例专用（目前：紫色）
\definecolor{dy}{HTML}{BF0060}%夹杂在文本中的定义词的颜色1（目前：深红色）
\definecolor{dy2}{HTML}{FF0000}%夹杂在文本中的定义词的颜色2（目前：红紫色）
\definecolor{dya}{HTML}{FFFFFF}
\definecolor{超链接}{HTML}{0000C6}%含超链接的文字专用色（目前：蓝紫色）
\definecolor{文字底色}{HTML}{F8FF00}%强调的文字底色（目前：黄色）
\definecolor{eq}{HTML}{F0F0F0}
\definecolor{tl}{HTML}{D94600}

% ---------------------------- 定义环境 ----------------------------  %
%定义计数器
\newcounter{theorema}[section]
\newcounter{defination}[section]
\newcounter{suppose}[section]
\newcounter{inference}[section]
\newcounter{examples}[section]
\newcounter{tl}[section]
\newcounter{lemma}[section]
\newcounter{F}[section]
\newcounter{G}[section]
\newcounter{H}[section]
\renewcommand{\thetheorem}{{ 定理} \textbf{\thesection.\arabic{theorema}}}
\renewcommand{\thedefination}{{ 定义} \textbf{\thesection.\arabic{defination}}}
\renewcommand{\theexample}{{ 假设} \textbf{\thesection.\arabic{suppose}}}
\renewcommand{\theinference}{{ 方法} \textbf{\thesection.\arabic{inference}}}
\renewcommand{\theexamples}{{ 例}  \textbf{\thesection.\arabic{examples}}}
\renewcommand{\thelemma}{{ 引理}  \textbf{\thesection.\arabic{lemma}}}
\renewcommand{\thetl}{{ 推论}  \textbf{\thesection.\arabic{tl}}}
\newcommand{\s}{\hspace*{-2.7em}}


\newcommand{\mybox}[2][]{
	\begin{tcolorbox}[on line,
		arc=0pt,outer arc=0pt,colback=#1!10!white,colframe=#1,
		boxsep=0pt,left=3pt,right=3pt,top=4pt,bottom=6pt,
		boxrule=0pt,leftrule=1.5pt]#2
\end{tcolorbox}}

%定理类
\renewcommand{\theorem}[2]{\vspace{1em}\s \refstepcounter{theorema} \hspace*{2em} \mybox[dl]{{\footnotesize \color{dl}\thetheorem\hspace{1em}#1}\\[0.3em] \footnotesize \hspace*{2em}#2}\vspace{0.5em}  \par}

%推论类
\newcommand{\inference}[2]{\vspace{1em}\s \refstepcounter{inference} \hspace*{2em} \mybox[inference]{{\footnotesize \color{inference}\theinference\hspace{1em}#1}\\[0.3em] \footnotesize  \hspace*{1.5em}#2}\vspace{0.5em}   \par}

%定义类
\newcommand{\defination}[2]{\vspace{1em}\s \refstepcounter{defination} \hspace*{2em} \mybox[dy0]{{\footnotesize \color{dy0}\thedefination\hspace{1em}#1}\\[0.3em] \footnotesize \hspace*{2em}#2}\vspace{0.5em} \par}

%引理类
\renewcommand{\lemma}[2]{\vspace{1em}\s \refstepcounter{lemma} \hspace*{2em} \mybox[inference]{{\footnotesize \color{inference}\thelemma\hspace{1em}#1}\\[0.3em] \footnotesize \hspace*{2em}#2}\vspace{0.5em}   \par}

%题型类
\newcommand{\suppose}[2]{\vspace{1em}\s \refstepcounter{suppose} \hspace*{2em} \mybox[ex]{{\footnotesize \color{ex}\theexample\hspace{1em}#1}\\[0.3em] \footnotesize \hspace*{2em}#2}\vspace{0.5em} \par}
% ------------------------------------------------------------- %
