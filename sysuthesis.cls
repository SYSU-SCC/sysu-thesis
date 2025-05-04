%
% This file may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3c
% of this license or (at your option) any later version.
% The latest version of this license is in
%    https://www.latex-project.org/lppl.txt
% and version 1.3c or later is part of all distributions of LaTeX
% version 2008 or later.
%

\NeedsTeXFormat{LaTeX2e}[2017/04/15]
\ProvidesClass{sysuthesis}[2025/02/25 sysu thesis template]

% 报错和警告
\newcommand\sysu@error[1]{%
  \ClassError{sysuthesis}{#1}{}%
}
\newcommand\sysu@warning[1]{%
  \ClassWarning{sysuthesis}{#1}%
}

\newcommand\sysu@deprecated[3]{%
  \sysu@warning{The #1 is deprecated since #2. Use #3 instead.}%
}

% 检查 \LaTeXe{} kernel 版本
\@ifl@t@r\fmtversion{2017/04/15}{}{
  \sysu@error{%
    TeX Live 2017 or later version is required to compile this document%
  }
}

% 检查编译引擎，要求使用 XeLaTeX 或 LuaLaTeX。
\RequirePackage{iftex}
\ifXeTeX\else
  \ifLuaTeX\else
    \sysu@error{XeLaTeX or LuaLaTeX is required to compile this document}
  \fi
\fi


% \subsection{处理选项}

\RequirePackage{kvdefinekeys}
\RequirePackage{kvsetkeys}
\RequirePackage{kvoptions}

% 提供一个 \cs{sysusetup} 命令支持 \emph{key-value} 的方式来设置。
\let\sysu@setup@hook\@empty
\newcommand\sysusetup[1]{%
  \let\sysu@setup@hook\@empty
  \kvsetkeys{sysu}{#1}%
  \sysu@setup@hook
}

% 同时用 \emph{key-value} 的方式来定义这些接口：
% \begin{latex}
%   \sysu@define@key{
%     <key> = {
%       name = <name>,
%       choices = {
%         <choice1>,
%         <choice2>,
%       },
%       default = <default>,
%       code = <code>,
%     },
%   }
% \end{latex}

% 其中 |choices| 设置允许使用的值，默认为第一个（或者 \meta{default}）；
% \meta{code} 是相应的内容被设置时执行的代码。

\newcommand\sysu@define@key[1]{%
  \kvsetkeys{sysu@key}{#1}%
}
\kv@set@family@handler{sysu@key}{%
%
% \cs{sysusetup} 会将 \meta{value} 存到 \cs{sysu@\meta{key}}，
% 但是宏的名字包含 “-” 这样的特殊字符时不方便直接调用，比如 |key = math-style|，
% 这时可以用 |name| 设置 \meta{key} 的别称，比如 |key = math@style|，
% 这样就可以通过 \cs{sysu@math@style} 来引用。
% |default| 是定义该 \meta{key} 时默认的值，默认为空。
%
  \@namedef{sysu@#1@@name}{#1}%
  \def\sysu@@default{}%
  \def\sysu@@choices{}%
  \kv@define@key{sysu@value}{name}{%
    \@namedef{sysu@#1@@name}{##1}%
  }%
  %
  % 由于在定义接口时，\cs{sysu@\meta{key}@@code} 不一定有定义，
  % 而且在文档类/宏包中还有可能对该 |key| 的 |code| 进行添加。
  % 所以 \cs{sysu@\meta{key}@@code} 会检查如果在定义文档类/宏包时则推迟执行，否则立即执行。
  %
  \@namedef{sysu@#1@@check}{}%
  \@namedef{sysu@#1@@code}{}%
  %
  % 保存下 |choices = {}| 定义的内容，在定义 \cs{sysu@\meta{name}} 后再执行。
  %
  \kv@define@key{sysu@value}{choices}{%
    \def\sysu@@choices{##1}%
    \@namedef{sysu@#1@@reset}{}%
    %
    % \cs{sysu@\meta{key}@check} 检查 |value| 是否有效，
    % 并设置 \cs{ifsysu@\meta{name}@\meta{value}}。
    %
    \@namedef{sysu@#1@@check}{%
      \@ifundefined{%
        ifsysu@\@nameuse{sysu@#1@@name}@\@nameuse{sysu@\@nameuse{sysu@#1@@name}}%
      }{%
        \sysu@error{Invalid value "#1 = \@nameuse{sysu@\@nameuse{sysu@#1@@name}}"}%
      }%
      \@nameuse{sysu@#1@@reset}%
      \@nameuse{sysu@\@nameuse{sysu@#1@@name}@\@nameuse{sysu@\@nameuse{sysu@#1@@name}}true}%
    }%
  }%
  \kv@define@key{sysu@value}{default}{%
    \def\sysu@@default{##1}%
  }%
  \kvsetkeys{sysu@value}{#2}%
  \@namedef{sysu@\@nameuse{sysu@#1@@name}}{}%
  %
  % 第一个 \meta{choice} 设为 \meta{default}，
  % 并且对每个 \meta{choice} 定义 \cs{ifsysu@\meta{name}@\meta{choice}}。
  %
  \kv@set@family@handler{sysu@choice}{%
    \ifx\sysu@@default\@empty
      \def\sysu@@default{##1}%
    \fi
    \expandafter\newif\csname ifsysu@\@nameuse{sysu@#1@@name}@##1\endcsname
    \expandafter\g@addto@macro\csname sysu@#1@@reset\endcsname{%
      \@nameuse{sysu@\@nameuse{sysu@#1@@name}@##1false}%
    }%
  }%
  \kvsetkeys@expandafter{sysu@choice}{\sysu@@choices}%
  %
  % 将 \meta{default} 赋值到 \cs{sysu@\meta{name}}，如果非空则执行相应的代码。
  %
  \expandafter\let\csname sysu@\@nameuse{sysu@#1@@name}\endcsname\sysu@@default
  \expandafter\ifx\csname sysu@\@nameuse{sysu@#1@@name}\endcsname\@empty\else
    \@nameuse{sysu@#1@@check}%
  \fi
  %
  % 定义 \cs{sysusetup} 接口。
  %
  \kv@define@key{sysu}{#1}{%
    \@namedef{sysu@\@nameuse{sysu@#1@@name}}{##1}%
    \@nameuse{sysu@#1@@check}%
    \@nameuse{sysu@#1@@code}%
  }%
}

% 定义接口向 |key| 添加 |code|：

\newcommand\sysu@option@hook[2]{%
  \expandafter\g@addto@macro\csname sysu@#1@@code\endcsname{#2}%
}

\sysu@define@key{
  degree = {
    choices = {
      doctor,
      master,
      bachelor,
    },
    default = doctor,
  },
  degree-type = {
    name = degree@type,
    choices = {
      academic,
      professional,
    },
    default = academic,
  },
  main-language = {
    name = main@language,
    choices = {
      chinese,
      english,
    },
    default = chinese,
  },
  language = {
    choices = {
      chinese,
      english,
    },
    default = chinese,
  },
  system = {
    choices = {
      auto,
      mac,
      unix,
      windows,
    },
    default = auto,
  },
  logo-path = {
    name = logo@path,
    default = image/template/, % 此处修改 logo 目录，方便后面不与论文图片混在一起
  },
  fontset = {
    choices = {
      auto,
      windows,
      mac,
      ubuntu,
      fandol,
      none,
    },
    default = auto,
  },
  font = {
    choices = {
      auto,
      times,
      termes,
      stix,
      xits,
      libertinus,
      newcm,
      lm,
      newtx,
      none,
    },
    default = auto,
  },
  cjk-font = {
    name = cjk@font,
    choices = {
      auto,
      windows,
      mac,
      noto,
      fandol,
      none,
    },
    default = auto,
  },
  math-font = {
    name = math@font,
    choices = {
      auto,
      stix,
      xits,
      libertinus,
      newcm,
      cm,
      lm,
      newtx,
      none,
    },
    default = auto,
  },
  math-style = {
    name = math@style,
    choices = {
      GB,
      ISO,
      TeX,
    },
  },
  uppercase-greek = {
    name = uppercase@greek,
    choices = {
      italic,
      upright,
    },
  },
  less-than-or-equal = {
    name = leq,
    choices = {
      slanted,
      horizontal,
    },
  },
  integral = {
    choices = {
      upright,
      slanted,
    },
  },
  integral-limits = {
    name = integral@limits,
    choices = {
      true,
      false,
    },
  },
  partial = {
    choices = {
      upright,
      italic,
    },
  },
  math-ellipsis = {
    name = math@ellipsis,
    choices = {
      centered,
      lower,
      AMS,
    },
  },
  real-part = {
    name = real@part,
    choices = {
      roman,
      fraktur,
    },
  },
  cite-style = {
    name = cite@style,
    choices = {
      super,
      inline,
      authoryear,
    },
  },
  output = {
    choices = {
      print,
      electronic,
    },
    default = print,
  },
  section-style = {
    name = section@style,
    choices = {
      chinese,
      arabic,
    },
    default = chinese,
  },
  badge-color = {
    name = badge@color,
    choices = {
      green,
      red,
      black,
    },
    default = green,
  },
  reviewer = {
    choices = {
      true,
      false,
    },
    default = false,
  },
}

% 将 \sysu@cite@style 置空方便后续进行判断。
\def\sysu@cite@style{}

\newif\ifsysu@degree@graduate
\newcommand\sysu@set@graduate{%
  \ifsysu@degree@bachelor
    \sysu@degree@graduatefalse
  \else
    \sysu@degree@graduatetrue
  \fi
}
\sysu@set@graduate
\sysu@option@hook{degree}{%
  \sysu@set@graduate
}

% 使用 \pkg{kvoptions} 提供的 key-value 接口，
\SetupKeyvalOptions{
  family  = sysu,
  prefix  = sysu@,
  setkeys = \kvsetkeys,
}

% 设置默认 \option{openany}。
\DeclareBoolOption[false]{openright}
\DeclareComplementaryOption{openany}{openright}

% 兼容旧版本的文档类选项。
% Reserved for compatibility until 2020-07-01.
\DeclareVoidOption{doctor}{\sysusetup{degree=doctor}}
\DeclareVoidOption{master}{\sysusetup{degree=master}}
\DeclareVoidOption{bachelor}{\sysusetup{degree=bachelor}}
\DeclareVoidOption{chinese}{\sysusetup{language=chinese}}
\DeclareVoidOption{english}{\sysusetup{language=english}}
\DeclareVoidOption{academic}{\sysusetup{degree-type=academic}}
\DeclareVoidOption{professional}{\sysusetup{degree-type=professional}}
\DeclareVoidOption{print}{\sysusetup{output=print}}
\DeclareVoidOption{pdf}{\sysusetup{output=electronic}}
\newif\ifsysu@legacy@cite@style
\DeclareVoidOption{super}{\sysusetup{cite-style=super}\sysu@legacy@cite@styletrue}
\DeclareVoidOption{numbers}{\sysusetup{cite-style=inline}\sysu@legacy@cite@styletrue}
\DeclareVoidOption{authoryear}{\sysusetup{cite-style=authoryear}\sysu@legacy@cite@styletrue}
\DeclareVoidOption{arabic}{\sysusetup{section-style=arabic}}

% 载入 \cls{ctexbook}。
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{ctexbook}}
\ProcessKeyvalOptions*


% \subsection{加载文档类和宏包}

\ifsysu@openright
  \PassOptionsToClass{openright}{book}
\else
  \PassOptionsToClass{openany}{book}
\fi

\ifsysu@output@electronic
  \PassOptionsToClass{oneside}{book}
\fi
\PassOptionsToPackage{no-math}{fontspec}

% 载入 \cls{ctexbook} 文档类，注意要求为 2.4.9 或更高的版本。
\LoadClass[UTF8,a4paper,scheme=plain,zihao=-4,fontset=none]{ctexbook}[2017/04/01]

% 建议在模板开始处载入全部宏包，不要轻易改变加载顺序。
% \pkg{hyperref} 一般在最后加载。
\RequirePackage{etoolbox}
\RequirePackage{amsmath}
\RequirePackage{fontspec}[2017/03/31]
\RequirePackage{geometry}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage{booktabs}
\RequirePackage{color}
\RequirePackage{colortbl}
\RequirePackage{xcolor}
\RequirePackage{titletoc}
\RequirePackage{caption}
\RequirePackage{subcaption}
\RequirePackage{enumitem}
\RequirePackage[perpage]{footmisc}
\RequirePackage{url}
\RequirePackage{notoccite}
\RequirePackage{makecell}
\RequirePackage{multirow}
\RequirePackage{csvsimple-l3} % 将 csv 表格导入到文本中
\RequirePackage{adjustbox}
\RequirePackage{tabularx} % for 'tabularx' env. and 'X' col. type
%\RequirePackage{titlesec}

% 如果用户在导言区未调用 \pkg{biblatex}，则自动调用 \pkg{natbib}。
\AtEndPreamble{
  \@ifpackageloaded{biblatex}{}{
    \RequirePackage{natbib}
  }
}

% 对冲突的宏包报错。
\RequirePackage{filehook}
\newcommand\sysu@package@conflict[2]{
  \AtEndOfPackageFile*{#1}{%
    \AtBeginOfPackageFile*{#2}{%
      \sysu@error{The "#2" package is incompatible with "#1"}%
    }%
  }%
}

\sysu@package@conflict{biblatex}{bibunits}
\sysu@package@conflict{biblatex}{chapterbib}
\sysu@package@conflict{biblatex}{cite}
\sysu@package@conflict{biblatex}{multibib}
\sysu@package@conflict{biblatex}{natbib}

\sysu@package@conflict{bibunits}{biblatex}
\sysu@package@conflict{bibunits}{chapterbib}
\sysu@package@conflict{bibunits}{multibib}

\sysu@package@conflict{unicode-math}{amscd}
\sysu@package@conflict{unicode-math}{amsfonts}
\sysu@package@conflict{unicode-math}{amssymb}
\sysu@package@conflict{unicode-math}{bbm}
\sysu@package@conflict{unicode-math}{bm}
\sysu@package@conflict{unicode-math}{eucal}
\sysu@package@conflict{unicode-math}{eufrak}
\sysu@package@conflict{unicode-math}{mathrsfs}
\sysu@package@conflict{unicode-math}{newtxmath}
\sysu@package@conflict{unicode-math}{upgreek}

\sysu@package@conflict{natbib}{biblatex}
\sysu@package@conflict{natbib}{cite}

\sysu@package@conflict{newtxmath}{amsfonts}
\sysu@package@conflict{newtxmath}{amssymb}
\sysu@package@conflict{newtxmath}{unicode-math}
\sysu@package@conflict{newtxmath}{upgreek}


% \pkg{amsthm} 需要在 \pkg{newtx} 前载入，参考 \pkg{newtx} 的文档。
\AtBeginOfPackageFile*{amsthm}{
  \@ifpackageloaded{newtxmath}{
    \sysu@error{The "amsthm" package should be loaded before setting "newtxmath"}
  }{}
}%


% \subsection{处理语言}

% 定义 \cs{sysu@main@language}，当在导言区修改 \option{language} 时，
% 保存为论文的主要语言；
% \cs{sysu@reset@main@language} 则用于正文中恢复为主要语言。
%    \begin{macrocode}
\sysusetup{main-language=\sysu@language}%
\let\sysu@main@language\sysu@language

\sysu@option@hook{language}{%
  \ifx\@begindocumenthook\@undefined\else
    \sysusetup{main-language=\sysu@language}%
    \let\sysu@main@language\sysu@language
  \fi
}
\newcommand\sysu@reset@main@language{%
  \sysusetup{language = \sysu@main@language}%
  \let\sysu@language\sysu@main@language
}

% 带圈数字和星号使用中文字体。
\ifLuaTeX
  % ctex 将带圈数字 U+2460–U+24FF 归入字符范围 3（ALchar），这里改回范围 6（JAchar）
  \ltjdefcharrange{3}{%
    "2000-"243F, "2500-"27BF, "2900-"29FF, "2B00-"2BFF}
  \ltjdefcharrange{6}{%
    "2460-"24FF, "2E80-"2EFF, "3000-"30FF, "3190-"319F, "31F0-"4DBF,
    "4E00-"9FFF, "F900-"FAFF, "FE10-"FE1F, "FE30-"FE6F, "FF00-"FFEF,
    "1B000-"1B16F, "1F100-"1F2FF, "20000-"3FFFF, "E0100-"E01EF}
\else
  \ifXeTeX
    \xeCJKDeclareCharClass{CJK}{"2460 -> "2473}
    \xeCJKDeclareCharClass{CJK}{"2605}
  \fi
\fi

% 由于 Unicode 的一些标点符号是中西文混用的：
% U+00B7、U+2013、U+2014、U+2018、U+2019、
% U+201C、U+201D、U+2025、U+2026、U+2E3A，
% 所以要根据语言设置正确的字体。
% https://github.com/CTeX-org/ctex-kit/issues/389
\newcommand\sysu@set@punctuations{%
  \ifsysu@language@chinese
    \ifLuaTeX
      \ltjsetparameter{jacharrange={+9}}
    \else
      \ifXeTeX
        \xeCJKDeclareCharClass{FullLeft}{"2018, "201C}%
        \xeCJKDeclareCharClass{FullRight}{
          "00B7, "2019, "201D, "2013, "2014, "2025, "2026, "2E3A,
        }%
      \fi
    \fi
  \else
    \ifLuaTeX
      \ltjsetparameter{jacharrange={-9}}
    \else
      \ifXeTeX
        \xeCJKDeclareCharClass{HalfLeft}{"2018, "201C}%
        \xeCJKDeclareCharClass{HalfRight}{
          "00B7, "2019, "201D, "2013, "2014, "2025, "2026, "2E3A,
        }%
      \fi
    \fi
  \fi
}
\sysu@set@punctuations
\sysu@option@hook{language}{\sysu@set@punctuations}

% 根据语言设置各章节的名称，只有在导言区设置 \option{language} 时会修改，
% 而在正文局部切换语言时则不变。

% 由于《撰写手册》中的“speciality”一词使用的是英式拼法，
% 所以“acknowledgements”也保持一致。
\newcommand\sysu@set@chapter@names{%
  \ifsysu@main@language@chinese
    \def\contentsname{目\hspace{2em} 录}%
    \def\listfigurename{插图目录}%
    \def\listtablename{附表目录}%
    \def\sysu@list@figure@table@name{插图和附表目录}%
    \ctexset{
      chapter/name   = {第,章},
    }%
    \def\bibname{参考文献}%
    \def\appendixname{附录}%
    \def\sysu@acknowledgements@name{致谢}%
    \def\sysu@achievements@name{在读期间取得的科研成果}%
    \newcommand\sysu@notation@name{符号说明}%
  \else
    \def\contentsname{Contents}%
    \def\listfigurename{List of Figures}%
    \def\listtablename{List of Tables}%
    \def\sysu@list@figure@table@name{List of Figures and Tables}%
    \ctexset{
      chapter/name   = {\chaptername\space},
    }%
    \def\bibname{Bibliography}%
    \def\appendixname{Appendix}%
    \def\sysu@acknowledgements@name{Acknowledgements}%
    \def\sysu@achievements@name{Research Achievements}%
    \def\sysu@notation@name{Notation}%
  \fi
}
\sysu@set@chapter@names
\sysu@option@hook{main-language}{\sysu@set@chapter@names}

% 这部分名称在正文中局部地修改语言时会发生变化。
\newcommand\sysu@set@names{%
  \ifsysu@language@chinese
    \def\figurename{图}%
    \def\tablename{表}%
  \else
    \def\figurename{Figure}%
    \def\tablename{Table}%
  \fi
}
\sysu@set@names
\sysu@option@hook{language}{\sysu@set@names}


% \subsection{字体}

% 字号

% 正文字号12bp，行距21bp；
% 其他命令的行距按照相同的的比例设置，如表~\ref{tab:fontsize}。
% \begin{table}[htb]
%   \centering
%   \caption{标准字体命令与字号、行距的对应}
%   \label{tab:fontsize}
%   \begin{tabular}{lllll}
%     \toprule
%     字体命令          & 字号 & bp   & 研究生行距 & 本科生行距 \\
%     \midrule
%     \cs{tiny}         & 小六 & 6.5  & 10.83      & 11.92      \\
%     \cs{scriptsize}   & 六号 & 7.5  & 12.5       & 13.75      \\
%     \cs{footnotesize} & 小五 & 9    & 15         & 16.5       \\
%     \cs{small}        & 五号 & 10.5 & 17.5       & 19.25      \\
%     \cs{normalsize}   & 小四 & 12   & 21         & 21         \\
%     \cs{large}        & 小三 & 15   & 25         & 27.5       \\
%     \cs{Large}        & 小二 & 18   & 30         & 33         \\
%     \cs{LARGE}        & 二号 & 22   & 36.67      & 40.33      \\
%     \cs{huge}         & 小一 & 24   & 40         & 44         \\
%     \cs{Huge}         & 一号 & 26   & 43.33      & 47.67      \\
%     \bottomrule
%   \end{tabular}
% \end{table}
%
% 表达式的行距：段前6磅、段后6磅。
%
% 注意重定义 \normalsize 应在 \pkg{unicode-math} 的 \cs{setmathfont} 前。
\newcommand\sysu@set@font@size{%
%  \ifsysu@degree@graduate
    \renewcommand\normalsize{%
      \@setfontsize\normalsize{12bp}{21bp}%
      \abovedisplayskip 6bp \@plus3bp \@minus3bp%
      \abovedisplayshortskip 6bp \@plus3bp \@minus3bp%
      \belowdisplayshortskip \abovedisplayshortskip
      \belowdisplayskip \abovedisplayskip
      \let\@listi\@listI}%
    %
    % 注意第~\ref{sec:list} 节去掉了列表的间距，所以不再修改 \cs{@listi}。
%  \else
%    \renewcommand\normalsize{%
%      \@setfontsize\normalsize{12bp}{21bp}%
%      \abovedisplayskip 12bp \@plus3bp \@minus7bp%
%      \abovedisplayshortskip 0bp \@plus3bp%
%      \belowdisplayshortskip 6.5bp \@plus3.5bp \@minus3bp%
%      \belowdisplayskip \abovedisplayskip
%      \let\@listi\@listI}%
%  \fi
  \normalsize
  \ifx\MakeRobust\@undefined \else
      \MakeRobust\normalsize
  \fi
}
\sysu@set@font@size
\sysu@option@hook{degree}{\sysu@set@font@size}

% 设置行距的倍数为 1。
\linespread{1}\selectfont


% 检测系统
\ifsysu@system@auto
  \IfFileExists{/System/Library/Fonts/Menlo.ttc}{
    \sysusetup{system = mac}
  }{
    \IfFileExists{/dev/null}{
      \IfFileExists{null:}{
        \sysusetup{system = windows}
      }{
        \sysusetup{system = unix}
      }
    }{
      \sysusetup{system = windows}
    }
  }
\fi

% 处理 \opt{fontset}
\ifsysu@fontset@auto
  \ifsysu@system@windows
    \sysusetup{fontset = windows}
  \else
    \IfFontExistsTF{SimSun}{
      \sysusetup{fontset = windows}
    }{
      \ifsysu@system@mac
        \sysusetup{fontset = mac}
      \else
        \IfFontExistsTF{Noto Serif CJK SC}{
          \sysusetup{fontset = ubuntu}
        }{
          \sysusetup{fontset = fandol}
        }
      \fi
    }
  \fi
\fi

% 西文字体使用 Times New Roman 和 Arial，
% 但是在 Linux 下没有这两个字体，所以使用它们的克隆版 TeX Gyre Termes 和
% TeX Gyre Heros。
\ifsysu@font@auto
  \ifsysu@fontset@windows
    \sysusetup{font=times}
  \else
    \ifsysu@fontset@mac
      \sysusetup{font=times}
    \else
      \sysusetup{font=termes}
    \fi
  \fi
\fi

% Times New Roman + Arial
\newcommand\sysu@set@font@times{%
  \setmainfont{Times New Roman}%
  \setsansfont{Arial}%
  \ifsysu@system@mac
    \setmonofont{Menlo}[Scale = MatchLowercase]%
  \else
    \setmonofont{Courier New}[Scale = MatchLowercase]%
  \fi
}

% TeX Gyre Termes
\newcommand\sysu@set@font@termes{%
  \setmainfont{texgyretermes}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \sysu@set@texgyre@sans@mono
}

\newcommand\sysu@set@texgyre@sans@mono{%
  \setsansfont{texgyreheros}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \setmonofont{texgyrecursor}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
    Scale          = MatchLowercase,
    Ligatures      = CommonOff,
  ]%
}

% STIX Two 字体。
% STIX 文件名为
% \file{STIXTwoText-Regular.otf}、\file{STIXTwoMath-Regular.otf}。
\let\sysu@font@family@stix\@empty
\newcommand\sysu@set@stix@names{%
  \ifx\sysu@font@family@stix\@empty
    \IfFontExistsTF{STIXTwoText-Regular.otf}{%
      \gdef\sysu@font@family@stix{STIXTwoText}%
      \gdef\sysu@font@name@stix@math{STIXTwoMath-Regular}%
    }{%
      \gdef\sysu@font@family@stix{STIX2Text}%
      \gdef\sysu@font@name@stix@math{STIX2Math}%
    }%
  \fi
}

\newcommand\sysu@set@font@stix{%
  \sysu@set@stix@names
  \setmainfont{\sysu@font@family@stix}[
    Extension      = .otf,
    UprightFont    = *-Regular,
    BoldFont       = *-Bold,
    ItalicFont     = *-Italic,
    BoldItalicFont = *-BoldItalic,
  ]%
  \sysu@set@texgyre@sans@mono
}

% XITS 字体。
% XITS 的文件名为
% \file{XITS-Regular.otf}、\file{XITSMath-Regular.otf}。
\let\sysu@font@family@xits\@empty
\newcommand\sysu@set@xits@names{%
  \ifx\sysu@font@family@xits\@empty
    \IfFontExistsTF{XITSMath-Regular.otf}{%
      \gdef\sysu@font@family@xits{XITS}%
      \gdef\sysu@font@style@xits@rm{Regular}%
      \gdef\sysu@font@style@xits@bf{Bold}%
      \gdef\sysu@font@style@xits@it{Italic}%
      \gdef\sysu@font@style@xits@bfit{BoldItalic}%
      \gdef\sysu@font@name@xits@math{XITSMath-Regular}%
    }{%
      \gdef\sysu@font@family@xits{xits}%
      \gdef\sysu@font@style@xits@rm{regular}%
      \gdef\sysu@font@style@xits@bf{bold}%
      \gdef\sysu@font@style@xits@it{italic}%
      \gdef\sysu@font@style@xits@bfit{bolditalic}%
      \gdef\sysu@font@name@xits@math{xits-math}%
    }%
  \fi
}

\newcommand\sysu@set@font@xits{%
  \sysu@set@xits@names
  \setmainfont{\sysu@font@family@xits}[
    Extension      = .otf,
    UprightFont    = *-\sysu@font@style@xits@rm,
    BoldFont       = *-\sysu@font@style@xits@bf,
    ItalicFont     = *-\sysu@font@style@xits@it,
    BoldItalicFont = *-\sysu@font@style@xits@bfit,
  ]%
  \sysu@set@texgyre@sans@mono
}

% Libertinus 的文件名为驼峰式，
% 在大小写敏感的平台上需要进行判断。
\let\sysu@font@family@libertinus\@empty
\newcommand\sysu@set@libertinus@names{%
  \ifx\sysu@font@family@libertinus\@empty
    \IfFontExistsTF{LibertinusSerif-Regular.otf}{%
      \gdef\sysu@font@family@libertinus@serif{LibertinusSerif}%
      \gdef\sysu@font@family@libertinus@sans{LibertinusSans}%
      \gdef\sysu@font@name@libertinus@math{LibertinusMath-Regular}%
      \gdef\sysu@font@style@libertinus@rm{Regular}%
      \gdef\sysu@font@style@libertinus@bf{Bold}%
      \gdef\sysu@font@style@libertinus@it{Italic}%
      \gdef\sysu@font@style@libertinus@bfit{BoldItalic}%
    }{%
      \gdef\sysu@font@family@libertinus@serif{libertinusserif}%
      \gdef\sysu@font@family@libertinus@sans{libertinussans}%
      \gdef\sysu@font@name@libertinus@math{libertinusmath-regular}%
      \gdef\sysu@font@style@libertinus@rm{regular}%
      \gdef\sysu@font@style@libertinus@bf{bold}%
      \gdef\sysu@font@style@libertinus@it{italic}%
      \gdef\sysu@font@style@libertinus@bfit{bolditalic}%
    }%
  \fi
}

\newcommand\sysu@set@font@libertinus{%
  \sysu@set@libertinus@names
  \setmainfont{\sysu@font@family@libertinus@serif}[
    Extension      = .otf,
    UprightFont    = *-\sysu@font@style@libertinus@rm,
    BoldFont       = *-\sysu@font@style@libertinus@bf,
    ItalicFont     = *-\sysu@font@style@libertinus@it,
    BoldItalicFont = *-\sysu@font@style@libertinus@bfit,
  ]%
  \setsansfont{\sysu@font@family@libertinus@sans}[
    Extension      = .otf,
    UprightFont    = *-\sysu@font@style@libertinus@rm,
    BoldFont       = *-\sysu@font@style@libertinus@bf,
    ItalicFont     = *-\sysu@font@style@libertinus@it,
  ]%
  \setmonofont{lmmonolt10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
}

% New Computer Modern
\newcommand\sysu@set@font@newcm{%
  \setmainfont{NewCM10}[
    Extension      = .otf,
    UprightFont    = *-Book,
    BoldFont       = *-Bold,
    ItalicFont     = *-BookItalic,
    BoldItalicFont = *-BoldItalic,
  ]%
  \setsansfont{NewCMSans10}[
    Extension         = .otf,
    UprightFont       = *-Book,
    BoldFont          = *-Bold,
    ItalicFont        = *-BookOblique,
    BoldItalicFont    = *-BoldOblique,
  ]%
  \setmonofont{NewCMMono10}[
    Extension           = .otf,
    UprightFont         = *-Book,
    ItalicFont          = *-BookItalic,
    BoldFont            = *-Bold,
    BoldItalicFont      = *-BoldOblique,
  ]%
}

% Latin Modern
\newcommand\sysu@set@font@lm{%
  \setmainfont{lmroman10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \setsansfont{lmsans10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
  \setmonofont{lmmonolt10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
}

\newcommand\sysu@set@font@newtx{%
  \RequirePackage{newtxtext}%
}

\newcommand\sysu@set@font{%
  \@nameuse{sysu@set@font@\sysu@font}%
}
\sysu@set@font
\sysu@option@hook{font}{\sysu@set@font}

% 中文字体
\ifsysu@cjk@font@auto
  \ifsysu@fontset@mac
    \sysusetup{cjk-font = mac}
  \else
    \ifsysu@fontset@windows
      \sysusetup{cjk-font = windows}
    \else
      \ifsysu@fontset@ubuntu
        \sysusetup{cjk-font = noto}
      \else
        \sysusetup{cjk-font = fandol}
      \fi
    \fi
  \fi
\fi

% Windows 的中易字体。
\newcommand\sysu@set@cjk@font@windows{%
  \setCJKmainfont{SimSun}[
    AutoFakeBold = 3,
    ItalicFont   = KaiTi,
  ]%
  \setCJKsansfont{SimHei}[AutoFakeBold = 3]%
  \setCJKmonofont{FangSong}%
  \setCJKfamilyfont{zhsong}{SimSun}[AutoFakeBold = 3]%
  \setCJKfamilyfont{zhhei}{SimHei}[AutoFakeBold = 3]%
  \setCJKfamilyfont{zhkai}{KaiTi}%
  \setCJKfamilyfont{zhfs}{FangSong}%
}

% macOS 的华文字体。
\newcommand\sysu@set@cjk@font@mac{%
  \defaultCJKfontfeatures{}%
  \setCJKmainfont{Songti SC}[
    UprightFont    = * Light,
    BoldFont       = * Bold,
    ItalicFont     = Kaiti SC Regular,
    BoldItalicFont = Kaiti SC Bold,
  ]%
  \setCJKsansfont{Heiti SC}[
    UprightFont    = * Light,
    BoldFont       = * Medium,
  ]%
  \setCJKmonofont{STFangsong}
  \setCJKfamilyfont{zhsong}{Songti SC}[
    UprightFont    = * Light,
    BoldFont       = * Bold,
  ]%
  \setCJKfamilyfont{zhhei}{Heiti SC}[
    UprightFont    = * Light,
    BoldFont       = * Medium,
  ]%
  \setCJKfamilyfont{zhfs}{STFangsong}%
  \setCJKfamilyfont{zhkai}{Kaiti SC}[
    UprightFont    = * Regular,
    BoldFont       = * Bold,
  ]%
  \setCJKfamilyfont{zhli}{Baoli SC}%
  \setCJKfamilyfont{zhyuan}{Yuanyi SC}[
    UprightFont    = * Light,
    BoldFont       = * Bold,
  ]%
}

% 思源字体。
% 注意 Noto CJK 的 regular 字重名字不带“Regular”。
\newcommand\sysu@set@cjk@font@noto{%
  \defaultCJKfontfeatures{}%
  \setCJKmainfont{Noto Serif CJK SC}[
    UprightFont    = * Light,
    BoldFont       = * Bold,
    ItalicFont     = FandolKai-Regular,
    ItalicFeatures = {Extension = .otf},
    Script         = CJK,
  ]%
  \setCJKsansfont{Noto Sans CJK SC}[
    BoldFont       = * Medium,
    Script         = CJK,
  ]%
  \setCJKmonofont{Noto Sans Mono CJK SC}[
    Script         = CJK,
  ]%
  \setCJKfamilyfont{zhsong}{Noto Serif CJK SC}[
    UprightFont    = * Light,
    UprightFont    = * Bold,
    Script         = CJK,
  ]%
  \setCJKfamilyfont{zhhei}{Noto Sans CJK SC}[
    BoldFont       = * Medium,
    Script         = CJK,
  ]%
  \setCJKfamilyfont{zhfs}{FandolFang}[
    Extension      = .otf,
    UprightFont    = *-Regular,
  ]%
  \setCJKfamilyfont{zhkai}{FandolKai}[
    Extension      = .otf,
    UprightFont    = *-Regular,
  ]%
}

% Fandol 字体。
\newcommand\sysu@set@cjk@font@fandol{%
  \defaultCJKfontfeatures{}%
  \setCJKmainfont{FandolSong}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
    ItalicFont  = FandolKai-Regular,
    ItalicFeatures = {Extension = .otf},
  ]%
  \setCJKsansfont{FandolHei}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
  \setCJKmonofont{FandolFang}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhsong}{FandolSong}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
  \setCJKfamilyfont{zhhei}{FandolHei}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
  \setCJKfamilyfont{zhfs}{FandolFang}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhkai}{FandolKai}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
}

\ifsysu@cjk@font@none\else
  \providecommand\songti{\CJKfamily{zhsong}}
  \providecommand\heiti{\CJKfamily{zhhei}}
  \providecommand\fangsong{\CJKfamily{zhfs}}
  \providecommand\kaishu{\CJKfamily{zhkai}}
\fi

\newcommand\sysu@set@cjk@font{%
  \@nameuse{sysu@set@cjk@font@\sysu@cjk@font}%
}
\sysu@set@cjk@font
\sysu@option@hook{cjk-font}{\sysu@set@cjk@font}

% 数学字体

% 设置数学符号风格。
\newcommand\sysu@set@math@style{%
  \ifsysu@math@style@TeX
    \sysusetup{
      uppercase-greek    = upright,
      less-than-or-equal = horizontal,
      integral           = slanted,
      integral-limits    = false,
      partial            = italic,
      math-ellipsis      = AMS,
      real-part          = fraktur,
    }%
  \else
    \sysusetup{
      uppercase-greek = italic,
      integral        = upright,
      partial         = upright,
      real-part       = roman,
    }%
    \ifsysu@math@style@ISO
      \sysusetup{
        less-than-or-equal = horizontal,
        integral-limits    = true,
        math-ellipsis      = lower,
      }%
    \else
      \ifsysu@math@style@GB
        \sysusetup{
          less-than-or-equal = slanted,
          integral-limits    = false,
          math-ellipsis      = centered,
        }%
      \fi
    \fi
  \fi
}

\ifsysu@main@language@chinese
  \sysusetup{math-style = GB}%
\else
  \sysusetup{math-style = TeX}%
\fi

\sysu@set@math@style
\sysu@option@hook{math-style}{\sysu@set@math@style}
\sysu@option@hook{main-language}{%
  \ifsysu@main@language@chinese
    \sysusetup{math-style = GB}%
  \else
    \sysusetup{math-style = TeX}%
  \fi
}

% 针对 \pkg{unicode-math} 逐项配置数学符号。

\newcommand\sysu@set@unimath@leq{%
  \ifsysu@leq@horizontal
    \ifx\@begindocumenthook\@undefined
      \let\le\sysu@save@leq
      \let\ge\sysu@save@geq
      \let\leq\sysu@save@leq
      \let\geq\sysu@save@geq
    \else
      \AtBeginDocument{%
        \let\le\sysu@save@leq
        \let\ge\sysu@save@geq
        \let\leq\sysu@save@leq
        \let\geq\sysu@save@geq
      }%
    \fi
  \else
    \ifsysu@leq@slanted
      \ifx\@begindocumenthook\@undefined
        \let\le\leqslant
        \let\ge\geqslant
        \let\leq\leqslant
        \let\geq\geqslant
      \else
        \AtBeginDocument{%
          \let\le\leqslant
          \let\ge\geqslant
          \let\leq\leqslant
          \let\geq\geqslant
        }%
      \fi
    \fi
  \fi
}
\newcommand\sysu@set@unimath@integral@limits{%
  \ifsysu@integral@limits@true
    \removenolimits{%
      \int\iint\iiint\iiiint\oint\oiint\oiiint
      \intclockwise\varointclockwise\ointctrclockwise\sumint
      \intbar\intBar\fint\cirfnint\awint\rppolint
      \scpolint\npolint\pointint\sqint\intlarhk\intx
      \intcap\intcup\upint\lowint
    }%
  \else
    \addnolimits{%
      \int\iint\iiint\iiiint\oint\oiint\oiiint
      \intclockwise\varointclockwise\ointctrclockwise\sumint
      \intbar\intBar\fint\cirfnint\awint\rppolint
      \scpolint\npolint\pointint\sqint\intlarhk\intx
      \intcap\intcup\upint\lowint
    }%
  \fi
}
\newcommand\sysu@set@unimath@ellipsis{%
  \ifsysu@math@ellipsis@centered
    \DeclareRobustCommand\mathellipsis{\mathinner{\unicodecdots}}%
  \else
    \DeclareRobustCommand\mathellipsis{\mathinner{\unicodeellipsis}}%
  \fi
}
\newcommand\sysu@set@unimath@real@part{%
  \ifsysu@real@part@roman
    \AtBeginDocument{%
      \def\Re{\operatorname{Re}}%
      \def\Im{\operatorname{Im}}%
    }%
  \else
    \AtBeginDocument{%
      \let\Re\sysu@save@Re
      \let\Im\sysu@save@Im
    }%
  \fi
}

\newcommand\sysu@set@unimath@style{%
  \ifsysu@uppercase@greek@upright
    \unimathsetup{math-style = TeX}%
  \else
    \ifsysu@uppercase@greek@italic
      \unimathsetup{math-style = ISO}%
    \fi
  \fi
  \ifsysu@math@style@TeX
    \unimathsetup{bold-style = TeX}%
  \else
    \unimathsetup{bold-style = ISO}%
  \fi
  \sysu@set@unimath@leq
  \sysu@set@unimath@integral@limits
  \ifsysu@partial@upright
    \unimathsetup{partial = upright}%
  \else
    \ifsysu@partial@italic
      \unimathsetup{partial = italic}%
    \fi
  \fi
  \sysu@set@unimath@ellipsis
  \sysu@set@unimath@real@part
}

\newcommand\sysu@qed{\rule{1ex}{1ex}}
\newcommand\sysu@load@unimath{%
  \@ifpackageloaded{unicode-math}{}{%
    \RequirePackage{unicode-math}%
    \AtBeginDocument{%
      \let\sysu@save@leq\leq
      \let\sysu@save@geq\geq
      \let\sysu@save@Re\Re
      \let\sysu@save@Im\Im
    }%
    %
    % 兼容旧的粗体命令：\pkg{bm} 的 \cs{bm} 和 \pkg{amsmath} 的 \cs{boldsymbol}。
    \DeclareRobustCommand\bm[1]{{\symbfit{##1}}}%
    \DeclareRobustCommand\boldsymbol[1]{{\symbfit{##1}}}%
    %
    % 兼容 \pkg{amsfonts} 和 \pkg{amssymb} 中的一些命令。
    \newcommand\square{\mdlgwhtsquare}%
    \newcommand\blacksquare{\mdlgblksquare}%
    \AtBeginDocument{%
      \renewcommand\checkmark{\ensuremath{✓}}%
    }%
    %
    % 兼容 \pkg{amsthm} 的 \cs{qedsymbol}。
    \renewcommand\sysu@qed{\ensuremath{\QED}}%
  }%
}

% STIX Two Math
\newcommand\sysu@set@math@font@stix{%
  \sysu@load@unimath
  \sysu@set@unimath@style
  \sysu@set@stix@names
  \setmathfont{\sysu@font@name@stix@math}[
    Extension    = .otf,
    Scale        = MatchLowercase,
    StylisticSet = \sysu@xits@integral@stylistic@set,
  ]%
  \setmathfont{\sysu@font@name@stix@math}[
    Extension    = .otf,
    Scale        = MatchLowercase,
    StylisticSet = 1,
    range        = {scr,bfscr},
  ]%
}

% XITS Math
\newcommand\sysu@xits@integral@stylistic@set{%
  \ifsysu@integral@upright
    8%
  \fi
}
\newcommand\sysu@set@math@font@xits{%
  \sysu@load@unimath
  \sysu@set@unimath@style
  \sysu@set@xits@names
  \setmathfont{\sysu@font@name@xits@math}[
    Extension    = .otf,
    StylisticSet = \sysu@xits@integral@stylistic@set,
  ]%
  \setmathfont{\sysu@font@name@xits@math}[
    Extension    = .otf,
    StylisticSet = 1,
    range        = {cal,bfcal},
  ]%
}

% Libertinus Math
\newcommand\sysu@libertinus@integral@stylistic@set{%
  \ifsysu@integral@slanted
    8%
  \fi
}
\newcommand\sysu@set@math@font@libertinus{%
  \sysu@load@unimath
  \sysu@set@unimath@style
  \sysu@set@libertinus@names
  \sysu@set@xits@names
  \setmathfont{\sysu@font@name@libertinus@math}[
    Extension    = .otf,
    StylisticSet = \sysu@libertinus@integral@stylistic@set,
  ]%
  \setmathfont{\sysu@font@name@xits@math}[
    Extension    = .otf,
    range        = {\checkmark},
  ]%
}

% New Computer Modern Math
\newcommand\sysu@newcm@integral@stylistic@set{%
  \ifsysu@integral@upright
    2%
  \fi
}
\newcommand\sysu@set@math@font@newcm{%
  \sysu@load@unimath
  \sysu@set@unimath@style
  \setmathfont{NewCMMath-Book}[
    Extension    = .otf,
    StylisticSet = \sysu@newcm@integral@stylistic@set,
  ]%
  \setmathfont{NewCMMath-Book}[
    Extension    = .otf,
    StylisticSet = 1,
    range        = {scr,bfscr},
  ]%
  \setmathrm{NewCM10}[
    Extension      = .otf,
    UprightFont    = *-Book,
    BoldFont       = *-Bold,
    ItalicFont     = *-BookItalic,
    BoldItalicFont = *-BoldItalic,
  ]%
  \setmathsf{NewCMSans10}[
    Extension         = .otf,
    UprightFont       = *-Book,
    BoldFont          = *-Bold,
    ItalicFont        = *-BookOblique,
    BoldItalicFont    = *-BoldOblique,
  ]%
  \setmathtt{NewCMMono10}[
    Extension           = .otf,
    UprightFont         = *-Book,
    ItalicFont          = *-BookItalic,
    BoldFont            = *-Bold,
    BoldItalicFont      = *-BoldOblique,
  ]%
}

% Latin Modern Math
\newcommand\sysu@set@math@font@lm{%
  \sysu@load@unimath
  \sysu@set@unimath@style
  \setmathfont{latinmodern-math}[Extension=.otf]%
  \setmathrm{lmroman10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \setmathsf{lmsans10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
  \setmathtt{lmmonolt10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
}

% NewTX Math
% 注意 NewTX Math 是 Type 1 字体，如果正文西文使用了 OpenType 字体时需要小心处理。
\newcommand\sysu@set@math@font@newtx{%
  \ifsysu@font@newtx\else
    \let\sysu@save@encodingdefault\encodingdefault
    \let\sysu@save@rmdefault\rmdefault
    \let\sysu@save@sfdefault\sfdefault
    \let\sysu@save@ttdefault\ttdefault
    \RequirePackage[T1]{fontenc}%
    \renewcommand{\rmdefault}{ntxtlf}%
    \renewcommand{\sfdefault}{qhv}%
    \renewcommand{\ttdefault}{ntxtt}%
  \fi
  \ifsysu@uppercase@greek@italic
    \PassOptionsToPackage{slantedGreek}{newtxmath}%
  \fi
  \ifsysu@integral@upright
    \PassOptionsToPackage{upint}{newtxmath}%
  \fi
  \RequirePackage{newtxmath}
  \let\sysu@save@leq\leq
  \let\sysu@save@geq\geq
  \ifsysu@leq@slanted
    \let\le\leqslant
    \let\ge\geqslant
    \let\leq\leqslant
    \let\geq\geqslant
  \fi
  \ifsysu@integral@limits@true
    \let\ilimits@\displaylimits
  \fi
  \let\sysu@save@partial\partial
  \ifsysu@partial@upright
    \let\partial\uppartial
  \fi
  \ifsysu@math@ellipsis@centered
    \DeclareRobustCommand\mathellipsis{\mathinner{\cdotp\cdotp\cdotp}}%
  \else
    \DeclareRobustCommand\mathellipsis{\mathinner{\ldotp\ldotp\ldotp}}%
  \fi
  \let\sysu@save@Re\Re
  \let\sysu@save@Im\Im
  \ifsysu@real@part@roman
    \def\Re{\operatorname{Re}}%
    \def\Im{\operatorname{Im}}%
  \fi
  \RequirePackage{bm}%
  \ifsysu@font@newtx\else
    \let\encodingdefault\sysu@save@encodingdefault
    \let\rmdefault\sysu@save@rmdefault
    \let\sfdefault\sysu@save@sfdefault
    \let\ttdefault\sysu@save@ttdefault
  \fi
  \DeclareRobustCommand\symup[1]{{\mathrm{##1}}}%
  \DeclareRobustCommand\symbf[1]{{\bm{##1}}}%
  \DeclareRobustCommand\symbfsf[1]{{\bm{##1}}}%
  \let\increment\upDelta%
  \renewcommand\sysu@qed{\openbox}%
}

% Computer Modern
% 使用 LaTeX 默认的 cm 字体
\newcommand\sysu@set@math@font@cm{%
  \RequirePackage{amssymb}
  \let\sysu@save@leq\leq
  \let\sysu@save@geq\geq
  \ifsysu@leq@slanted
    \let\le\leqslant
    \let\ge\geqslant
    \let\leq\leqslant
    \let\geq\geqslant
  \fi
  \ifsysu@integral@limits@true
    \let\ilimits@\displaylimits
  \fi
  \ifsysu@math@ellipsis@centered
    \DeclareRobustCommand\mathellipsis{\mathinner{\cdotp\cdotp\cdotp}}%
  \else
    \DeclareRobustCommand\mathellipsis{\mathinner{\ldotp\ldotp\ldotp}}%
  \fi
  \let\sysu@save@Re\Re
  \let\sysu@save@Im\Im
  \ifsysu@real@part@roman
    \def\Re{\operatorname{Re}}%
    \def\Im{\operatorname{Im}}%
  \fi
  \RequirePackage{bm}%
  \DeclareRobustCommand\symup[1]{{\mathrm{##1}}}%
  \DeclareRobustCommand\symbf[1]{{\bm{##1}}}%
  \DeclareRobustCommand\symbfsf[1]{{\bm{##1}}}%
  \let\increment\Delta
  \renewcommand\sysu@qed{\openbox}%
  \let\uppi\pi
}

% 不设置数学字体，仅提供兼容支持。
\newcommand\sysu@set@math@font@none{%
  \RequirePackage{amssymb}
  \RequirePackage{bm}%
  \DeclareRobustCommand\symup[1]{{\mathrm{##1}}}%
  \DeclareRobustCommand\symbf[1]{{\bm{##1}}}%
  \DeclareRobustCommand\symbfsf[1]{{\bm{##1}}}%
  \let\increment\Delta
  \renewcommand\sysu@qed{\openbox}%
  \let\uppi\pi
}

\newcommand\sysu@set@math@font{%
  \@nameuse{sysu@set@math@font@\sysu@math@font}%
}
\sysu@option@hook{math-font}{\g@addto@macro\sysu@setup@hook{\sysu@set@math@font}}
\newcommand\sysu@set@math@font@auto{%
  \ifsysu@math@font@auto
    \sysusetup{math-font=xits}%
  \fi
}
\AtBeginOfPackageFile*{siunitx}{\sysu@set@math@font@auto}
\AtEndPreamble{%
  \sysu@set@math@font@auto
  \ifx\square\@undefined
    \RequirePackage{amssymb}%
  \fi
}



% \subsection{纸张和页面}
% 使用 \pkg{geometry} 宏包设置纸张和页面。

% 纸张：A4；

% 纸张大小：标准A4（21.0cm×29.7cm）尺寸。
% 页边距：研究生：上、下、左、右、装订线的页边距分别为：2.54cm，2.54cm，3.17cm，3.17cm，0cm。装订线位置：左。左右对称页边距。
% 本科生：上、下、左、右、装订线的页边距分别为：2.5cm，2.0cm，3.0cm，3.0cm，0cm。装订线位置：左。左右对称页边距。
% 页眉距边界2.0cm
% 页脚距边界1.75cm
\ifsysu@degree@graduate
  \geometry{
    paper      = a4paper,
    vmargin    = 2.54cm,
    hmargin    = 3.17cm,
    headheight = 0.53cm,
    headsep    = 0.25cm,
    footskip   = 0.79cm,
  }
\else
  \geometry{
  	paper      = a4paper,
  	top        = 2.5cm,
  	bottom     = 2.0cm,
  	hmargin    = 3.0cm,
  }
\fi

% 使用 \pkg{fancy} 需要先调用 |\pagestyle{fancy}| 再修改 \cs{chaptermark} 和
% \cs{sectionmark}。
\pagestyle{fancy}
\let\sectionmark\@gobble
\renewcommand\headrulewidth{0.5\p@}

% 重定义默认的 |plain| page style，会显示页眉和页脚。
\fancypagestyle{plain}{%
  \fancyhf{}%
  %
  % 奇数页眉与该部分的章标题相同，偶数页眉为“中山大学博士/硕士论文”，宋体 9 磅（小五号）居中。
  % 页码：宋体 9 磅、页面页脚居中。
  \ifsysu@degree@graduate
    \def\sysu@hf@font{\fontsize{9bp}{12bp}\selectfont}
    \fancyhead[EC]{\sysu@hf@font\sysu@thesis@name}
    \fancyhead[OC]{\sysu@hf@font\leftmark}%
    \fancyfoot[C]{\sysu@hf@font\thepage}%
    \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markboth{\CTEXifname{\CTEXthechapter\quad}{}##1}{\sysu@thesis@name}%
    }%
    \let\sectionmark\@gobble
  \else
    %
    % 本科生要求除封面、扉页外，每面上部加页眉，
    % 用小 5 号字（9 bp）标注“中山大学本科毕业论文”，居中；
    \def\sysu@hf@font{\fontsize{9bp}{12bp}\selectfont}
    \fancyhead[C]{\sysu@hf@font 中山大学本科毕业论文}%
    \fancyfoot[C]{\sysu@hf@font\thepage}%
    \let\@mkboth\@gobbletwo
    \let\chaptermark\@gobble
    \let\sectionmark\@gobble
  \fi
}
\pagestyle{plain}

% |headings| 只有页眉，没有页脚，用于本科生的 front matter。
\fancypagestyle{headings}{\fancyfoot{}}

% 设置特殊的 page style 不改变任何内容，用于每章首页。
\def\ps@chapter{}
\ctexset{chapter/pagestyle=chapter}

% 空白页无任何内容。
\fancypagestyle{blank}{%
  \fancyhf{}%
  \renewcommand\headrulewidth{0pt}%
%  \fancyfoot[C]{\sysu@hf@font\thepage}%
}

\newif\ifsysu@title@page

\def\cleardoublepage{%
  \clearpage
  \if@twoside
    \ifodd\c@page\else
      \hbox{}%
      \ifsysu@title@page
        % 封面的空白页不显示页码
        \thispagestyle{empty}%
      \else
        \thispagestyle{blank}%
      \fi
      \newpage
      \if@twocolumn
        \hbox{}%
        \newpage
      \fi
    \fi
  \fi
}

%
% 从“中文摘要”开始页码用大写罗马数字。
\renewcommand\frontmatter{%
	\cleardoublepage
	\@mainmatterfalse
	\pagenumbering{Roman}%
	\pagestyle{plain}%
}

% “第 1 章”要从单数页起。
\renewcommand\mainmatter{%
    \cleardoublepage
    \pagenumbering{arabic}%
  \pagestyle{plain}%
  \@mainmattertrue
}

\g@addto@macro\appendix{\@mainmattertrue}%


% \subsection{封面}


% 定义用户接口：
\sysu@define@key{
  title = {
    default = {论文题目},
  },
  title* = {
    default = {Title},
    name    = title@en,
  },
  author = {
    default = {作者姓名},
  },
  author* = {
    default = {Author Name},
    name    = author@en,
  },
  speciality = {
    default = {专业},
  },
  speciality* = {
    default = {Speciality},
    name    = speciality@en,
  },
  supervisor = {
    default = {导师},
  },
  supervisor* = {
    default = {Supervisor Name},
    name    = supervisor@en,
  },
  practice-supervisor = {
    default = {},
    name    = practice@supervisor,
  },
  practice-supervisor* = {
    default = {},
    name    = practice@supervisor@en,
  },
  advisor = {
    name    = practice@supervisor,
  },
  advisor* = {
    name    = practice@supervisor@en,
  },
  date = {
    default = {\the\year-\two@digits{\month}-\two@digits{\day}},
  },
  professional-type = {
    name = professional@type,
  },
  professional-type* = {
    name = professional@type@en,
  },
  department,
  student-id = {
    name = student@id,
  },
  secret-level = {
    name    = secret@level,
  },
  secret-level* = {
    name    = secret@level@en,
  },
  secret-year = {
    name    = secret@year,
  },
  keywords,
  keywords* = {
    name    = keywords@en,
  },
  keywords** = {
  	name     = keywords@fr,
  },
}

% 导师一栏可能有多个姓名，所以用 \opt{supervisor} 进行收集，
% 然后使用本命令来输出要求的格式，
% 类似于 \LaTeX3 的 \cs{clist\_use:Nn}。
\newcommand\sysu@clist@count[1]{%
  \csname clist_count:N\endcsname{#1}%
}
\newcommand\sysu@clist@use[2]{%
  \csname clist_use:Nn\endcsname{#1}{#2}%
}
\newcommand\sysu@supervisor@names{%
  \sysu@clist@use{\sysu@supervisor}{\quad}
}
\newcommand\sysu@practice@supervisor@names{%
  \sysu@clist@use{\sysu@practice@supervisor}{\quad}
}
\newcounter{sysu@count}
\newcommand\sysu@supervisor@en@line{%
  \setcounter{sysu@count}{\sysu@clist@count{\sysu@supervisor@en}}%
  \ifnum\c@sysu@count>1\relax
    Supervisors:%
  \else
    Supervisor:%
  \fi
  \space\sysu@clist@use{\sysu@supervisor@en}{, }%
}
\newcommand\sysu@practice@supervisor@en@line{%
  \setcounter{sysu@count}{\sysu@clist@count{\sysu@practice@supervisor@en}}%
  \ifnum\c@sysu@count>1\relax
    Practice supervisors:%
  \else
    Practice supervisor:%
  \fi
  \space\sysu@clist@use{\sysu@practice@supervisor@en}{, }%
}

% 输出日期的给定格式：\cs{sysu@format@date}\marg{format}\marg{date}，
% 其中格式 \meta{format} 接受三个参数分别对应年、月、日，
% \meta{date} 是 ISO 格式的日期（yyyy-mm-dd）。
\newcommand\sysu@format@date[2]{%
  \edef\sysu@@date{#2}%
  \def\sysu@@process@date##1-##2-##3\@nil{%
    #1{##1}{##2}{##3}%
  }%
  \expandafter\sysu@@process@date\sysu@@date\@nil
}
\newcommand\sysu@date@format@zh@small[3]{\number#1 年 \number#2 月 \number#3 日}
\newcommand\sysu@date@format@zh@big[3]{\zhdigits{#1}年\zhnumber{#2}月\zhnumber{#3}日}
\newcommand\sysu@date@month[1]{%
  \ifcase\number#1\or
    January\or February\or March\or April\or May\or June\or
    July\or August\or September\or October\or November\or December%
  \fi
}
\newcommand\sysu@date@format@zh@short[3]{\number#1 年 \number#2 月}
\newcommand\sysu@date@format@en[3]{\sysu@date@month{#2} \number#3, #1}
\newcommand\sysu@date@zh@small{\sysu@format@date{\sysu@date@format@zh@small}{\sysu@date}}
\newcommand\sysu@date@zh@big{\sysu@format@date{\sysu@date@format@zh@big}{\sysu@date}}
\newcommand\sysu@date@zh@short{\sysu@format@date{\sysu@date@format@zh@short}{\sysu@date}}
\newcommand\sysu@date@en{\sysu@format@date{\sysu@date@format@en}{\sysu@date}}

% 版本 v3.2 开始使用 \cs{sysusetup} 设置接口，
% 兼容旧版本的命令式设置。
% Reserved for compatibility until 2020-07-01.
\def\sysu@define@term#1#2{%
  \expandafter\gdef\csname #1\endcsname##1{%
    \sysu@deprecated{'\expandafter\protect\csname #1\endcsname' command}{2020-07-01}{'\protect\sysusetup'}%
    \sysusetup{#2 = {##1}}%
  }%
}
\sysu@define@term{title}{title}
\sysu@define@term{entitle}{title*}
\sysu@define@term{author}{author}
\sysu@define@term{enauthor}{author*}
\sysu@define@term{major}{speciality}
\sysu@define@term{enmajor}{speciality*}
\sysu@define@term{supervisor}{supervisor}
\sysu@define@term{ensupervisor}{supervisor*}
\gdef\cosupervisor#1{%
  \g@addto@macro\sysu@supervisor{, #1}%
}
\gdef\encosupervisor#1{%
  \g@addto@macro\sysu@supervisor@en{, #1}%
}
\gdef\date#1{\renewcommand\sysu@date@zh@big{#1}}
\gdef\endate#1{\renewcommand\sysu@date@en{#1}}
\sysu@define@term{professionaltype}{professional-type}
\sysu@define@term{enprofessionaltype}{professional-type*}
\sysu@define@term{secretlevel}{secret-level}
\sysu@define@term{ensecretlevel}{secret-level*}
\sysu@define@term{secretyear}{secret-year}
\gdef\keywords#1{\renewcommand\sysu@keywords@text{#1}}
\gdef\enkeywords#1{\renewcommand\sysu@keywords@en@text{#1}}
\gdef\frkeywords#1{\renewcommand\sysu@keywords@fr@text{#1}}

% 定义一些常量。
\ifsysu@degree@doctor
  \newcommand\sysu@thesis@name{中山大学博士学位论文}
  \newcommand\sysu@thesis@name@en{A dissertation for doctor's degree}
\else
  \ifsysu@degree@master
    \newcommand\sysu@thesis@name{中山大学硕士学位论文}
    \newcommand\sysu@thesis@name@en{A dissertation for master's degree}
  \else
    \newcommand\sysu@thesis@name{本科生毕业论文（设计）}
    \newcommand\sysu@thesis@name@en{A dissertation for bachelor's degree}
  \fi
\fi
\ifsysu@degree@type@academic
\else
  \ifsysu@degree@doctor
    \renewcommand\sysu@thesis@name{中山大学工程博士学位论文}
  \else
    \renewcommand\sysu@thesis@name{中山大学专业硕士学位论文}
  \fi
  \ifsysu@cjk@font@mac
    \providecommand\lishu{\CJKfamily{zhli}}
  \else
    \ifsysu@cjk@font@windows
      \setCJKfamilyfont{zhli}{LiSu}
      \providecommand\lishu{\CJKfamily{zhli}}
    \else
      \sysu@warning{LiShu font is required}
      \providecommand\lishu{\sffamily}
    \fi
  \fi
\fi

% 定义校徽颜色
%
% 推迟定义颜色以避免调用 \pkg{xcolor} 时的警告
\AtBeginDocument{
  \definecolor{sysugreen}{cmyk}{1,0,1,0.6}
}

% 添加 PDF 书签，在 \pkg{hyperref} 载入后才有效。
\newcommand\sysu@pdfbookmark{\@gobble}

% 重定义 \env{titlepage} 环境，不修改页码。
\renewenvironment{titlepage}{%
  \cleardoublepage
  \if@twocolumn
    \@restonecoltrue\onecolumn
  \else
    \@restonecolfalse\newpage
  \fi
  \thispagestyle{empty}%
}{%
  \if@restonecol\twocolumn \else \newpage \fi
}

% 研究生中文扉页：
% 密级黑体 12 磅；
% 论文类型黑体 56 磅；
% 论文题目黑体 26 磅加粗居中，单倍行距；
% 作者姓名宋体 16 磅，单倍行距；
% 注意这里的“单倍行距”的地方开启了“对齐到网格”，所以实际行距有所偏差，
% 所以只能使用直尺测量。
\newcommand\sysu@title@page@graduate@zh{%
  \sysusetup{language=chinese}%
  \begin{titlepage}%
  	\sysu@pdfbookmark{封面}%
  	\centering
%   扉页右上角标注密级  	
  	\parbox[t][0.6cm][t]{\textwidth}{%
  	  \raggedleft\heiti\fontsize{12bp}{12bp}\selectfont
  	  \null\sysu@secret@level\par}\par
%  	  \vskip 0.5cm%
    \includegraphics[width=11cm]{\sysu@logo@path/SYSULogo}\\
  	\vskip 1.2cm%
  	{\rmfamily\bfseries\fontsize{26bp}{26bp}\selectfont
  		\sysu@thesis@name\par}%
  	\vskip 1.2cm%
  	{\fontsize{12}{12}\selectfont
  	\begin{tabularx}
  	{\textwidth}{>{\centering\arraybackslash\hyphenpenalty=10000\exhyphenpenalty=10000}X}
  	{\centering\sffamily\fontsize{16bp}{32bp}\selectfont
  	  \sysu@title\par}\par
  	{\centerlast\rmfamily\fontsize{16bp}{29bp}\selectfont
  	  \sysu@title@en\par}
  	\end{tabularx}
    \vskip 16bp%
  	\begin{tabular}{ll}
  		{\makebox[3cm][s]{\zihao{4}\sffamily{专 \hfill 业：}}} & \zihao{4}\sysu@speciality \\\vspace{4bp} \\
  		{\makebox[3cm][s]{\zihao{4}\sffamily{学 \hfill 位 \hfill 申 \hfill 请 \hfill 人：}}}& \zihao{4}\sysu@author \\ \vspace{4bp} \\
  		{\makebox[3cm][s]{\zihao{4}\sffamily{指 \hfill 导 \hfill 教 \hfill 师：}}} & \zihao{4}\sysu@supervisor@names \\
  	\end{tabular}
    }
    \vskip 1.2cm%
    \zihao{4}{
    	\begin{tabular}{ccc}
    		论文答辩委员会主席：& \raisebox{-1.5ex}{\underline{\makebox[6cm][c]{}}}& \makebox[4.5cm][c]{}\\
    		&~\\
    		论文答辩委员会成员：& \raisebox{-1.5ex}{\underline{\makebox[6cm][c]{}}}& \makebox[4.5cm][c]{}\\
    		&~\\
    		{}& \raisebox{-1.5ex}{\underline{\makebox[6cm][c]{}}}& \makebox[4.5cm][c]{}\\
    		&~\\
    		{}& \raisebox{-1.5ex}{\underline{\makebox[6cm][c]{}}}& \makebox[4.5cm][c]{}\\
    		&~\\
    		{}& \raisebox{-1.5ex}{\underline{\makebox[6cm][c]{}}}& \makebox[4.5cm][c]{}
    	\end{tabular}
    }
    \vfill
    \zihao{-5}
    {\centering\sysu@date@zh@short} % 日期显示年月
  	
  \end{titlepage}%
  \sysu@reset@main@language
}

\newbox\sysu@title@box

% 本科生的外封
\newcommand\sysu@cover{%
  \begin{titlepage}%
    \sysu@pdfbookmark{Cover}%
    \centering
    \vskip 0.5cm%
    \includegraphics[width=3cm]{\sysu@logo@path/sysu-logo.pdf}
    \vskip 1.2cm%
      {\zihao{-0}\textcolor{sysugreen}{\rmfamily\textbf{\ \sysu@thesis@name}}}
    \vspace{\baselineskip}
    
    % 做分割线
    \noindent\makebox[\linewidth]{ { \color{sysugreen} \rule{\paperwidth}{0.12cm} } }
    \noindent\makebox[\linewidth]{ { \color{sysugreen} \rule[0.8\baselineskip]{\paperwidth}{0.05cm} } }

    \ \vskip 1.5cm%
    
      \begin{tabular}{lp{140bp}lp{140bp}}%
	        \zihao{2}\sffamily{题目:} &
	          \multicolumn{3}{c}{%
		            \multirow[t]{2}{13cm}{%
			              \savebox\sysu@title@box{%
				                \parbox[t]{13cm}{%
					                  \centering\sffamily\bfseries\fontsize{22bp}{42bp}\selectfont
					                  \sysu@title
					                }%
				              }%
			              \dp\sysu@title@box=0pt\relax
			              \usebox\sysu@title@box
			            }%
		          } \\
	        \cline{2-4}%
	        \noalign{\vskip 24bp}%
	        & & & \\
	        \cline{2-4}%
	        \noalign{\vskip 24bp}%
	  \end{tabular}%
    \ \vskip 1.7cm
    % 小三对应15pt
    \renewcommand{\arraystretch}{2}
  % \setlength\arrayrulewidth{1.4pt}
    \fontsize{15}{24}\heiti\selectfont
    \begin{tabular}{cc}
	   % [s] 两端对齐
	    \makebox[2.2cm][s]{姓名}     & \makebox[8cm]{\hfill\sysu@author\hfill}   \\ \cline{2-2}
	    \makebox[2.2cm][s]{学号}     & \makebox[8cm]{\hfill\sysu@student@id\hfill} \\ \cline{2-2}
	    \makebox[2.2cm][s]{院系}     & \makebox[8cm]{\hfill\sysu@department\hfill}   \\ \cline{2-2}
	    \makebox[2.2cm][s]{专业}     & \makebox[8cm]{\hfill\sysu@speciality\hfill}    \\ \cline{2-2}
	    \makebox[2.2cm][s]{指导教师} & \makebox[8cm]{\hfill\sysu@supervisor@names\hfill}   \\ \cline{2-2}
	\end{tabular}
    \\
    \ \vskip 0.3cm
    \zihao{-4}\underline{\makebox[0.9cm]{\number\year}}年\underline{\makebox[0.9cm]{\number\month}}月\underline{\makebox[0.9cm]{\number\day}}日
  \end{titlepage}%
}

% 本科生的扉页（内封）
\newcommand\sysu@title@page@bachelor{%
  \begin{titlepage}%
  	\sysu@pdfbookmark{Title page}%
  	\centering
  	\ \vskip 2cm%
  {
  	\renewcommand{\arraystretch}{1.2}
  	\parbox[t]{13cm}{%
  	  \centering\sffamily\bfseries\fontsize{22bp}{42bp}\selectfont
  	  \sysu@title\par
  	}\par
  	\ \vskip 1cm%
  	\ \\
    \parbox[t]{13cm}{%
      \centerlast\sffamily\bfseries\fontsize{22bp}{37bp}\selectfont
      \sysu@title@en\par
    }\par
  }
    \ \vskip 1.8cm%
    \ \\
  {
  	\renewcommand{\arraystretch}{1.6}
    \fontsize{15}{28}\heiti\selectfont
    \begin{tabular}{cc}
    	% [s] 两端对齐
    	\makebox[2.3cm][s]{姓名}     & \makebox[8.5cm]{\hfill\sysu@author\hfill}   \\ \cline{2-2}
    	\makebox[2.3cm][s]{学号}     & \makebox[8.5cm]{\hfill\sysu@student@id\hfill} \\ \cline{2-2}
    	\makebox[2.3cm][s]{院系}     & \makebox[8.5cm]{\hfill\sysu@department\hfill}   \\ \cline{2-2}
    	\makebox[2.3cm][s]{专业}     & \makebox[8.5cm]{\hfill\sysu@speciality\hfill}    \\ \cline{2-2}
    	\makebox[2.3cm][s]{指导教师} & \makebox[8.5cm]{\hfill\sysu@supervisor@names\hfill}   \\ \cline{2-2}
    \end{tabular}
  }
    \ \vskip 1cm%
    {\zihao{4}\heiti\underline{\makebox[0.9cm]{\number\year}}年\underline{\makebox[0.9cm]{\number\month}}月\underline{\makebox[0.9cm]{\number\day}}日 }
  \end{titlepage}%
}
\newlength\sysu@title@page@item@width

% 重新定义 \cs{maketitle}，分别生成本科生、研究生封面
\renewcommand\maketitle{%
  \newgeometry{margin=2.54cm}%
  \pagenumbering{Alph}%
  \pagestyle{empty}%
  \sysu@title@pagetrue
  \ifsysu@degree@graduate
    \sysu@title@page@graduate@zh
  \else
  	\sysu@cover
    \sysu@title@page@bachelor
  \fi
  \cleardoublepage
  \restoregeometry
  \pagestyle{plain}%
  \sysu@title@pagefalse
}


% \subsection{原创性声明}

% 定义原创性声明
\newcommand\sysu@originality{%
  本人郑重声明：所呈交的学位论文，是本人在导师的指导下，独立进行研究工作所取得的成果。除文中已经注明引用的内容外，本论文不包含任何其他个人或集体已经发表或撰写过的作品成果。对本文的研究作出重要贡献的个人和集体，均已在文中以明确方式标明。本人完全意识到本声明的法律结果由本人承担。}
\newcommand\sysu@authorization{%
  本人完全了解中山大学有关保留、使用学位论文的规定，即：学校有权保留学位论文并向国家主管部门或其指定机构送交论文的电子版和纸质版；有权将学位论文用于非赢利目的的少量复制并允许论文进入学校图书馆、院系资料室被查阅；有权将学位论文的内容编入有关数据库进行检索；可以采用复印、缩印或其他方法保存学位论文；可以为建立了馆际合作关系的兄弟高校用户提供文献传递服务和交换服务。\par
  保密论文保密期满后，适用本声明。}
% 定义本科的学术诚信声明
\newcommand\sysu@integrity{%
  本人郑重声明：所呈交的毕业论文（设计），是本人在导师的指导下，独立进行研究工作所取得的成果。除文中已经注明引用的内容外，本论文（设计）不包含任何其他个人或集体已经发表或撰写过的作品成果。对本论文（设计）的研究做出重要贡献的个人和集体，均已在文中以明确方式标明。本论文（设计）的知识产权归属于培养单位。本人完全意识到本声明的法律结果由本人承担。}
  %
  % 生成空的下划线
\newcommand\sysu@underline[2][3.2cm]{\underline{\hb@xt@ #1{\hss#2\hss}}}

\newcommand\sysu@checkbox{%
  \makebox[0bp][l]{$\square$}%
  \raisebox{-0.2ex}{\hspace{0.1em}$\checkmark$}%
}

\newcommand\sysu@copyrightpage@graduate{%
  \begin{titlepage}%
    \sysu@pdfbookmark{研究生原创性和授权使用声明}%
    \null
    \vskip 0.3cm%
    {\centering\sffamily\fontsize{16bp}{32bp}\selectfont
      论文原创性声明\par}%
    \vskip 0.7cm%
    \sysu@originality\par
    \vskip 1.3cm%
    学位论文作者签名：\hspace{3cm} \par %
    \vskip 0.5cm%
    日期：\hspace{1.1cm} 年 \hspace{0.7cm} 月 \hspace{0.7cm} 日\par
    \vskip 1.9cm%
    {\centering\sffamily\fontsize{16bp}{32bp}\selectfont
     学位论文使用授权声明\par}%
    \vskip 0.7cm%
    \sysu@authorization\par
    \vskip 0.6cm%
%    \ifx\sysu@secret@level\@empty
%      \sysu@checkbox{} 公开\quad
%      $\square$ 控阅（\sysu@underline[0.85cm]{}年）\par
%    \else
%      $\square$ 公开\quad
%      \sysu@checkbox{} 控阅（\sysu@underline[0.8cm]{\sysu@secret@year}年）\par
%    \fi
    \vskip 0.5cm%
    学位论文作者签名：\hspace{3cm}%
    导师签名：\par
    \vskip 0.5cm%
    日期：\hspace{1.1cm} 年 \hspace{0.7cm} 月 \hspace{0.7cm} 日\hspace{1.2cm}%
    日期：\hspace{1.1cm} 年 \hspace{0.7cm} 月 \hspace{0.7cm} 日\par
%    \ifsysu@reviewer@true
%      \vskip 1.5cm%
%      \hskip -1em%
%      评审专家签名：\sysu@underline{}\hspace{4.5em}%
%      评审专家签名：\sysu@underline{}\par
%    \fi
  \end{titlepage}%
  \sysu@title@pagetrue
  \cleardoublepage
  \sysu@title@pagefalse
}

\newcommand\sysu@copyrightpage@bachelor{
  \begin{titlepage}%
	\sysu@pdfbookmark{本科生学术诚信声明}
	\null
	\vskip 0.3cm%
	{\centering\sffamily\bfseries\fontsize{16bp}{32bp}\selectfont
		学术诚信声明\par}%
	\vskip 0.7cm%
	\sysu@integrity\par
	\vskip 2.4cm%
	
	\begin{flushright}
		\makebox[2.1cm][s]{作者签名：} \makebox[5cm]{\hspace{1cm}} \\
		\vspace{\baselineskip}
		\makebox[2.1cm][s]{日期：} \makebox[5cm]{\hspace{1cm}年\hspace{1cm}月\hspace{1cm}日} \\
	\end{flushright}

  \end{titlepage}%
}
\newcommand\copyrightpage{%
  \sysu@title@pagetrue
  \ifsysu@degree@graduate
    \sysu@copyrightpage@graduate
  \else
	\sysu@copyrightpage@bachelor
  \fi
  \cleardoublepage
  \sysu@title@pagefalse
}

% Reserved for compatibility until 2020-07-01.
%\newcommand\makestatement{%
%  \sysu@deprecated{'\protect\makestatement' command}{2020-07-01}{'\protect\copyrightpage'}%
%  \copyrightpage
%}


% \subsection{章节标题}

% 标题最多允许使用四级。
\setcounter{secnumdepth}{4}

% 本科生章题为两字时中间空一字，三字时空半字，四字及以上不空。
% 这里用 \LaTeX3 的 \cs{\str_count:N} 判断字数。
% 注意，\pkg{stringstrings} 宏包会导致范数命令 \verb+\|+ 被修改。
\newcount\sysu@titlelength
\DeclareRobustCommand\sysu@spaced@title[1]{%
  \sysu@titlelength=\csname str_count:N\endcsname{#1}%
  \begingroup
    \if@mainmatter\else
      \ifcase\sysu@titlelength
      \or\or
        \ziju{1}%
      \or\or
        \ziju{0.5}%
      \fi
    \fi
    #1%
  \endgroup
}

% 四级节标题和脚注需要使用带圈的数字，这里使用 \cs{sysu@circlefont} ：
\newcommand\sysu@textcircled[1]{%
  \ifnum\value{#1}<21\relax
    {\symbol{\numexpr\value{#1} + "245F\relax}}%
  \else
    \sysu@error{Cannot display more than 20 footnotes}%
  \fi
}

% 用 \pkg{ctex} 的接口设置全部章节标题格式。

% 各章标题，例如：“第1章  引言”。
% 章序号采用阿拉伯数字，章序号与标题之间空一个汉字符，采用黑体三号字，居中书写，单倍行距，段前24磅，段后18磅。
% 摘要、目录和列于目录中与章平级的其它部分的标题（如参考文献、附录、致谢等）也用这同一种格式。
\ctexset{
  chapter = {
    format      = \centering\heiti\fontsize{16bp}{21.8bp}\selectfont,
    nameformat  = {},
    titleformat = {},
    number      = \thechapter,
    aftername   = \quad,
    beforeskip  = 24bp,
    afterskip   = 18bp,
    fixskip     = true,
  },
}

% 一级节标题，例如：“2.1  实验方法”。
% 节编号用阿拉伯数字表示，前边数字为上级章节的序号，后一数字为本节的顺序号。
% 数字间用半角小数点“.”连接。
% 节标题序号与标题名之间空一个汉字符（下同）。
% 采用黑体四号（14pt）字居左书写，固定行距21磅，段前24磅，段后6磅。
\ctexset{
  section = {
    format     = \heiti\fontsize{14bp}{21bp}\selectfont,
    aftername  = \quad,
    beforeskip = 24bp,
    afterskip  = 6bp,
  },
  %
  % 二级节标题，例如：“2.1.1  实验装置”。
  % 采用宋体小四号（12pt）字居左书写，固定行距21磅，段前12磅，段后6磅。
  subsection = {
    format     = \rmfamily\bfseries\fontsize{12bp}{21bp}\selectfont,
    aftername  = \quad,
    beforeskip = 12bp,
    afterskip  = 6bp,
  },
  %
  % 三级节标题，例如：“（1）实验结果”。
  % 采用宋体小四号（12pt）字居左书写，固定行距21磅，段前12磅，段后6磅。
  subsubsection = {
    format     = \rmfamily\bfseries\fontsize{12bp}{21bp}\selectfont,
	number     = （\arabic{subsubsection}）,
	aftername  = \hspace{0em},
	indent     = 0em,
	beforeskip = 0bp,
	afterskip  = 0bp,
	runin      = false,
  },
  %
  % 一般用不到三级节以下的标题，但此处还是保留四级节标题备用。
  % 四级节标题：宋体 12 磅，左缩进两字，行距 21 磅，
  % 段前段后 0 磅，序号使用全宽括号，与题名间空半字宽。
  paragraph = {
    format     = \rmfamily\bfseries\fontsize{12bp}{21bp}\selectfont,
	number     = \sysu@textcircled{paragraph},
	aftername  = \hspace{0.5em},
	indent     = 0.5em,
	beforeskip = 0bp,
	afterskip  = 0bp,
	runin      = false,
  },
}

\ifsysu@degree@bachelor
  \ifsysu@main@language@english
    \sysusetup{section-style = arabic}
  \fi
\fi
\sysu@option@hook{main-language}{%
  \ifsysu@degree@bachelor
    \ifsysu@main@language@english
      \sysusetup{section-style = arabic}%
    \fi
  \fi
}

% 在研究生格式的基础上再设置本科生的章节标题格式。
\ifsysu@degree@bachelor
  \setcounter{secnumdepth}{3}
  \ctexset{
  %
  % 论文的致谢、目录、摘要和参考文献等标题用三号（16 bp）黑体字，居中，
  % 这通过 \cs{if@mainmatter} 区分。
  % 正文中的标题分章、节、段三级；章、节标题居中，段标题居左，
  % 分别用三号（16 bp）黑体、四号（14 bp）黑体、小四号（12 bp）加粗宋体。
    chapter = {
      format = {
        \centering\sffamily
        \if@mainmatter
          \fontsize{16bp}{29.33bp}\selectfont
        \else
          \fontsize{16bp}{29.33bp}\selectfont
        \fi
      },
      titleformat = \sysu@spaced@title,
    },
    section = {
      format = \sffamily\fontsize{14bp}{25.67bp}\selectfont,
    },
  }
\fi

% 默认的 \cs{chapter*} 生成的章标题没有编号、不更改页眉，
% 也不添加进目录或 PDF 书签。
% 然而像摘要、目录、符号说明这样的章节，它们不需要编号、不加入目录，
% 但是需要修改页眉，并且加入 PDF 标签。
% 所以我们新定义 \cs{sysu@chapter} 用于处理这些章节。%
\NewDocumentCommand\sysu@chapter{o m}{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \IfValueTF{#1}{%
    \sysu@pdfbookmark{#1}%
    \chaptermark{#1}%
  }{%
    \sysu@pdfbookmark{#2}%
    \chaptermark{#2}%
  }%
  \chapter*{#2}}


% \subsection{摘要}

% 中文摘要环境。
\newcommand\sysu@keywords@text{%
  \sysu@clist@use{\sysu@keywords}{；}%
}
\newcommand\sysu@keywords@en@text{%
  \ifsysu@degree@graduate
    \sysu@clist@use{\sysu@keywords@en}{, }%
  \else
    \sysu@clist@use{\sysu@keywords@en}{; }%
  \fi
}

\ifsysu@degree@bachelor
\newcommand\sysu@keywords@fr@text{%
  \sysu@clist@use{\sysu@keywords@fr}{; }%
}
\fi

\newenvironment{abstract}{%
  \sysusetup{language=chinese}%
  \ifsysu@degree@graduate
  \pretocmd{\sysu@chapter}{%
  	%这是章标题前的内容，不会另起一页
  	\begin{center}
  		\zihao{3}
  		\mbox{ }\\
  		\sffamily{论文题目：\sysu@title} 
  		\vskip 0.5cm%
  		\zihao{4}\rmfamily
  		\begin{tabular}{l}
  			专\hspace{2\ccwd}业：\sysu@speciality \\ [-2ex]\\
  			\ifsysu@degree@doctor
  			博\hspace{0.5\ccwd}士\hspace{0.5\ccwd}生：\sysu@author \\ [-2ex]\\
  			\else
  			硕\hspace{0.5\ccwd}士\hspace{0.5\ccwd}生：\sysu@author \\ [-2ex]\\
  			\fi
  			指导教师：\sysu@supervisor@names
  		\end{tabular}
  	\end{center}
  }{}{}
  \let\clearpage\relax
  \sysu@chapter{摘\hspace{2em}要}%
  \else
  \sysu@chapter{【摘\hspace{\ccwd}要】}%
  \fi
}{
  \par\null\par\noindent\hangindent=4em\relax
  \textbf{关键词}：\sysu@keywords@text\par
  \sysu@reset@main@language
  \newpage
}

\newbox\sysu@keywords@box
\newlength\sysu@keywords@width
% 英文摘要环境
\newcommand\sysu@keywords@label{KEY WORDS}%

\newenvironment{abstract*}{%
  \sysusetup{language=english}%
  \ifsysu@degree@graduate
  \pretocmd{\sysu@chapter}{%
  	%这是章标题前的内容，不会另起一页
  	\begin{center}
  		\zihao{3}
  		\mbox{ }\\
  		\sffamily{Title：\sysu@title@en} 
  		\vskip 0.5cm%
  		\zihao{4}\rmfamily
  		\begin{tabular}{l}
  			Major:   \sysu@speciality@en \\ [-2ex]\\
  			Name:   \sysu@author@en \\ [-2ex]\\
  			\sysu@supervisor@en@line
  		\end{tabular}
  	\end{center}
  }{}{}
    \let\clearpage\relax
    \ctexset{
      chapter/format = \centering\bfseries\fontsize{16bp}{26.67bp}\selectfont,
    }%
    \sysu@chapter{ABSTRACT}%
  \else
    \begingroup
      % 本科生的英文摘要使用三号衬线体
      \ctexset{chapter/format=\centering\bfseries\fontsize{16bp}{33bp}\selectfont}%
      \sysu@chapter{[ABSTRACT]}%
    \endgroup
  \fi
}{
  \par\null\par\noindent
  \ifsysu@degree@bachelor
    \renewcommand\sysu@keywords@label{Key Words}%
  \fi
  \savebox\sysu@keywords@box{\textbf{\sysu@keywords@label}: }%
  \sysu@keywords@width=\linewidth
  \advance\sysu@keywords@width-\wd\sysu@keywords@box
  \textbf{\sysu@keywords@label}: \parbox[t]{\sysu@keywords@width}{\sysu@keywords@en@text\par}\par
  \ifsysu@degree@graduate
    \newpage
  \fi
  \sysu@reset@main@language
}


% 法语摘要环境，适用于中法核工程与技术学院本科论文中文、英文、法语三语摘要
\ifsysu@degree@bachelor
  \newenvironment{abstract**}{%
	\sysusetup{language=english}%

	\begingroup
	% 中法核本科生的法语摘要使用三号衬线体
	\ctexset{chapter/format=\centering\bfseries\fontsize{16bp}{33bp}\selectfont}%
	\sysu@chapter{[ABSTRACT]}%
	\endgroup
  }{
	\par\null\par\noindent
	\renewcommand\sysu@keywords@label{Mots-clés }%
	\savebox\sysu@keywords@box{\textbf{\sysu@keywords@label}: }%
	\sysu@keywords@width=\linewidth
	\advance\sysu@keywords@width-\wd\sysu@keywords@box
	\textbf{\sysu@keywords@label}: \parbox[t]{\sysu@keywords@width}{\sysu@keywords@fr@text\par}\par
	\newpage
	\sysu@reset@main@language
}
\fi


% \subsection{目录}

% 目录另面起；
\renewcommand\tableofcontents{%
  \cleardoublepage
  \pagestyle{plain}%
  \sysu@chapter{\contentsname}%
  \setcounter{tocdepth}{1}% 设置目录深度为1，即只显示到section （论文中的章为 Chapter， 1.1 这种为 Section，上面的目录深度表示 section 的深度）
  \@starttoc{toc}%
}

% 下面用 \pkg{titletoc} 宏包设置目录内容的格式。
% 先定义目录线：
\newcommand\sysu@leaders{%
  \hspace{2bp}%
  \titlerule*[4bp]{.}%
  \hspace{2bp}%
}

\contentsmargin{0bp}

% 目录中的章标题行采用黑体小四号字，固定行距 21 磅，段前 6 磅，段后 0 磅；
% 其他内容采用宋体小四号字，行距 21 磅，段前、段后均为 0 磅。
% 章标题行居左书写，一级节标题行缩进 1 个汉字符，二级节标题行缩进 2 个汉字符。
% 带有序号的各级标题，其序号与题名之间均空一字符，行末右顶格。
\ifsysu@degree@graduate
  \titlecontents{chapter}
    [0bp]{\addvspace{6bp}\songti\normalsize}
    {\contentspush{\thecontentslabel\hspace{\ccwd}}}{}
    {\normalsize\sysu@leaders\thecontentspage}
    %
  \titlecontents{section}
    [1em]{\normalsize}
    {\contentspush{\thecontentslabel\quad}}{}
    {\sysu@leaders\thecontentspage}
    %
  \titlecontents{subsection}
    [2em]{\normalsize}
    {\contentspush{\thecontentslabel\quad}}{}
    {\sysu@leaders\thecontentspage}
\else
  % 本科生的目录使用小四宋体（同正文字体），其他同研究生的格式相近。
  \titlecontents{chapter}
    [0bp]{\normalsize}
    {\contentspush{\thecontentslabel\unskip\quad}}{}
    {\sysu@leaders\thecontentspage}
  \titlecontents{section}
    [1em]{\normalsize}
    {\contentspush{\thecontentslabel\quad}}{}
    {\sysu@leaders\thecontentspage}
  \titlecontents{subsection}
    [2em]{\normalsize}
    {\contentspush{\thecontentslabel
      \ifsysu@section@style@arabic\quad\else 、\fi}}{}
    {\sysu@leaders\thecontentspage}
\fi

% 本科生要求目录中正文每章前多空一行，而目录、附录等章则不需要空行，
% 所以不能简单判断 \cs{if@mainmatter}，需要重新定义 \cs{mainmatter} 等命令。
\newif\ifsysu@addtocspace
\ifsysu@degree@bachelor
  \sysu@addtocspacetrue
  \g@addto@macro\frontmatter{\sysu@addtocspacefalse}%
  \g@addto@macro\mainmatter{\sysu@addtocspacetrue}%
  \g@addto@macro\backmatter{\sysu@addtocspacefalse}%
  \g@addto@macro\appendix{\sysu@addtocspacefalse}%
\fi

% 处理本科生在目录中添加空行。
\renewcommand\chapter{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \thispagestyle{\CTEX@chapter@pagestyle}%
  \global\@topnum\z@
  \@afterindenttrue
  \ifsysu@degree@bachelor
    \ifsysu@addtocspace
      \addtocontents{toc}{\protect\addvspace{12bp}}%
    \fi
  \fi
  \secdef\@chapter\@schapter
}

% 研究生要求图、表的清单须另页起。
\newlength{\sysu@lof@label@width}
\newcommand\sysu@set@lof@format{%
  \settowidth{\sysu@lof@label@width}{\figurename~9.99}%
  \addtolength{\sysu@lof@label@width}{1em}%
  \titlecontents{figure}%
    [\sysu@lof@label@width]{\normalsize}%
    {\contentslabel[\figurename~\thecontentslabel]{\sysu@lof@label@width}}{}%
    {\sysu@leaders\thecontentspage}%
  \titlecontents{table}%
    [\sysu@lof@label@width]{\normalsize}%
    {\contentslabel[\tablename~\thecontentslabel]{\sysu@lof@label@width}}{}%
    {\sysu@leaders\thecontentspage}%
}
\sysu@set@lof@format
\sysu@option@hook{main-language}{\sysu@set@lof@format}
\renewcommand\listoffigures{%
  \ifsysu@degree@graduate
    \clearpage
  \fi
  \sysu@chapter{\listfigurename}%
  \@starttoc{lof}%
}
\renewcommand\listoftables{%
  \ifsysu@degree@graduate
    \clearpage
  \fi
  \sysu@chapter{\listtablename}%
  \@starttoc{lot}%
}

\newcommand\listoffiguresandtables{%
  \ifsysu@degree@graduate
    \clearpage
  \fi
  \sysu@chapter{\sysu@list@figure@table@name}%
  \@starttoc{lof}%
  \@starttoc{lot}%
}


% \subsection{符号说明}

% 研究生规定符号说明另页起，标题字体字号等同论文正文，
\newenvironment{notation}{%
  \ifsysu@degree@graduate
    \clearpage
  \fi
  \sysu@chapter{\sysu@notation@name}%
}{%
  \ifsysu@degree@graduate
    \clearpage
    \pagestyle{plain}%
  \fi
}%
\newcommand*\notationlabel[1]{#1\hfil}%
\newenvironment{notationlist}[1]{%
  \list{}{%
    \itemsep 3bp%
    \labelwidth #1\relax%
    \labelsep 1em%
    \leftmargin\labelwidth
    \advance\leftmargin\labelsep
    \advance\leftmargin 3em%
    \rightmargin 3em%
    \let\makelabel\notationlabel
  }%
}{%
  \endlist
}


% \subsection{正文}

% \cs{sloppy} 可以减少“overfull boxes”。
\sloppy

% 禁止扩大段间距。（\href{https://github.com/ustctug/ustcthesis/issues/209}{
%   ustctug/ustcthesis\#209}）
\raggedbottom

% 段间距 0 磅。
\setlength{\parskip}{0bp}

% 首段缩进。
\ctexset{autoindent=2}

% 首段缩进。
\let\@afterindentfalse\@afterindenttrue
\@afterindenttrue

% URL 的字体设为保持原样。
\urlstyle{same}

% 使用 \pkg{xurl} 宏包的方法，增加 URL 可断行的位置。
\def\UrlBreaks{%
  \do\/%
  \do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j\do\k\do\l%
     \do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t\do\u\do\v\do\w\do\x\do\y\do\z%
  \do\A\do\B\do\C\do\D\do\E\do\F\do\G\do\H\do\I\do\J\do\K\do\L%
     \do\M\do\N\do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V\do\W\do\X\do\Y\do\Z%
  \do0\do1\do2\do3\do4\do5\do6\do7\do8\do9\do=\do/\do.\do:%
  \do\*\do\-\do\~\do\'\do\"\do\-}
\Urlmuskip=0mu plus 0.1mu

% 脚注用带圈的数字：
\renewcommand\thefootnote{\sysu@textcircled{footnote}}

% LaTeX 默认脚注按章计数，即每章的开始才重置脚注计数器；我们修改为按页计数。
% 简单的|\@addtoreset{footnote}{page}|并不可靠，
% \footnote{\url{https://texfaq.org/FAQ-footnpp.html}}
% 所以我们使用 \pkg{footmisc} 宏包。

% 脚注线长为版心宽度的四分之一：
\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule\@width.25\textwidth
  \kern2.6\p@}
  %
  % 注文缩进两字：
\renewcommand\@makefntext[1]{%
  \parindent=2em\relax
  \noindent
  \hb@xt@ 2em{\hss\@makefnmark}#1}

% \subsection{列表}
% \label{sec:list}

% 调整列表中各项之间过大的间距。
\setlength\partopsep{0bp}
\newcommand\sysu@nolistsep{%
  \parsep 0\p@ \@plus.2\p@
  \topsep 0\p@ \@plus.2\p@
  \itemsep0\p@ \@plus.2\p@
}
\def\@listi{\leftmargin\leftmargini
            \sysu@nolistsep}
\let\@listI\@listi
\@listi
\def\@listii {\leftmargin\leftmarginii
              \labelwidth\leftmarginii
              \advance\labelwidth-\labelsep
              \sysu@nolistsep}
\def\@listiii{\leftmargin\leftmarginiii
              \labelwidth\leftmarginiii
              \advance\labelwidth-\labelsep
              \sysu@nolistsep}


% \subsection{浮动体}

% 图题采用宋体，加粗，字号 10.5pt，居中书写，单倍行距，段前6磅，段后0磅，
% 图序与图名之间空一个汉字符，

% 表题置于表的上方，采用宋体，加粗，字号10.5pt，居中书写，单倍行距，段前6磅，段后0磅。
% 表序与表名之间空一个汉字符。

% 本科生：图全文要分别统一编号或按章编号，标题用五号宋体:

% 使用 \pkg{caption} 宏包设置图、表的格式：
\DeclareCaptionFont{sysu}{\sysu@caption@font}
\newcommand\sysu@caption@font{%
  \ifsysu@degree@bachelor
    \fontsize{10.5bp}{13.65bp}\selectfont
  \else
    \ifsysu@language@chinese
      \fontsize{10.5bp}{13.65bp}\selectfont
    \else
      \fontsize{10.5bp}{12.075bp}\selectfont
    \fi
  \fi
}

\captionsetup{
  font           = sysu,
  labelsep       = quad,
  skip           = 6bp,
  figureposition = bottom,
  tableposition  = top,
  justification  = centerlast,
}
% 研究生论文图、表标题字体加粗
\ifsysu@degree@graduate
  \captionsetup{font+=bf}
\fi

% 中英文双标题
\AtEndOfPackageFile*{bicaption}{
  \captionsetup[bi-first]{lang = chinese}% 第一种语言图、表标题
  \captionsetup[bi-second]{% 第二种语言图、表标题
    lang = english,
    list = off,
  }
  \renewcommand\selectcaptionlanguage[2]{%
    \sysusetup{language = #2}%
  }
}
% 设置三线表顶部和底部横线宽度
\setlength\heavyrulewidth{1.5pt}

% 表单元格中的文字采用 12pt 宋体字，单倍行距，段前3磅，段后3磅。
% 对于中文，`\arraystretch` 需要设为 1 + (3pt + 3pt) / (12pt * 1.3) ~= 1.38。
% 对于英文，`\arraystretch` 需要设为 1 + (3pt + 3pt) / (12pt * 1.15) ~= 1.43。
%
% 本科生：表格内容用小四宋体或五号宋体选定某种样式后，全文应统一。
\newcommand\sysu@table@font{%
  \ifsysu@degree@bachelor
    \ifsysu@language@chinese
      \fontsize{12bp}{14.4bp}\selectfont
      \renewcommand\arraystretch{1.38}%
    \else
      \fontsize{12bp}{15bp}\selectfont
      \renewcommand\arraystretch{1.38}%
    \fi
  \else
    \ifsysu@language@chinese
      \fontsize{12bp}{14.4bp}\selectfont
      \renewcommand\arraystretch{1.38}%
    \else
      \fontsize{12bp}{14.4bp}\selectfont
      \renewcommand\arraystretch{1.38}%
    \fi
  \fi
}

\patchcmd\@floatboxreset{%
  \normalsize
}{%
  \sysu@table@font
}{}{\sysu@patch@error{\@floatboxreset}}

% 对 \pkg{longtable} 跨页表格进行相同的设置。
\AtEndOfPackageFile*{longtable}{
  \AtBeginEnvironment{longtable}{%
    \ifdim\f@size pt > 11bp\relax
      \sysu@table@font
    \fi
  }
}
% 对较为复杂的、需要在表格内拆分单元格的表格使用
\newcommand{\tabincell}[2]{\begin{tabular}{@{}#1@{}}#2\end{tabular}}

% 图注、表注使用 `\figurenote` 或 `\tablenote` 命令，与 `apa7.cls` 一致。
% 图注采用宋体 10.5pt，单倍行距，段前6磅，段后0磅。
% 多个图注则须顺序编号，注序左缩进2字，与注文之间空一字符，续行悬挂缩进左对齐，两端对齐。
\newcommand\sysu@figure@note@font{%
  \ifsysu@degree@bachelor
    \ifsysu@language@chinese
      \fontsize{10.5bp}{13.65bp}\selectfont
    \else
      \fontsize{10.5bp}{12.075bp}\selectfont
    \fi
  \else
    \sysu@caption@font
  \fi
}
\newcommand\figurenote[1]{%
  \par
  \begingroup
    \setlength\parskip{6bp}%
    \sysu@figure@note@font
    % 参考 `\@makecaption` 的实现
    \sbox\@tempboxa{#1}%
    \ifdim \wd\@tempboxa >\hsize
      \parbox{\linewidth}{#1\par}%
    \else
      \global \@minipagefalse
      \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
    \fi
    \par
  \endgroup
}
\let\tablenote\figurenote

\newcommand\note[1]{%
  \sysu@deprecated{'\protect\note' command}{2025-01-05}{'\protect\figurenote'}%
  \figurenote{#1}%
}

% 设置 \pkg{threeparttable} 表注的默认字号。
\AtEndOfPackageFile*{threeparttable}{
  \AtBeginEnvironment{tablenotes}{%
    \sysu@figure@note@font
  }
}

% 不宜将多个插图连续排版，插图与文字论述段落应穿插排版。

% 修改默认的浮动体描述符为 |h|。
\def\fps@figure{h}
\def\fps@table{h}

% \LaTeX{} 对放置浮动体的要求比较强，这里按照 UK TeX FAQ 的建议
% \footnote{\url{https://texfaq.org/FAQ-floats}} 对其适当放宽。
\renewcommand\topfraction{.85}
\renewcommand\bottomfraction{.7}
\renewcommand\textfraction{.15}
\renewcommand\floatpagefraction{.66}
\renewcommand\dbltopfraction{.66}
\renewcommand\dblfloatpagefraction{.66}
\setcounter{topnumber}{9}
\setcounter{bottomnumber}{9}
\setcounter{totalnumber}{20}
\setcounter{dbltopnumber}{9}

% 插图前后与文字段落之间须留有10磅空行。
% 插图如果不得不与其它插图或表格连续排版，则它们之间须留有20磅空行。
\setlength{\floatsep}{20bp}
\setlength{\textfloatsep}{10bp}
\setlength{\intextsep}{10bp}

% 由于 LaTeX2e kernel 的问题，图表等浮动体与文字前后的距离不一致，需要进行 patch。
% 参考 \href{https://github.com/tuna/thuthesis/issues/614}{tuna/thuthesis/issues\#614}、
% \url{https://www.zhihu.com/question/46618031} 和
% \url{https://tex.stackexchange.com/a/40363/82731}。
%    \begin{macrocode}
\patchcmd{\@addtocurcol}%
  {\vskip \intextsep}%
  {\edef\save@first@penalty{\the\lastpenalty}\unpenalty
   \ifnum \lastpenalty = \@M  % hopefully the OR penalty
     \unpenalty
   \else
     \penalty \save@first@penalty \relax % put it back
   \fi
   \ifnum\outputpenalty <-\@Mii
     \addvspace\intextsep
     \vskip\parskip
   \else
     \addvspace\intextsep
   \fi}%
  {}{\sysu@patch@error{\@addtocurcol}}
\patchcmd{\@addtocurcol}%
  {\vskip\intextsep \ifnum\outputpenalty <-\@Mii \vskip -\parskip\fi}%
  {\ifnum\outputpenalty <-\@Mii
     \aftergroup\vskip\aftergroup\intextsep
     \aftergroup\nointerlineskip
   \else
     \vskip\intextsep
   \fi}%
  {}{\sysu@patch@error{\@addtocurcol}}
\patchcmd{\@getpen}{\@M}{\@Mi}
  {}{\sysu@patch@error{\@getpen}}


% \subsection{参考文献}

\PassOptionsToPackage{compress}{natbib}

\AtEndOfPackageFile*{natbib}{
  % 定义几种引用文献的标注样式。
  \newcommand\bibstyle@super{\bibpunct{[}{]}{,}{s}{,}{\textsuperscript{,}}}
  \newcommand\bibstyle@inline{\bibpunct{[}{]}{,}{n}{,}{,}}
  \newcommand\bibstyle@authoryear{\bibpunct{(}{)}{;}{a}{,}{,}}
  \@namedef{bibstyle@author-year}{\bibstyle@authoryear}
  %
  % 几种引用样式，与 \file{bst} 文件名保持一致，
  % 这样在使用 \cs{bibliographystyle} 选择参考文献表的样式时也会设置对应的引用样式。
  \@namedef{bibstyle@sysuthesis-numerical}{\bibstyle@super}
  \@namedef{bibstyle@sysuthesis-authoryear}{\bibstyle@authoryear}
  \@namedef{bibstyle@sysuthesis-bachelor}{\bibstyle@super}
  %
  % 如果载入 `natbib` 前设置了 `cite-style`，这里先进行配置。
  % https://github.com/ustctug/ustcthesis/issues/327
  \ifx\sysu@cite@style\@empty\else
    \citestyle{\sysu@cite@style}%
  \fi
  %
  % 定义接口 cite-style 切换引用样式。
  \sysu@option@hook{cite-style}{%
    \citestyle{\sysu@cite@style}%
  }
  %
  % 如果文献序号作为叙述文字的一部分，需要临时将文献序号与正文平排
  \DeclareRobustCommand\inlinecite{\@inlinecite}
  \def\@inlinecite#1{\begingroup\let\@cite\NAT@citenum\citep{#1}\endgroup}
  %
  % 修改引用的样式。
  % 这里在 filehook 中无法使用 \cs{patchcmd}，所以只能手动重定义。
  %
  % 将 super 式 \cs{citep} 引用的页码置于括号外。
  \renewcommand\NAT@citesuper[3]{%
    \ifNAT@swa
      \if*#2*\else
        #2\NAT@spacechar
      \fi
      % \unskip\kern\p@\textsuperscript{\NAT@@open#1\NAT@@close}%
      %  \if*#3*\else\NAT@spacechar#3\fi\else #1\fi\endgroup}
      \unskip\kern\p@
      \textsuperscript{%
        \NAT@@open#1\NAT@@close
        \if*#3*\else#3\fi
      }%
      \kern\p@
    \else
      #1%
    \fi
    \endgroup
  }
  %
  % 将 numbers 式 \cs{citep} 引用的页码置于括号外并改为上标。
  \renewcommand\NAT@citenum[3]{%
    \ifNAT@swa
      \NAT@@open
      \if*#2*\else
        #2\NAT@spacechar
      \fi
      % #1\if*#3*\else\NAT@cmt#3\fi\NAT@@close
      #1\NAT@@close
      \if*#3*\else
        \textsuperscript{#3}%
      \fi
    \else
      #1%
    \fi
    \endgroup
  }
  %
  % 在 filehook 中无法使用 \cs{patchcmd}，所以只能手动重定义。
  \def\NAT@citexnum[#1][#2]#3{%
    \NAT@reset@parser
    \NAT@sort@cites{#3}%
    \NAT@reset@citea
    \@cite{\def\NAT@num{-1}\let\NAT@last@yr\relax\let\NAT@nm\@empty
      \@for\@citeb:=\NAT@cite@list\do
      {\@safe@activestrue
      \edef\@citeb{\expandafter\@firstofone\@citeb\@empty}%
      \@safe@activesfalse
      \@ifundefined{b@\@citeb\@extra@b@citeb}{%
        {\reset@font\bfseries?}
          \NAT@citeundefined\PackageWarning{natbib}%
        {Citation `\@citeb' on page \thepage \space undefined}}%
      {\let\NAT@last@num\NAT@num\let\NAT@last@nm\NAT@nm
        \NAT@parse{\@citeb}%
        \ifNAT@longnames\@ifundefined{bv@\@citeb\@extra@b@citeb}{%
          \let\NAT@name=\NAT@all@names
          \global\@namedef{bv@\@citeb\@extra@b@citeb}{}}{}%
        \fi
        \ifNAT@full\let\NAT@nm\NAT@all@names\else
          \let\NAT@nm\NAT@name\fi
        \ifNAT@swa
        \@ifnum{\NAT@ctype>\@ne}{%
          \@citea
          \NAT@hyper@{\@ifnum{\NAT@ctype=\tw@}{\NAT@test{\NAT@ctype}}{\NAT@alias}}%
        }{%
          \@ifnum{\NAT@cmprs>\z@}{%
          \NAT@ifcat@num\NAT@num
            {\let\NAT@nm=\NAT@num}%
            {\def\NAT@nm{-2}}%
          \NAT@ifcat@num\NAT@last@num
            {\@tempcnta=\NAT@last@num\relax}%
            {\@tempcnta\m@ne}%
          \@ifnum{\NAT@nm=\@tempcnta}{%
            \@ifnum{\NAT@merge>\@ne}{}{\NAT@last@yr@mbox}%
          }{%
            \advance\@tempcnta by\@ne
            \@ifnum{\NAT@nm=\@tempcnta}{%
              % 在顺序编码制下，\pkg{natbib} 只有在三个以上连续文献引用才会使用连接号，
              % 这里修改为允许两个引用使用连接号。
              % 参考 https://tex.stackexchange.com/a/86991/82731 。
              %
              % \ifx\NAT@last@yr\relax
              %   \def@NAT@last@yr{\@citea}%
              % \else
              %   \def@NAT@last@yr{--\NAT@penalty}%
              % \fi
              \def@NAT@last@yr{-\NAT@penalty}%
            }{%
              \NAT@last@yr@mbox
            }%
          }%
          }{%
          \@tempswatrue
          \@ifnum{\NAT@merge>\@ne}{\@ifnum{\NAT@last@num=\NAT@num\relax}{\@tempswafalse}{}}{}%
          \if@tempswa\NAT@citea@mbox\fi
          }%
        }%
        \NAT@def@citea
        \else
          \ifcase\NAT@ctype
            \ifx\NAT@last@nm\NAT@nm \NAT@yrsep\NAT@penalty\NAT@space\else
              \@citea \NAT@test{\@ne}\NAT@spacechar\NAT@mbox{\NAT@super@kern\NAT@@open}%
            \fi
            \if*#1*\else#1\NAT@spacechar\fi
            \NAT@mbox{\NAT@hyper@{{\citenumfont{\NAT@num}}}}%
            \NAT@def@citea@box
          \or
            \NAT@hyper@citea@space{\NAT@test{\NAT@ctype}}%
          \or
            \NAT@hyper@citea@space{\NAT@test{\NAT@ctype}}%
          \or
            \NAT@hyper@citea@space\NAT@alias
          \fi
        \fi
      }%
      }%
        \@ifnum{\NAT@cmprs>\z@}{\NAT@last@yr}{}%
        \ifNAT@swa\else
          % 将 numerical 式 \cs{citet} 引用的页码置于括号外并改为上标。
          %
          % \@ifnum{\NAT@ctype=\z@}{%
          %   \if*#2*\else\NAT@cmt#2\fi
          % }{}%
          \NAT@mbox{\NAT@@close}%
          \@ifnum{\NAT@ctype=\z@}{%
            \if*#2*\else
              \textsuperscript{#2}%
            \fi
          }{}%
          \NAT@super@kern
        \fi
    }{#1}{#2}%
  }%
  %
  % 将 author-year 式 \cs{citep} 引用的页码置于括号外并改为上标：
  \renewcommand\NAT@cite%
      [3]{\ifNAT@swa\NAT@@open\if*#2*\else#2\NAT@spacechar\fi
          % #1\if*#3*\else\NAT@cmt#3\fi\NAT@@close\else#1\fi\endgroup}
          #1\NAT@@close\if*#3*\else\textsuperscript{#3}\fi\else#1\fi\endgroup}
  %
  % 调整 author-year 式 \cs{citet} 引用的页码。
  \def\NAT@citex%
    [#1][#2]#3{%
    \NAT@reset@parser
    \NAT@sort@cites{#3}%
    \NAT@reset@citea
    \@cite{\let\NAT@nm\@empty\let\NAT@year\@empty
      \@for\@citeb:=\NAT@cite@list\do
      {\@safe@activestrue
      \edef\@citeb{\expandafter\@firstofone\@citeb\@empty}%
      \@safe@activesfalse
      \@ifundefined{b@\@citeb\@extra@b@citeb}{\@citea%
        {\reset@font\bfseries ?}\NAT@citeundefined
                  \PackageWarning{natbib}%
        {Citation `\@citeb' on page \thepage \space undefined}\def\NAT@date{}}%
      {\let\NAT@last@nm=\NAT@nm\let\NAT@last@yr=\NAT@year
        \NAT@parse{\@citeb}%
        \ifNAT@longnames\@ifundefined{bv@\@citeb\@extra@b@citeb}{%
          \let\NAT@name=\NAT@all@names
          \global\@namedef{bv@\@citeb\@extra@b@citeb}{}}{}%
        \fi
      \ifNAT@full\let\NAT@nm\NAT@all@names\else
        \let\NAT@nm\NAT@name\fi
      \ifNAT@swa\ifcase\NAT@ctype
        \if\relax\NAT@date\relax
          \@citea\NAT@hyper@{\NAT@nmfmt{\NAT@nm}\NAT@date}%
        \else
          \ifx\NAT@last@nm\NAT@nm\NAT@yrsep
              \ifx\NAT@last@yr\NAT@year
                \def\NAT@temp{{?}}%
                \ifx\NAT@temp\NAT@exlab\PackageWarningNoLine{natbib}%
                {Multiple citation on page \thepage: same authors and
                year\MessageBreak without distinguishing extra
                letter,\MessageBreak appears as question mark}\fi
                \NAT@hyper@{\NAT@exlab}%
              \else\unskip\NAT@spacechar
                \NAT@hyper@{\NAT@date}%
              \fi
          \else
            \@citea\NAT@hyper@{%
              \NAT@nmfmt{\NAT@nm}%
              \hyper@natlinkbreak{%
                \NAT@aysep\NAT@spacechar}{\@citeb\@extra@b@citeb
              }%
              \NAT@date
            }%
          \fi
        \fi
      \or\@citea\NAT@hyper@{\NAT@nmfmt{\NAT@nm}}%
      \or\@citea\NAT@hyper@{\NAT@date}%
      \or\@citea\NAT@hyper@{\NAT@alias}%
      \fi \NAT@def@citea
      \else
        \ifcase\NAT@ctype
          \if\relax\NAT@date\relax
            \@citea\NAT@hyper@{\NAT@nmfmt{\NAT@nm}}%
          \else
          \ifx\NAT@last@nm\NAT@nm\NAT@yrsep
              \ifx\NAT@last@yr\NAT@year
                \def\NAT@temp{{?}}%
                \ifx\NAT@temp\NAT@exlab\PackageWarningNoLine{natbib}%
                {Multiple citation on page \thepage: same authors and
                year\MessageBreak without distinguishing extra
                letter,\MessageBreak appears as question mark}\fi
                \NAT@hyper@{\NAT@exlab}%
              \else
                \unskip\NAT@spacechar
                \NAT@hyper@{\NAT@date}%
              \fi
          \else
            \@citea\NAT@hyper@{%
              \NAT@nmfmt{\NAT@nm}%
              \hyper@natlinkbreak{\NAT@spacechar\NAT@@open\if*#1*\else#1\NAT@spacechar\fi}%
                {\@citeb\@extra@b@citeb}%
              \NAT@date
            }%
          \fi
          \fi
        \or\@citea\NAT@hyper@{\NAT@nmfmt{\NAT@nm}}%
        \or\@citea\NAT@hyper@{\NAT@date}%
        \or\@citea\NAT@hyper@{\NAT@alias}%
        \fi
        \if\relax\NAT@date\relax
          \NAT@def@citea
        \else
          \NAT@def@citea@close
        \fi
      \fi
      }}\ifNAT@swa\else
        % 将 author-year 式 \cs{citet} 引用的页码置于括号外并改为上标。
        %
        % \if*#2*\else\NAT@cmt#2\fi
        \if\relax\NAT@date\relax\else\NAT@@close\fi
        \if*#2*\else\textsuperscript{#2}\fi
      \fi}{#1}{#2}}
  %
  % 为了将参考文献加入目录和 pdf 书签，重新定义 \pkg{natbib} 的 \cmd{bibsection}
  % 另外如果调用了 \pkg{chapterbib} 或者使用了 \opt{sectionbib} 参数，
  % 需要使用节标题 \cs{section}。
  \newcommand\sysu@bib@chapter{%
    \@mainmatterfalse
    \chapter{\bibname}%
  }%
  \newcommand\sysu@bib@section{%
    \begingroup
      \ctexset{section/numbering=false}%
      \section{\bibname}%
    \endgroup
  }%
  \@ifpackagewith{chapterbib}{sectionbib}{%
    \sysu@error{The "sectionbib" option cannot be used with chaperbib if natbib loaded}%
  }{}%
  \@ifpackageloaded{chapterbib}{%
    \let\bibsection\sysu@bib@section
  }{%
    \@ifxundefined\NAT@sectionbib{%
      \let\bibsection\sysu@bib@chapter
    }{%
      \let\bibsection\sysu@bib@section
    }%
  }%
  %
  % 参考文献列表格式：宋体 10.5 磅，行距 20 磅，续行缩进两字，左对齐。
  \renewcommand\bibfont{%
%    \ifsysu@degree@graduate
      \fontsize{10.5bp}{20bp}\selectfont
%    \else
%      \normalsize
%    \fi
  }
  \setlength{\bibsep}{0\p@ \@plus.2\p@}
  \renewcommand\@biblabel[1]{[#1]\hfill}
  \setlength{\bibhang}{2em}
}


% biblatex 宏包的配置

\AtEndOfPackageFile*{biblatex}{
  \DeclareRobustCommand\inlinecite{\parencite}
  \defbibheading{bibliography}[\bibname]{%
    \@mainmatterfalse
    \chapter{\bibname}%
  }
  \renewcommand\bibfont{%
%    \ifsysu@degree@graduate
      \fontsize{10.5bp}{20bp}\selectfont
%    \else
%      \normalsize
%    \fi
  }
  \setlength{\bibitemsep}{0\p@ \@plus.2\p@}
  \setlength{\bibhang}{2em}
}

% \subsection{附录}

% 定义了一个满足要求的致谢环境：
\newenvironment{acknowledgements}{%
  \@mainmatterfalse
  \chapter{\sysu@acknowledgements@name}%
}{
  \ifsysu@degree@bachelor
    \par
    \null\par
    \begingroup
      \raggedleft
      \sysu@date@zh@short\par
    \endgroup
  \fi
}


% 兼容旧版本中“acknowledgments”的拼法。
% Reserved for compatibility until 2020-07-01.
\newenvironment{acknowledgments}{%
  \begin{acknowledgements}%
}{%
  \end{acknowledgements}%
}

% 科研成果环境：
\newenvironment{achievements}{%
  \@mainmatterfalse
  \chapter{\sysu@achievements@name}%
}{}

% 兼容旧的接口
\newenvironment{publications}{%
  \sysu@deprecated{'publications' environment}{2024-12-15}{'achievements'}%
  \@mainmatterfalse
  \chapter{\sysu@achievements@name}%
}{}

\newenvironment{theachievements}[1][已发表论文]{%
  \par\null\par
  \noindent\textbf{#1：}\par
  \begin{achievementlist}
}{%
  \end{achievementlist}
}

\newlist{achievementlist}{enumerate}{1}
\setlist[achievementlist]{
  topsep     = 0bp,
  partopsep  = 0bp,
  itemsep    = 0bp,
  parsep     = 0bp,
  leftmargin = 1.5em,
  itemindent = 1.5em,
  labelsep   = 0em,
  labelwidth = 3em,
  align      = left,
  label      = （\arabic*）,
}



% \subsection{其他宏包的设置}

% 这些宏包并非格式要求，但是为了方便同学们使用，在这里进行简单设置。


% \subsubsection{\pkg{hyperref} 宏包}

\AtEndOfPackageFile*{hyperref}{
  \hypersetup{
    bookmarksnumbered  = true,
    bookmarksopen      = true,
    bookmarksopenlevel = 1,
%    bookmarksopenlevel = 2, % 书签到二级节（x.x.x），方便编译时浏览
    bookmarksdepth     = 2,
    linktoc            = all,
    unicode            = true,
    psdextra           = true,
  }
  %
  % 如果为 \opt{pdf} 样式，设置 hyperlink 颜色
  \ifsysu@output@electronic
    \hypersetup{
      colorlinks = true,
      allcolors  = green,
    }
  \else
    \hypersetup{hidelinks}
  \fi
  %
  % 填写 PDF 元信息。
  \AtBeginDocument{%
    \ifsysu@main@language@chinese
      \hypersetup{
        pdftitle  = \sysu@title,
        pdfauthor = \sysu@author,
      }%
    \else
      \hypersetup{
        pdftitle  = \sysu@title@en,
        pdfauthor = \sysu@author@en,
      }%
    \fi
  }
  %
  % 添加 PDF 书签
  %
  \newcounter{sysu@bookmarknumber}
  \renewcommand\sysu@pdfbookmark[1]{%
    \phantomsection
    \stepcounter{sysu@bookmarknumber}%
    \pdfbookmark[0]{#1}{sysuchapter.\thesysu@bookmarknumber}%
  }
  %
  % 在 PDF 字符串中去掉换行，以减少 \pkg{hyperref} 的警告信息。
  \pdfstringdefDisableCommands{
    \let\\\@empty
    \let\hspace\@gobble
  }
  %
  % \pkg{hyperref} 与 \pkg{unicode-math} 存在一些兼容性问题，见
  % \href{https://github.com/ustctug/ustcthesis/issues/223}{%
  %   ustctug/ustcthesis\#223}，
  % \href{https://github.com/ho-tex/hyperref/pull/90}{ho-tex/hyperref\#90} 和
  % \href{https://github.com/ustctug/ustcthesis/issues/235}{%
  %   ustctug/ustcthesis/\#235}。
  \@ifpackagelater{hyperref}{2019/04/27}{}{%
    \g@addto@macro\psdmapshortnames{\let\mu\textmu}%
  }
  %
  % 设置中文的 \cs{autoref}。
  % \footnote{\url{https://tex.stackexchange.com/a/66150/82731}}
  \ifsysu@language@chinese
    \def\equationautorefname~#1\null{公式~(#1)\null}
    \def\footnoteautorefname{脚注}
    \def\itemautorefname~#1\null{第~#1~项\null}
    \def\figureautorefname{图}
    \def\tableautorefname{表}
    \def\partautorefname~#1\null{第~#1~部分\null}
    \def\appendixautorefname{附录}
    \def\chapterautorefname~#1\null{第~#1~章\null}
    \def\sectionautorefname~#1\null{第~#1~节\null}
    \def\subsectionautorefname~#1\null{第~#1~小节\null}
    \def\subsubsectionautorefname~#1\null{第~#1~小小节\null}
    \def\paragraphautorefname~#1\null{第~#1~段\null}
    \def\subparagraphautorefname~#1\null{第~#1~小段\null}
    \def\theoremautorefname{定理}
    \def\HyRef@autopageref#1{\hyperref[{#1}]{第~\pageref*{#1} 页}}
  \fi
  %
  % 本科生需要在 \tableofcontents 处切换 \pagenumbering，
  % 在使用了 notoccite 后会导致 PDF 书签的页码有误（#293），
  % 所以需要补充 https://tex.stackexchange.com/a/593839/82731 的 patch。
  % LuaTeX 不需要这个 patch。
  \ifXeTeX
    \def\HyPL@StorePageLabel#1{%
      \begingroup
        \edef\Hy@tempa{\the\Hy@abspage<<#1>>}%
        \immediate\write\@mainaux{%
          \string\HyPL@Entry{\Hy@tempa}%
        }%
      \endgroup
    }
  \fi
}


% \subsubsection{\pkg{amsthm} 宏包}

\AtEndOfPackageFile*{amsthm}{
  \newtheoremstyle{sysuplain}
    {}{}
    {}{2em}
    {\bfseries}{}
    {1em}{}
  \theoremstyle{sysuplain}
  % 定义新的定理
  \ifsysu@language@chinese
    \newcommand\sysu@assertion@name{断言}
    \newcommand\sysu@assumption@name{假设}
    \newcommand\sysu@axiom@name{公理}
    \newcommand\sysu@corollary@name{推论}
    \newcommand\sysu@definition@name{定义}
    \newcommand\sysu@example@name{例}
    \newcommand\sysu@lemma@name{引理}
    \newcommand\sysu@proof@name{证明}
    \newcommand\sysu@proposition@name{命题}
    \newcommand\sysu@remark@name{注}
    \newcommand\sysu@theorem@name{定理}
  \else
    \newcommand\sysu@assertion@name{Assertion}
    \newcommand\sysu@assumption@name{Assumption}
    \newcommand\sysu@axiom@name{Axiom}
    \newcommand\sysu@corollary@name{Corollary}
    \newcommand\sysu@definition@name{Definition}
    \newcommand\sysu@example@name{Example}
    \newcommand\sysu@lemma@name{Lemma}
    \newcommand\sysu@proof@name{Proof}
    \newcommand\sysu@proposition@name{Proposition}
    \newcommand\sysu@remark@name{Remark}
    \newcommand\sysu@theorem@name{Theorem}
  \fi
  \newtheorem{theorem}             {\sysu@theorem@name}    [chapter]
  \newtheorem{assertion}  [theorem]{\sysu@assertion@name}
  \newtheorem{axiom}      [theorem]{\sysu@axiom@name}
  \newtheorem{corollary}  [theorem]{\sysu@corollary@name}
  \newtheorem{lemma}      [theorem]{\sysu@lemma@name}
  \newtheorem{proposition}[theorem]{\sysu@proposition@name}
  \newtheorem{assumption}          {\sysu@assumption@name} [chapter]
  \newtheorem{definition}          {\sysu@definition@name} [chapter]
  \newtheorem{example}             {\sysu@example@name}    [chapter]
  \newtheorem*{remark}             {\sysu@remark@name}
  % \pkg{amsthm} 单独定义了 proof 环境，这里重新定义以满足格式要求。
  % 原本模仿 \pkg{amsthm} 写成 |\item[\hskip\labelsep\hskip2em #1\hskip1em]|，
  % 但是却会多出一些间隙。
  \renewenvironment{proof}[1][\sysu@proof@name]{\par
    \pushQED{\qed}%
    \normalfont \topsep6\p@\@plus6\p@\relax
    \trivlist
      \item\relax\hskip2em\relax
      \textbf{#1}
      \hskip1em\ignorespaces
    }{%
    \popQED\endtrivlist\@endpefalse
  }
  \renewcommand\qedsymbol{\sysu@qed}
}


% \subsubsection{\pkg{algorithm2e} 宏包}

% 按章节编号。
\PassOptionsToPackage{algochapter}{algorithm2e}

\AtEndOfPackageFile*{algorithm2e}{
  \ifsysu@language@chinese
    \SetAlgorithmName{算法}{算法}{算法清单}
  \else
    \SetAlgorithmName{Algorithm}{Algorithm}{List of Algorithms}
  \fi
  %
  % 设置算法环境的格式。
  \SetAlCapSkip{6bp}
  \SetAlCapFnt{\small}
  \SetAlCapNameFnt{\small}
  \ifsysu@degree@graduate
    \SetAlCapNameSty{textbf}
  \fi
  \SetAlgoCaptionSeparator{\unskip\hspace*{1em}}
  %
  % 设置算法清单的格式
  \renewcommand\listofalgocfs{%
    \ifsysu@degree@graduate
      \cleardoublepage
    \fi
    \sysu@chapter{\listalgorithmcfname}%
    \@starttoc{loa}%
  }
  \titlecontents{algocf}
    [2.3em]{\normalsize}
    {\contentslabel{2.3em}}{}
    {\sysu@leaders\contentspage}
  \contentsuse{algocf}{loa}
}


% \subsubsection{\pkg{mathtools} 宏包}

% \pkg{mathtools} 会修改 \pkg{unicode-math} 的 `\underbrace` 和 `\overbrace`，
% 需要还原为 `\LaTeXunderbrace` 和 `\LaTeXoverbrace`，
% 参考 \url{https://tex.stackexchange.com/q/521394/82731}。
\AtEndOfPackageFile*{mathtools}{
  \@ifpackageloaded{unicode-math}{
    \let\underbrace\LaTeXunderbrace
    \let\overbrace\LaTeXoverbrace
  }{}
}

% \subsubsection{\pkg{nomencl} 宏包}

\AtEndOfPackageFile*{nomencl}{
  \let\nomname\sysu@notation@name
  \def\thenomenclature{%
    \ifsysu@degree@graduate
      \cleardoublepage
      \pagestyle{headings}%
    \fi
    \sysu@chapter{\sysu@notation@name}%
    \nompreamble
    \list{}{%
      \labelwidth\nom@tempdim
      \leftmargin\labelwidth
      \advance\leftmargin\labelsep
      \itemsep\nomitemsep
      \let\makelabel\nomlabel}}
  \def\endthenomenclature{%
    \endlist
    \nompostamble
    \ifsysu@degree@graduate
      \clearpage
      \pagestyle{plain}%
    \fi
  }
}


% \subsubsection{\pkg{siunitx} 宏包}

\AtEndOfPackageFile*{siunitx}{
  \newcommand\sysu@set@siunitx@language{%
    \ifsysu@language@chinese
      \sisetup{
        list-final-separator = { 和~},
        list-pair-separator  = { 和 },
        range-phrase         = {～},
      }%
    \else
      \sisetup{
        list-final-separator = {, and },
        list-pair-separator  = { and },
        range-phrase         = { to },
      }%
    \fi
  }
  \sysu@set@siunitx@language
  \sysu@option@hook{language}{\sysu@set@siunitx@language}
}

% \subsubsection{\pkg{chapterbib} 宏包}

\AtEndOfPackageFile*{chapterbib}{
  \@ifpackageloaded{natbib}{%
    \@ifpackagewith{chapterbib}{sectionbib}{%
      \sysu@error{The "sectionbib" option cannot be used with chaperbib if natbib loaded}%
    }{}%
    \renewcommand\bibsection{%
      \begingroup
        \ctexset{section/numbering=false}%
        \section{\bibname}%
      \endgroup
    }
  }{}
}
