% 定义模板样式
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{sysuthesis}[2017/05/06 v4.5.3 Sun Yat-Sen University undergraduate thesis document class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}
\ProcessOptions\relax

\LoadClass[
    % fontset=adobe2, % 可手动下载adobe，并选用此项
    fontset=fandol,    % texlive自带，可移植字体库，只有常用的6763个汉字
    %fontset=ubuntu,
    %fontset=mac,
    %fontset=windows,
    a4paper,
    %openright,
    openany,
    zihao=-4
]{ctexbook}

\def\@printtwoside{0} % 设置文章为电子版格式（不添加多余空白页）
%\def\@printtwoside{1} % 设置文章为双面打印格式（添加多余空白页保证每个表格、章节开头为奇数页面）

% 配置英文字体
\RequirePackage{fontspec}
\setmainfont{Times New Roman}

% \RequirePackage[margin=1in,headsep=.2in, headheight=2in]{geometry}
\RequirePackage[top=25mm, bottom=20mm, left=30mm, right=30mm,a4paper]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{booktabs}
\RequirePackage{calc}
\RequirePackage{graphicx}
\RequirePackage[labelsep=space]{caption}
\RequirePackage[font=footnotesize]{subcaption}
\RequirePackage{amsmath,amssymb,amsthm}
\RequirePackage{ragged2e} % 实现两端对齐
\RequirePackage{listings}
\RequirePackage{longtable}
\RequirePackage[section]{placeins}
% TODO: 伪代码要用中文吗？
% \RequirePackage[onelanguage,linesnumbered,algochapter,ruled,vlined]{algorithm2e}
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
\RequirePackage{datetime}
\RequirePackage{nth}

% 引入调整段落整体宽度的宏包
\RequirePackage{changepage}

% Insert a TRUE blank page which has no header or footer
\let\origdoublepage\cleardoublepage
\newcommand{\clearemptydoublepage}{
    \clearpage{
        \pagestyle{empty}
        \origdoublepage
    }
}
% 定义了一种新的clearpage方式，允许一个变量切换电子版及双面打印版
\newcommand{\newclearpage}{
    \if\@printtwoside1
        \clearemptydoublepage
    \else
        \clearpage
    \fi
}

% 设定时间为中文日期
\ctexset{today=small}

% 定义英文日期格式
\newcommand\etoday{
    \hspace{0.5\ccwd} \monthname[\the\month]\hspace{2\ccwd} \nth{\the\day}{\hspace{1\ccwd}} \the\year
}

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
% 1.5倍行距 TODO
\renewcommand{\baselinestretch}{1.5}

% 有序与无序列表环境
\setlist[enumerate]{nosep}
\renewcommand\labelenumi{\theenumi)}
%\renewcommand\labelenumi{\theenumi.}
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
    % F18 页眉与页脚 宋体五号居中
    \fancyfoot[C]{\zihao{5}\thepage} % 页码位于页脚居中

    % 左右两栏页眉，左为论文题目右为当前章
    % \fancyhead[L]{\zihao{-5}\@ctitle}
    % \fancyhead[R]{\zihao{-5}\leftmark}

    % 居中式页眉，可以选择为论文题目或当前章
    \fancyhead[C]{\zihao{5}\@ctitle}
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

