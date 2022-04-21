# 中山大学 LaTeX 毕业论文模板

本项目现已得到中山大学计算机学院老师支持，我们正在努力增加 feature ，满足我院毕业设计的要求，并争取进一步完善，成为中大官方 LaTeX 毕设模板。

## 如何使用

### texlive编辑

本模板需要使用texlive(>=2020)进行编译，编译命令如下：

```
make pdf
```

即可生成 `main.pdf` 文件。



### overleaf 编辑

本模板可以使用[overleaf](https://www.overleaf.com/) 在线编辑。

步骤如下：

1. 进入网站https://overleaf.com并登录账号
2. 左侧`New Project`选择`Upload Project`
3. 上传`sysu-thesis-master.zip`压缩包，建立新项目
4. 点击`menu`，滑动到下方`Settings`的`Compiler`选择`XeLaTeX`
5. 打开`main.tex`文件，点击中间右侧上方的`Recompile`进行编译
6. 如果顺利可以看到pdf的预览
7. 如果无法加载图片只有路径信息，点击`Recompile`旁边的倒三角，其中的`Compile Mode`选择`Normal`模式

此时可以得到完整的`main.pdf`文件



## TODO List

- [ ] 增加 [overleaf](https://www.overleaf.com/) 等模板库的自动发布，可一键在 overleaf 中打开项目。
- [ ] 进一步完善答辩 ppt 的模板
- [ ] 进一步优化代码，可支持多种需求

希望大家踊跃提出自己的想法，提交 pr，一起完善该 $\LaTeX$ 模板， Make **SYS**U Great Again！

## 需要注意的问题

1. 字体问题，见 [#29](https://github.com/SYSU-SCC/sysu-thesis/issues/29)



## 相关规范

1. [本科生](./specifications/附件1.中山大学本科生毕业论文（设计）写作与印制规范.doc)
2. [研究生](http://graduate.sysu.edu.cn/rules)

## 一些说明

1. 已征得原作者，17 届中大数据院软件工程校友黄俊杰(@huangjj27)的同意，我们团队未来将长期维护该项目。
2. 原项目 repo 可见[gitlab](https://gitlab.com/sysu-gitlab/latex-group/thesis)，原项目 wiki 可见[wiki](https://gitlab.com/sysu-gitlab/latex-group/thesis/-/wikis/home)，原 repo 中的信息将会在之后更新到本 repo 中。

---

~~这里是分割线，以下是原始 repo 的 README~~

---

本维护项目由 17 届中大数据院软件工程校友黄俊杰(@huangjj27)发起, 发起理由如下:

1. 中山大学在 github 上[LaTeX 官方模板项目](http://github.com/sysu/sysuthesis)已经有 2 年多的时间没有维护
1. [@chunkwong](https://github.com/chungkwong)师兄在 github 上放出了中大的第一个[非官方的本科论文 LaTeX 模板](https://github.com/chungkwong/sysu_thesis), 并由[@guanyingc](https://github.com/guanyingc)师兄接力改进
1. 上述两位师兄毕业后均无法抽空维护项目

基于以上理由, 本项目维护小组成立, 并**_诚邀各届校友参与开发维护, 为中大莘莘学子编写毕业论文提供方便_**

## 使用指南

请移步到[项目 wiki](https://gitlab.com/sysu-gitlab/latex-group/thesis/wikis/home)
_注意:　最新代码在 dev 分支上, 获取代码前请先确认分支._

## 致谢

1. 感谢[@chunkwong](https://github.com/chungkwong)师兄在 Github 上放出了中大第一个[非官方的本科论文 LaTex 模板](https://github.com/chungkwong/sysu_thesis)
1. 感谢[@guanyingc](https://github.com/guanyingc)师兄在模板结构化分解上作出了[极大的贡献](https://github.com/guanyingc/SYSU-LaTex-Thesis)
1. 感谢@huangjj27 师兄在模板样式规范化做出极大的贡献
1. 感谢@a20185 @Kinpzz @yttty @perqin @noeagles 等人[对 v4.6.0 作出极大的贡献](https://gitlab.com/sysu-gitlab/latex-group/thesis/merge_requests/32)
1. PPT 的模板源自<http://far.tooold.cn/post/latex/beamertsinghua>
1. 最后, 感谢 Donald Ervin Knuth 教授发明了`tex`这么好(zhe)用(teng)的工具
   Finally, thanks Pro. Donald Ervin Knuth for inventing such useful tool as tex.

## 错误反馈以及改进

1. 同学们如果在编译或者使用过程中遇到了一些问题，请参照[这里](ihttps://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way)的步骤尝试解决问题。如果还是没法解决，请[email](mailto:incoming+sysu-gitlab/latex-group/thesis@gitlab.com)汇报错误。
1. 如果您想参与项目的维护，我们强烈建议您发起访问请求(Access request)到本项目，即可成为本项目的开发人员! 我们**_非常欢迎校友的加入_**
   或者，克隆本仓库到您的 gitlab 仓库中，修改完成后给本项目提交`Merge Request`

## 声明

1. 您可以任意地使用和修改这个模板，但该模板可能无法满足最新的《中山大学本科生毕业论文(设计)写作与印制规范》。
1. 目前项目组人手紧缺, **强烈欢迎校友们的加入**
1. 目前基于 GitLab CI 的构建工具[使用的字体与规范要求有轻微的区别](https://gitlab.com/sysu-gitlab/latex-group/thesis/merge_requests/29#note_66184589)，请在使用时注意风险.
