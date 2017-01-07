# 中山大学本科毕业论文非正式LaTex模板

这个模板根据2016年中山大学本科毕业论文Word模板设计的。本人2016级毕业生，毕业论文是根据这个LaTex模板编写的。模板中给出了论文书写中经常会用的一些代码例子：如插入图像，绘制表格，描述算法流程，书写公式等。同学们可以参考这些例子来满足自己的需求。该模板同时包含了一个基于LaTex Beamer的用于答辩的PPT模板。

该模板只是定义了一些基本的宏，设置了简单的布局来方便同学们写毕业论文，并不是一个规范的LaTex模板。限于水平和时间，我只能大概的整理一下，给出一些基本的文档说明。
同学们可以先打开 [main.pdf](main.pdf) 和 [presentation/pre.pdf](presentation/pre.pdf) 看看效果，如果合适的话再考虑使用。

## 安装使用
该模板在Ubuntu 14.04 texlive和Windows CTex下通过了编译。默认为在Ubuntu下使用Makefile进行编译管理，同学们也可以在Windows下使用CTex套件打开main.tex用XeLaTex进行编译。

在Ubuntu下使用时，需要先下载Adobe中文字体并放到系统字体路径。在Windows下使用时，需要修改一两行代码，将字体选择为Windows字体，因为模板默认使用Adobe字体。同学们可以根据下面的教程配置字体选项。

0. Ubuntu下使用教程
 - 安装Texlive, 用于编译写好的LaTex文档
 ```
 sudo apt-get install texlive-full
 ```
 - 下载并安装[Adobe Song Std Fonts](http://download.csdn.net/detail/wpc0000/6762849)字体,因为Ubuntu自身没有合适的中文字体
  ```
  #先解压文件，然后使用终端进入解压后的路径,根据下面命令将字体拷到系统字体路径
  sudo mkdir /usr/share/fonts/texfonts/ sudo cp *.otf /usr/share/fonts/texfonts/
  sudo cd /usr/share/fonts/texfonts/
  sudo mkfontscale
  sudo mkfontdir
  sudo fc-cache -fv
  ```
 - 编译模板
  ```
  make      #编译论文
  make show #打开论文
  ```
0. Windows下使用教程
 - 安装CTex, 
 - 修改字体为Windos字体(`sysuthsis.cls`的第七行)
  ```
  %\LoadClass[adobefonts,a4paper,openany,cs4size,hyperref]{ctexbook}
  \LoadClass[winfonts,a4paper,openany,cs4size,hyperref]{ctexbook} %在windows编译且希望使用微软的字体时请把adobefonts改为winfonts
  ```
 - 打开main.tex并使用XeLaTex编译
  
## 文件层次
该模板按不同的模块来组织

0. 论文模板结构
 - `main.pdf`:	生成的论文
 - `main.tex`:	模板的主文件（负责组织论文整体架构)
 - `main.bib`:	参考文献的数据库
 - `docs/`:		存放论文的不同章节
 - `image/`:	存放论文使用的图像
 - `figure/`:	存放论文的插图代码
 - `table/`:	存放论文的表格代码
 - `sysuthesis.cls`: 模板的主题（封面目录等的设计都在这文件里面）
 - `sysuthesis.bst`: 参考文献的格式(不过现在默认使用ieeetr)
 - `packages/`: 存放一些工具包(目前只有支持中文算法流程图的包)
 - `Makefile`:	Linux系统下管理编译的文件
 - `presentation/`: 论文配套的答辩PPT

0. PPT模板结构`(presentation/`目录下)
 - `pre.pdf`: 生成的PPT(PDF格式)
 - `chape01-6`: 各个章节
 - `figures`: 存放用到的图片
 - `thubeamer.sty`: 模板的格式
 - `Makefile`: Linux系统下管理编译的文件

## 论文的组成
0. 封面: `sysuthesis.cls`, `docs/cover.tex`
0. 中期报告: 该模板不包含各种阶段报告，因为需要老师签名，无法合在一起
0. 学术诚信声明: `docs/disclaim.tex`
0. 中英摘要: `docs/cover.tex`
0. 目录: 自动生成章节与图表目录，`sysuthesis.cls`设置
0. 各个章节：引言，基础理论知识，方法，实验与结果，总结与展望 `docs/chap01-05.tex`
0. 参考文献：通过bibtex来管理参考文献 `main.tex` `main.bib`
0. 致谢: `docs/ack.tex`
0. 附录: `docs/appendix1`
0. 答辩演示文稿：`presentation/`

## LaTex 学习资源
0. 刘海洋的LaTex入门：非常适合初学者使用，可以根据自己的需求查找代码
0. 更多例子可以参考[清华大学LaTex模板](https://github.com/xueruini/thuthesis)
0. **有需求可以直接在Google上搜，基本上都能找到的。**

## 致谢
0. 在这里我要感谢@chungkwong师兄，他是第一个在Github上放出了中大的第一个[非官方的本科论文LaTex模板](https://github.com/chungkwong/sysu_thesis)，而本模板是在其版本上改进的。
0. PPT的模板源自 [http://far.tooold.cn/post/latex/beamertsinghua]

## 错误反馈以及改进
0. 同学们如果在编译或者使用过程中遇到了一些问题，可以先尝试将错误信息粘贴到Google搜索一下答案，如果还是没法解决，可以在这个代码仓库的Issues里汇报错误。已经成功编译或对LaTex比较熟悉的同学可以帮忙解决一下问题，我相信大家都可以克服途中遇到的各种小问题的。
0. 对LaTex很熟悉的同学也可以出一份力改进或自己写一份好的模板，帮助学弟学妹们更方便地用LaTex书写论文。可以直接push commits到这个仓库或者重新建一个仓库。

## 声明
您可以任意地使用和修改这个模板，但该模板可能无法满足最新的《中山大学本科生毕业论文(设计)写作与印制规范》，并且本人不对任何因为使用了该模板而带来的问题负责。


## Undergraduate Thesis

#### Topic: Combining LSTM and Convolutional Feature for Semantic Segmentation

#### This code can be a LaTex template for undergraduate thesis of Sun Yat-sen University.

#### Presentation folder contains a beamer template for the slides.