% 表格与图片标题设定
% https://blog.csdn.net/uncle_gy/article/details/78313861
% https://tex.stackexchange.com/questions/101591/setting-font-size-for-caption-package
\renewcommand{\thefigure}{\thechapter.\arabic{figure}}
\setlength\heavyrulewidth{0.2em}
% F19 图题表题 宋体五号
\DeclareCaptionFormat{sysucaption}{\fontsize{10.5}{10.5}\selectfont#1#2#3}
\captionsetup{format=sysucaption}


% 目录设定，使用tocloft宏包
\setcounter{secnumdepth}{3} % depth of toc, 2
\setcounter{tocdepth}{1}
% 如果要在目录中显示子章节请换用下面这行(目录中显示到x.y.z章)，如果不用这行默认显示到x.y章。
% \setcounter{tocdepth}{2}

% F8 目录标题：3号黑体居中
\renewcommand{\cfttoctitlefont}{\hfill\zihao{3}\heiti}
\renewcommand{\cftlottitlefont}{\hfill\zihao{3}\heiti}
\renewcommand{\cftloftitlefont}{\hfill\zihao{3}\heiti}

% 如果要加粗，放 \bfseries
% 目录中章节标题：小四号宋体
% F9 目录内容：宋体小四号
\renewcommand{\cftchapfont}{\zihao{-4}\songti}
\renewcommand{\cftchappagefont}{\zihao{-4}\songti}

% 目录中其他内容：小四号宋体
\renewcommand{\cftsecfont}{\zihao{-4}\songti}
\renewcommand{\cftsecpagefont}{\zihao{-4}\songti}
\renewcommand{\cftsubsecfont}{\zihao{-4}\songti}
\renewcommand{\cftsubsecpagefont}{\zihao{-4}\songti}
\setlength{\cftsecindent}{0.5em}        % 小节缩进, 对齐章标题空隙

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
\renewcommand{\cftnodots}{\cftdotsep}     % 使用点指示页数

% \addtolength{\cftchapnumwidth}{3\ccwd} % 用来设置目录中章节标题离数字的距离
\newcommand\mybold[1]{\textit{\textbf{#1}}}

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
\newtheorem{assumption}{假设}[chapter]

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
\RequirePackage{gbt7714}

% 相关信息宏定义
\newcommand\ctitle[1]{\def\@ctitle{#1}}
\newcommand\etitle[1]{\def\@etitle{#1}}
\newcommand\covertitlefirst[1]{\def\@covertitlefirst{#1}}
\newcommand\covertitlesecond[1]{\def\@covertitlesecond{#1}}
% 这两个在原来的info.tex里面定义，用于英文标题过长的时候的换行情况
\newcommand\etitlefirst[1]{\def\@etitlefirst{#1}}
\newcommand\etitlesecond[1]{\def\@etitlesecond{#1}}
\newcommand\eabstracttitlefirst[1]{\def\@eabstracttitlefirst{#1}} % 解决英文摘要页标题过长问题 (Issue 49&63)
\newcommand\eabstracttitlesecond[1]{\def\@eabstracttitlesecond{#1}}
\newcommand\cauthor[1]{\def\@cauthor{#1}} % 默认中文名为封面作者名字
\newcommand\eauthor[1]{\def\@eauthor{#1}}
\newcommand\studentid[1]{\def\@studentid{#1}}
\newcommand\cschool[1]{\def\@cschool{#1}}
\newcommand\cmajor[1]{\def\@cmajor{#1}}
\newcommand\emajor[1]{\def\@emajor{#1}}
\newcommand\cmentor[1]{\def\@cmentor{#1}}
\newcommand\ementor[1]{\def\@ementor{#1}}

% 新版封面，add by wyf 2021-01-11 21:57:01
\newcommand\makeUndergraduateCover {
    \begin{titlepage}
        \begin{center}
            \heiti
            \definecolor{sysugreen}{RGB}{36,86,44}
            \ \vspace{0.5cm}
            \includegraphics[width=3cm]{image/template/sysu-logo.pdf} \\
            \vspace{\baselineskip}
            {\zihao{-0}\textcolor{sysugreen}{\songti\textbf{\ 本科生毕业论文（设计）}}}

            \vspace{\baselineskip}

            % 做分割线
            \noindent\makebox[\linewidth]{ { \color{sysugreen} \rule{\paperwidth}{0.12cm} } }
            % \noindent\makebox[\linewidth]{ { \color{sysugreen} \rule[1.05cm]{\paperwidth}{0.05cm} } }
            \noindent\makebox[\linewidth]{ { \color{sysugreen} \rule[0.8\baselineskip]{\paperwidth}{0.05cm} } }

            \ \vspace{1.5cm}

            {
                % 二号对应22pt
                \renewcommand{\arraystretch}{1.5}
                \fontsize{22}{22}\heiti\selectfont
                \begin{tabular}{ll}
                    % F1: 论文题目 黑体二号居中
                    \makebox[0.7cm] & \makebox[1.5cm]{题目：\hfill} \underline{\makebox[13cm]{\hfill\zihao{2}\textbf\@covertitlefirst\hfill}} \\
                    % \vspace{1pt}\\
                    \makebox[0.7cm] & \makebox[1.5cm]{\hfill} \underline{\makebox[13cm]{\hfill\zihao{2}\textbf\@covertitlesecond\hfill}}      \\
                \end{tabular}
                \ \vspace{1.7cm} \\
                % 小三对应15pt
                \renewcommand{\arraystretch}{2}
                % \setlength\arrayrulewidth{1.4pt}
                \fontsize{15}{15}\heiti\selectfont
                \begin{tabular}{cc}
                    % [s] 两端对齐
                    \makebox[2.2cm][s]{姓名}     & \makebox[8cm]{\hfill\@cauthor\hfill}   \\ \cline{2-2}
                    \makebox[2.2cm][s]{学号}     & \makebox[8cm]{\hfill\@studentid\hfill} \\ \cline{2-2}
                    \makebox[2.2cm][s]{院系}     & \makebox[8cm]{\hfill\@cschool\hfill}   \\ \cline{2-2}
                    \makebox[2.2cm][s]{专业}     & \makebox[8cm]{\hfill\@cmajor\hfill}    \\ \cline{2-2}
                    \makebox[2.2cm][s]{指导教师} & \makebox[8cm]{\hfill\@cmentor\hfill}   \\ \cline{2-2}
                \end{tabular}
            }\\
            \ \\
            \underline{\makebox[0.9cm]{\number\year}}年\underline{\makebox[0.9cm]{\number\month}}月\underline{\makebox[0.9cm]{\number\day}}日

            % \zihao{-3}
            % {\centering
            %     \ctexset{today=big}         % 汉字数字形式日期
            %     时间：\today     \\ % 使用最后一次编译的日期, 实现日期的自动化
            %     % Date:\hspace{0.5\ccwd} Month\hspace{2\ccwd} Day\hspace{1\ccwd} Year
            %     Date: \etoday % 英文日期自动化
            % }

        \end{center}
    \end{titlepage}
    \newclearpage
}


% 新版封面，add by wyf 2021-01-11 21:57:01
\newcommand\makeUndergraduateTitlePage {
    \begin{center}
        \ \vspace{2cm} \\
        {
        \renewcommand{\arraystretch}{1.2}
        \zihao{2}\heiti\selectfont
        \begin{tabular}{c}
            % F1: 论文题目 黑体二号居中
            \makebox[13cm]{\heiti\hfill\zihao{2}\textbf{\@covertitlefirst}\hfill}  \\
            \makebox[13cm]{\heiti\hfill\zihao{2}\textbf{\@covertitlesecond}\hfill} \\
        \end{tabular}
        \ \vspace{1cm} \\
        \zihao{2}\selectfont
        \begin{tabular}{c}
            % F1: 论文题目 黑体二号居中
            \makebox[13cm]{\hfill\zihao{2}\textbf{\@etitlefirst}\hfill}  \\
            \makebox[13cm]{\hfill\zihao{2}\textbf{\@etitlesecond}\hfill} \\
        \end{tabular}
        }

        \ \vspace{1.8cm} \\

        {
        % 小三对应15pt
        \renewcommand{\arraystretch}{1.6}
        % \setlength\arrayrulewidth{1.4pt}
        \zihao{3}\heiti\selectfont
        \begin{tabular}{cc}
            % [s] 两端对齐
            \makebox[2.3cm][s]{姓名}     & \makebox[8.5cm]{\hfill\@cauthor\hfill}   \\ \cline{2-2}
            \makebox[2.3cm][s]{学号}     & \makebox[8.5cm]{\hfill\@studentid\hfill} \\ \cline{2-2}
            \makebox[2.3cm][s]{院系}     & \makebox[8.5cm]{\hfill\@cschool\hfill}   \\ \cline{2-2}
            \makebox[2.3cm][s]{专业}     & \makebox[8.5cm]{\hfill\@cmajor\hfill}    \\ \cline{2-2}
            \makebox[2.3cm][s]{指导教师} & \makebox[8.5cm]{\hfill\@cmentor\hfill}   \\ \cline{2-2}
        \end{tabular}
        }\\

        \ \vspace{1.5cm} \\

        {\zihao{4}\heiti \underline{\makebox[0.9cm]{\number\year}}年\underline{\makebox[0.9cm]{\number\month}}月\underline{\makebox[0.9cm]{\number\day}}日 }

        % \zihao{-3}
        % {\centering
        %     \ctexset{today=big}         % 汉字数字形式日期
        %     时间：\today     \\ % 使用最后一次编译的日期, 实现日期的自动化
        %     % Date:\hspace{0.5\ccwd} Month\hspace{2\ccwd} Day\hspace{1\ccwd} Year
        %     Date: \etoday % 英文日期自动化
        % }

    \end{center}
    \thispagestyle{empty}
    \newclearpage
}


% 旧版的一种封面
\renewcommand\maketitle {
    \begin{titlepage}
        \begin{center}
            \includegraphics[width=10cm]{image/template/SYSULogo} \\
            \songti
            \vspace{\baselineskip}
            \zihao{-0}\textbf{本科生毕业论文（设计）} \\
            \zihao{2}\textbf{\textrm{Undergraduate Graduation Thesis（Design）}} \\
            \vspace{2\baselineskip}

            {\fontsize{15}{10}\selectfont
                \begin{tabular}{l}
                    \makebox[2.7cm]{题目 Title:\hfill} \underline{\makebox[8.3cm]{\hfill\zihao{3}\songti\textbf\@covertitlefirst\hfill}} \\\vspace{1pt}\\
                    \makebox[2.7cm]{\hfill} \underline{\makebox[8.3cm]{\hfill\zihao{3}\songti\textbf\@covertitlesecond\hfill}}           \\\vspace{1pt}\\
                    \vspace{8pt}                                                                                                         \\
                    院\hspace{0.5\ccwd}系                                                                                                \\
                    \makebox[4.8cm]{School (Department):\hfill} \underline{\makebox[6.2cm]{\hfill\@cschool\hfill}}                       \\
                    \vspace{8pt}                                                                                                         \\
                    专\hspace{0.5\ccwd}业                                                                                                \\
                    \makebox[1.7cm]{Major:\hfill} \underline{\makebox[9.3cm]{\hfill\@cmajor\hfill}}                                      \\
                    \vspace{8pt}                                                                                                         \\
                    学生姓名                                                                                                             \\
                    \makebox[3.4cm]{Student Name:\hfill} \underline{\makebox[7.6cm]{\hfill\@cauthor\hfill}}                              \\
                    \vspace{8pt}                                                                                                         \\
                    学\hspace{0.5\ccwd}号                                                                                                \\
                    \makebox[3cm]{Student No.:\hfill} \underline{\makebox[8cm]{\hfill\@studentid\hfill}}                                 \\
                    \vspace{8pt}                                                                                                         \\
                    指导教师（职 称）                                                                                                    \\
                    \makebox[4cm]{Supervisor (Title):\hfill} \underline{\makebox[7cm]{\hfill\@cmentor\hspace{2.7cm}}}
                \end{tabular}
            }
            \vfill

            \zihao{-3}
            {\centering
                \ctexset{today=big}         % 汉字数字形式日期
                时间：\today     \\ % 使用最后一次编译的日期, 实现日期的自动化
                % Date:\hspace{0.5\ccwd} Month\hspace{2\ccwd} Day\hspace{1\ccwd} Year
                Date: \etoday % 英文日期自动化
            }

        \end{center}
    \end{titlepage}
    \newclearpage
}

% 下面是更好的封面，但不符合学校要求，暂且注释保留
% \renewcommand\maketitle {
%     \begin{titlepage}
%         \begin{center}
%             \includegraphics[width=10cm]{image/SYSULogo} \\
%             \songti
%             \vspace{\baselineskip}
%             \zihao{-0}\textbf{本科生毕业论文（设计）} \\
%             \zihao{2}\textbf{\textrm{Undergraduate Graduation Thesis（Design）}} \\
%             \vspace{2\baselineskip}

%             \zihao{3}\textbf{\@title}
%             \vspace{2\baselineskip}

%             {\fontsize{15}{10}\selectfont
%             \begin{tabular}{l}
%                 \makebox[4.8cm]{院\hspace{2\ccwd}系:} \underline{\makebox[15em]{\hfill\@cschool\hfill}} \\
%                 \makebox[4.8cm]{School (Department)} \\
%                 \vspace{8pt} \\

%                 \makebox[4.8cm]{专\hspace{2\ccwd}业:} \underline{\makebox[15em]{\hfill\@cmajor\hfill}} \\
%                 \makebox[4.8cm]{Major} \\
%                 \vspace{8pt} \\

%                 \makebox[4.8cm]{学生姓名:} \underline{\makebox[15em]{\hfill\@cauthor\hfill}} \\
%                 \makebox[4.8cm]{Student Name} \\
%                 \vspace{8pt} \\

%                 \makebox[4.8cm]{学\hspace{2\ccwd}号:} \underline{\makebox[15em]{\hfill\@studentid\hfill}} \\
%                 \makebox[4.8cm]{Student No.} \\
%                 \vspace{8pt} \\

%                 \makebox[4.8cm]{指导教师(职 称):} \underline{\makebox[15em]{\hfill\@cmentor\hfill}} \\
%                 \makebox[4.8cm]{Supervisor (Title)} \\
%             \end{tabular}
%             }
%             \vfill

%             \zihao{-3}
%             {\centering
%                 \ctexset{today=big}         % 汉字数字形式日期
%                 时间: \today        % 使用最后一次编译的日期, 实现日期的自动化
%                 \ctexset{today=old}         % 英文形式日期
%                 Date: \today
%             }
%         \end{center}
%     \end{titlepage}
%     \newclearpage
% }

% 开题报告
\newcommand\objective[1]{\def\@objective{#1}}
\newcommand\methodology[1]{\def\@methodology{#1}}
\newcommand\researchProcedure[1]{\def\@researchProcedure{#1}}
\newcommand\supportment[1]{\def\@supportment{#1}}
\newcommand\schedule[1]{\def\@schedule{#1}}
\newcommand\proposalInstructions[1]{\def\@proposalInstructions{#1}}

\newcommand\makeProposal{
    \pagestyle{empty}

    \begin{center}
        \zihao{3}\fangsong\bfseries
        表一\hspace{\ccwd}毕业论文（设计）开题报告 \\
        Form 1: Research Proposal of Graduation Thesis (Design)
    \end{center}
    %\addcontentsline{toc}{chapter}{表一 毕业论文（设计）开题报告}

    \zihao{-4}\songti
    \begin{longtable}{|p{\textwidth}|}
        % 第一页出现的表头
        \hline
        论文(设计)题目:                                                                                                             \\
        Thesis (Design) Title: \@ctitle
        \endfirsthead

        % 中间页出现的表头
        \hline
        %(前接)
        \endhead

        % 中间页出现的表脚
        %(后续) \\
        \hline
        \endfoot

        % 表格最后一页的表脚
        %\hline
        指导教师意见:                                                                                                               \\
        Comments from Supervisor:                                                                                                   \\
        \@proposalInstructions                                                                                                      \\
        \vspace{\baselineskip}

        \begin{tabular}{l l l}
            1. 同意开题     & 2. 修改后开题                  & 3. 重新开题        \\
            1. Approved(　) & 2. Approved after Revision(　) & 3. Disapproved(　) \\
        \end{tabular}

        \vspace{\baselineskip}
        \hspace{2\ccwd}Supervisor Signature:\hfill Date:\makebox{\hspace{10\ccwd}}                                                  \\
        \rule{0cm}{\baselineskip}                                                                                                   \\
        \hline
        \endlastfoot

        \hline
        (简述选题的目的、思路、方法、相关支持条件及进度安排等)                                                                      \\
        (Please briefly state the research objective, research methodology, research procedure and research schedule in this part.) \\
        \textbf{选题目的:}                                                                                                          \\
        \@objective
        \vspace{\baselineskip}

        \textbf{思路:}                                                                                                              \\
        \@methodology
        \vspace{\baselineskip}

        \textbf{方法:}                                                                                                              \\
        \@researchProcedure
        \vspace{\baselineskip}

        \textbf{相关支持条件:}                                                                                                      \\
        \@supportment
        \vspace{\baselineskip}

        \textbf{进度安排:}                                                                                                          \\
        \@schedule
        \vspace{\baselineskip}
        \vfill

        \hspace{2\ccwd}Student Signature:\hfill Date:\makebox{\hspace{10\ccwd}}                                                     \\
        \rule{0cm}{\baselineskip}                                                                                                   \\
        \hline
    \end{longtable}
    \newclearpage
}


% Author:   Souler Ou
% 修改者:    欧一锋
% Date:     3/30/2018

% 用到的变量
% 四次过程报告自述
\newcommand\firstsummary[1]{\def\@firstsummary{#1}}
\newcommand\secondsummary[1]{\def\@secondsummary{#1}}
\newcommand\thirdsummary[1]{\def\@thirdsummary{#1}}
\newcommand\fourthsummary[1]{\def\@fourthsummary{#1}}
% 四次老师的评价
\newcommand\firstcomment[1]{\def\@firstcomment{#1}}
\newcommand\secondcomment[1]{\def\@secondcomment{#1}}
\newcommand\thirdcomment[1]{\def\@thirdcomment{#1}}
\newcommand\fourthcomment[1]{\def\@fourthcomment{#1}}
% 老师最后评价
\newcommand\finalcomment[1]{\def\@finalcomment{#1}}

% 进度检查记录表
% 这个文件中使用到的数据需要在 docs/progess.tex 中做好填写。
\newcommand\makeProgressCheck{
    \pagestyle{empty}

    \begin{center}
        \zihao{3}\fangsong\bfseries
        表二\hspace{\ccwd}毕业论文（设计）过程检查记录表 \\
        Form 2: Process Check-up Form
    \end{center}

    \zihao{-4}\songti
    \begin{longtable}{|c|l|}
        % 中间页出现的表头
        \hline
        \endhead

        % 中间页出现的表脚
        %(后续) \\
        \hline
        \endfoot

        %最后部分的表脚
        \hline
                                      & 指导教师意见Comments from Supervisor:              \\
                                      &                                                    \\
                                      &                                                    \\
                                      &                                                    \\
        \newline
        \textbf{总体完成情况}         & 1、按计划完成，完成情况优（Excellent）：（\quad）  \\
                                      & 2、按计划完成，完成情况良（Good）：（\quad）       \\
        \textbf{(Overall Assessment)} & 3、基本按计划完成，完成情况合格（Fair）：（\quad） \\
                                      & 4、完成情况不合格（Poor）：（\quad）               \\
                                      &                                                    \\
                                      & 指导教师签名（Supervisor Signature）:              \\
                                      & 日期（Date）:                                      \\
                                      &                                                    \\
        \hline
        \endlastfoot

        % 开头的废话
        \multicolumn{2}{|p{\textwidth}|}{
        \bfseries{指导教师分阶段检查论文的进展情况（要求过程检查记录不少于3次）} \newline
        \bfseries{The supervisor should check up the working process for the thesis（design）and fill up the following check-up log. At least three times of the check-up should be done and kept on the log.}
        \vspace{\baselineskip}
        }                                                                                  \\
        % 第一次检查
        \multicolumn{2}{|p{\textwidth}|} {
        \textbf{第一次检查（First Check-up）:}  \newline
        \begin{adjustwidth}{2em}{2em}
            学生总结 \newline
            Student Self-Summary:
        \end{adjustwidth}
        \@firstsummary
        \begin{adjustwidth}{2em}{2em}
            指导教师意见 \newline
            Comments of Supervisor: \newline
        \end{adjustwidth}
        \@firstcomment
        \vspace{\baselineskip}
        }                                                                                  \\
        % 第二次检查
        \multicolumn{2}{|p{\textwidth}|} {
        \textbf{第二次检查（Second Check-up）:}  \newline
        \begin{adjustwidth}{2em}{2em}
            学生总结 \newline
            Student Self-Summary:
        \end{adjustwidth}
        \@secondsummary
        \begin{adjustwidth}{2em}{2em}
            指导教师意见 \newline
            Comments of Supervisor: \newline
        \end{adjustwidth}
        \@secondcomment
        \vspace{\baselineskip}
        }                                                                                  \\

        % 第三次检查
        \multicolumn{2}{|p{\textwidth}|} {
        \textbf{第三次检查（Third Check-up）:}  \newline
        \begin{adjustwidth}{2em}{2em}
            学生总结 \newline
            Student Self-Summary:
        \end{adjustwidth}
        \@thirdsummary
        \begin{adjustwidth}{2em}{2em}
            指导教师意见 \newline
            Comments of Supervisor:
        \end{adjustwidth}
        \@thirdcomment
        \vspace{\baselineskip}
        }                                                                                  \\

        % 第四次检查
        \multicolumn{2}{|p{\textwidth}|} {
        \textbf{第四次检查（Fourth Check-up）:}  \newline
        \begin{adjustwidth}{2em}{2em}
            学生总结 \newline
            Student Self-Summary:
        \end{adjustwidth}
        \@fourthsummary
        \begin{adjustwidth}{2em}{2em}
            指导教师意见 \newline
            Comments of Supervisor:
        \end{adjustwidth}
        \@fourthcomment
        \vspace{\baselineskip}
        }                                                                                  \\

        % 结尾落款部分
        \multicolumn{2}{|p{\textwidth}|}{
        \vspace{1cm} \newline
        \hspace{2\ccwd}学生签名（Student Signature）:\hfill 日期（Date）:\makebox{\hspace{5\ccwd}} \newline
        \rule{0cm}{\baselineskip}\newline
        \hspace{2\ccwd}指导教师签名（Supervisor Signature）:\hfill 日期（Date）:\makebox{\hspace{5\ccwd}} \newline
        \rule{0cm}{\baselineskip}
        }                                                                                  \\
    \end{longtable}
    \newclearpage
}


% Author:   Souler Ou
% 修改者:    欧一锋
% Date:     3/30/2018
% Mail:     ou@souler.cc

% 答辩情况登记表

\newcommand\makeDefenseRecord{
    \pagestyle{empty}

    \begin{center}
        \zihao{3}\fangsong\bfseries
        表三\hspace{\ccwd}毕业论文（设计）答辩情况登记表 \\
        Form 3: Thesis Defense Performance Form
    \end{center}

    \zihao{-4}\songti
    \begin{longtable}{|c|c|c|c|}
        % 第一页出现的表头
        \hline
        % 第一行 答辩人以及专业 使用info.tex中的数据自动生成
        \textbf{答辩人}                & \@cauthor                     & \textbf{专业} & \@cmajor \\
        \textbf{Student Name}          & \@eauthor                     & {Major}       & \@emajor \\
        \hline
        % 第二行 论文题目 如果题目长度过长需要换成两行的版本。
        \textbf{论文(设计)题目}        & \multicolumn{3}{c|}{\@ctitle}                            \\
        \textbf{Thesis（Design）Title} & \multicolumn{3}{c|}{\@etitle}                            \\
        % 需要两行英文题目的可以使用向下面两行
        % \textbf{Thesis（Design）Title} & \multicolumn{3}{|c|}{\@etitlefirst} \\
        % & \multicolumn{3}{|c|}{\@etitlesecond}\\
        \hline
        \textbf{答辩小组成员}          & \multicolumn{3}{c|}{\quad}                               \\
        \textbf{Committee Members}     & \multicolumn{3}{c|}{\quad}                               \\
        \endfirsthead

        % 中间页出现的表头
        \hline
        %(前接)
        \endhead

        % 中间页出现的表脚
        %(后续) \\
        \hline
        \endfoot

        % 表格最后一页的表脚
        \hline
        \multicolumn{4}{|p{\textwidth}|}{
        % 按照论文原格式是两个字符的缩进
        \begin{adjustwidth}{2em}{2em}
            答辩记录 \newline
            Records of Defense Performance:
        \end{adjustwidth}

        % % 两行标题的情况，用14厘米的空白页
        % \vspace{14cm}

        % 单行标题的情况，用14也行，推荐15
        \vspace{15cm}
        \hspace{2\ccwd}记录人签名（Clerk Signature）:\hfill 日期（Date）:\makebox{\hspace{5\ccwd}}
        \vspace{\baselineskip}
        }
        \\
        \hline
    \end{longtable}
    \newclearpage
}


\newcommand\makedisclaim{
    \ctexset {
        chapter = {
          titleformat = {\zihao{3}\heiti\bfseries},
          beforeskip = {10pt},
          afterskip = {20pt}
         }
    }
    \chapter*{学术诚信声明}
    % {\centering\zihao{3}\heiti\textbf{学术诚信声明} }

    \zihao{-4}\songti\selectfont

    % 旧版的学术诚信声明
    % 本人所呈交的毕业论文，是在导师的指导下，独立进行研究工作所取得的成果，所有数据、图片资料均真实可靠。除文中已经注明引用的内容外，本论文不包含任何其他人或集体已经发表或撰写过的作品或成果。对本论文的研究作出重要贡献的个人和集体，均已在文中以明确的方式标明。本毕业论文的知识产权归属于培养单位。本人完全意识到本声明的法律结果由本人承担。

    % 新版的
    本人郑重声明：所呈交的毕业论文（设计），是本人在导师的指导下，独立进行研究工作所取得的成果。除文中已经注明引用的内容外，本论文（设计）不包含任何其他个人或集体已经发表或撰写过的作品成果。对本论文（设计）的研究做出重要贡献的个人和集体，均已在文中以明确方式标明。本论文（设计）的知识产权归属于培养单位。本人完全意识到本声明的法律结果由本人承担。

    \vspace{2\baselineskip}

    \begin{flushright}
        \makebox[2.1cm][s]{作者签名：} \makebox[5cm]{\hspace{1cm}} \\
        \vspace{\baselineskip}
        \makebox[2.1cm][s]{日期：} \makebox[5cm]{\hspace{1cm}年\hspace{1cm}月\hspace{1cm}日} \\
    \end{flushright}

    % \input{docs/disclaim}
    \thispagestyle{empty}
    \newclearpage
}

% 摘要
\newcommand\ckeywords[1]{\def\@ckeywords{#1}}
\newcommand\ekeywords[1]{\def\@ekeywords{#1}}
\newcommand\cabstract[1]{\def\@cabstract{#1}}
\newcommand\eabstract[1]{\def\@eabstract{#1}}

% 中文摘要、关键字标题：5号黑体并加方括号
% 中文摘要、关键字内容：5号楷体
\newcommand\makecabstract{
    \ctexset{
        section = {
          titleformat = {\zihao{4}\heiti},
          beforeskip = {10pt},
          afterskip = {20pt}
         },
        paragraph/format = {}
    }

    % 使用隐藏目录项的section及添加为chapter形式目录的方法来去掉在openright环境中中英文摘要间出现空白页的情况
    %\section*{摘\hspace{\ccwd}要}
    %\addcontentsline{toc}{chapter}{摘\hspace{\ccwd}要}

    % 有些老师要求摘要前添加论文题目信息，因此保留此项
    %\begin{flushleft}
    %    \zihao{-4}
    %    \textbf{论文题目}：\mbox{ }\@ctitle \\
    %    \textbf{专\hspace{2\ccwd}业}： \mbox{ }\@cmajor \\
    %    \textbf{学生姓名}：\mbox{ }\@cauthor \\
    %    \textbf{学\hspace{2\ccwd}号}：\mbox{ }\@studentid \\
    %    \textbf{指导教师}：\mbox{ }\@cmentor \\
    %\end{flushleft}

    % 或者只要一个醒目的标题
    % F2：中文摘要标题 黑体三号居中
    \vspace*{1ex}
    \centerline{\zihao{3}\heiti【摘\hspace{\ccwd}要】}
    \vspace{1ex}


    % F3: 中文摘要内容 宋体小四号
    % F4: 中文关键词 宋体小四号(关键词加粗)

    \zihao{-4}\songti
    % \fontsize{12}{18}\songti
    % \paragraph{}
    % \setlength{\baselineskip}{20pt}
    \@cabstract
    \paragraph{\textbf{关键词：}}\@ckeywords
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
    %    \zihao{-4}
    %    \makebox[2.6cm]{\textbf{Title:}\hfill} \@etitle\\
    %    \makebox[2.6cm]{\textbf{Major:}\hfill} \@emajor \\
    %    \makebox[2.6cm]{\textbf{Name:}\hfill} \@eauthor\\
    %    \makebox[2.6cm]{\textbf{Student ID:}\hfill} \@studentid \\
    %    \makebox[2.6cm]{\textbf{Supervisor:}\hfill} \@ementor
    %\end{flushleft}

    %\centerline{\zihao{3}\bfseries{\@etitle}}
    % \centerline{\zihao{3}\bfseries{\@eabstracttitlefirst}}
    % \centerline{\zihao{3}\bfseries{\@eabstracttitlesecond}}

    \vspace*{1ex}
    % F5 英文摘要标题，加粗三号全部大写
    \zihao{3}
    \centerline{\textbf{[ABSTRACT]}}
    \vspace*{1ex}
    \setlength{\baselineskip}{20pt}

    % F6 英文摘要内容，小四号
    % F7 英文关键词，小四号，加粗
    \zihao{-4}
    \@eabstract
    \paragraph{\textbf{Keywords:}}\@ekeywords
}

\newcommand\makeabstract{
    \setcounter{page}{1}
    \makecabstract
    % \thispagestyle{cAbstract}
    \newclearpage

    \makeeabstract
    % \thispagestyle{eAbstract}
    \newclearpage
}
\newcommand\maketableofcontents{
    % 设置目录标题与页眉的距离
    % \setlength{\cftbeforetoctitleskip}{0em}
    % 设置目录标题与目录正文的距离
    % \setlength{\cftaftertoctitleskip}{0em}
    \pagestyle{plain}
    \tableofcontents
    \newclearpage
}
\newcommand\makelistoffiguretable{
    \listoffigures
    \newclearpage
    \listoftables
    % \thispagestyle{listoffiguretable}
    \newclearpage
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
          % F10 正文各章标题 黑体三号居中
          nameformat = {\zihao{3}\heiti},
          name = {,},
          number = {\arabic{chapter}},
          % aftername = {},
          titleformat = {\zihao{3}\heiti}
         },
        section = {
          %fixskip = true,
          beforeskip = {20pt},
          afterskip = {10pt},
          format = {},
          % F11 正文各节一级标题 黑体四号居中
          nameformat = {\zihao{4}\heiti},
          titleformat = {\zihao{4}\heiti}
         },
        subsection = {
                %fixskip = true,
                beforeskip = {20pt},
                afterskip = {10pt},
                format = {},
                % F12 正文各节二级及以下标题 宋体小四号加粗左对齐空两格
                indent = {24pt},
                nameformat = {\zihao{-4}\songti\bfseries},
                titleformat = {\zihao{-4}\songti\bfseries}
            },
        subsubsection = {
                beforeskip = {20pt},
                afterskip = {10pt},
                format = {},
                % F12 正文各节二级及以下标题 宋体小四号加粗左对齐空两格
                indent = {24pt},
                nameformat = {\zihao{-4}\songti\bfseries},
                titleformat = {\zihao{-4}\songti\bfseries}
                % 按照中大规定的格式需要显示成a.b.c.d章，而不是(d)节
                % number = {(\arabic{subsubsection})}
            }
    }
    % F13 正文内容  宋体小四号
    \zihao{-4}\songti \linespread{1.5}\selectfont
    \pagestyle{plain}
}

\renewcommand\backmatter{
    \@mainmatterfalse
    % \fancypagestyle{plain}{ \fancyhead[R]{\zihao{-5} \leftmark} }
    \pagestyle{plain}
}

% 参考文献
% 标题小五号黑体加冒号
% 内容小五号宋体
\newcommand\makereferences{
    \begingroup
    \ctexset {
        chapter = {
          % aftertitle = {：},
          format = {\centering},
          % F14 参考文献标题：黑体三号居中
          titleformat = {\zihao{3}\heiti}
         }
    }

    % 引用样式
    \bibliographystyle{gbt7714-numerical}
    % F15 参考文献内容 宋体五号
    {\zihao{5}\rmfamily\songti\bibliography{main}}    % 引用文献列表
    \endgroup
}

% 附录样式
\renewcommand\appendix{\par
    \@mainmattertrue
    % \fancypagestyle{plain}{
    %     \fancyhead[R]{\zihao{-5} 附录\thechapter \leftmark}
    % }
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
          % F16 附录标题 黑体三号居中
          format = {\centering},
          nameformat = {\zihao{3}\heiti},
          titleformat = {\zihao{3}\heiti},
         },
        section = {
          format = {},
          nameformat = {\zihao{4}\heiti},
          titleformat = {\zihao{4}\heiti}
         },
        subsection = {
                format = {},
                indent = {24pt},
                nameformat = {\zihao{-4}\songti\bfseries},
                titleformat = {\zihao{-4}\songti\bfseries}
            }
    }
}

%成绩评定记录表
\newcommand\gradingComment[1]{\def\@gradingComment{#1}}
\newcommand\makeGrade{
    \pagestyle{empty}
    \linespread{1.2}
    \begin{center}
        \zihao{3}\fangsong\bfseries
        毕业论文(设计)成绩评定记录  \\
        Grading Sheet of the Graduation Thesis (Design)
    \end{center}
    %\addcontentsline{toc}{chapter}{表一 毕业论文（设计）开题报告}

    \zihao{4}\songti
    \begin{longtable}{|p{0.9\textwidth}|}
        % 第一页出现的表头
        \hline
        \endfirsthead

        % 中间页出现的表头
        \hline
        %(前接)
        \endhead

        % 中间页出现的表脚
        %(后续) \\
        \hline
        \endfoot

        % 表格最后一页的表脚
        \hline
        \endlastfoot

        \hspace{\ccwd}指导教师评语                                                                           \\
        \hspace{\ccwd}Comments of Supervisor:                                                                \\
        \@gradingComment
        \vspace{\baselineskip}

        \hspace{\ccwd}成绩评定                                                                               \\
        \hspace{\ccwd}Grade:
        \vspace{\baselineskip}

        \hspace{\ccwd}指导教师签名                                                                           \\
        \hspace{\ccwd}Supervisor Signature:\hfill Date:\makebox{\hspace{6\ccwd}}                             \\

        \hline

        \hspace{\ccwd}答辩小组或专业负责人意见                                                               \\
        \hspace{\ccwd}Comments of the Defense Committee:                                                     \\
        \vspace{2\baselineskip}

        \hspace{\ccwd}成绩评定                                                                               \\
        \hspace{\ccwd}Grade:
        \vspace{\baselineskip}

        \hspace{\ccwd}签名:\hfill Date:\makebox{\hspace{6\ccwd}}                                             \\
        \hspace{\ccwd}Signatures of Committee Members                                                        \\

        \hline
        \hspace{\ccwd}院系负责人意见                                                                         \\
        \hspace{\ccwd}Comments of the Academic Chief of School:
        \vspace{2\baselineskip}

        \hspace{\ccwd}成绩评定                                                                               \\
        \hspace{\ccwd}Grade:
        \vspace{\baselineskip}

        \hspace{\ccwd}\makebox[5cm]{签名\hfill} \makebox[5cm]{院系盖章\hfill}                                \\
        \hspace{\ccwd}\makebox[5cm]{Signature:\hfill} \makebox[5cm]{Stamp:\hfill} \makebox[3cm]{Date:\hfill} \\
    \end{longtable}
    \newclearpage
}


% 配置超链接。
% hyperref一般要求是导言区最后一个宏包，才能正常工作
% 若把该宏包提前，则会引起附录列表跳转到第一章的问题
% TODO: 重构宏包引入顺序以让代码语义聚集
\RequirePackage[hidelinks, hyperfootnotes=true]{hyperref}
\RequirePackage{footnotebackref}

\def\equationautorefname{式}%
\def\footnoteautorefname{脚注}%
\def\itemautorefname{项}%
\def\figureautorefname{图}%
\def\tableautorefname{表}%
\def\partautorefname{篇}%
\def\appendixautorefname{附录}%
\def\chapterautorefname{章}%
\def\sectionautorefname{节}%
\def\subsectionautorefname{小节}%
\def\subsubsectionautorefname{小小节}%
\def\paragraphautorefname{段落}%
\def\subparagraphautorefname{子段落}%
\def\FancyVerbLineautorefname{行}%
\def\theoremautorefname{定理}%
% 暂时不能处理引理，推论


\renewcommand{\@fnsymbol}[1]{
    \ifcase#1\or \text{①}\or \text{②}\or \text{③}\or    \text{④}\or \text{⑤}\or \text{⑥}\or \text{⑦}\or \text{⑧} \or \text{⑨} \or \text{⑩}
    \else
        \@ctrerr
    \fi
}
\renewcommand{\thefootnote}{\fnsymbol{footnote}}
