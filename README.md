# 中山大学 $\LaTeX$ 毕业论文模板

本项目现已得到中山大学计算机学院支持。我们正在努力增加 feature ，满足本院毕业设计的要求，并争取进一步完善，成为中大官方 $\LaTeX$ 毕设模板。Demo 与源码可在 [releases](https://github.com/SYSU-SCC/sysu-thesis/releases) 页面下载。

**诚挚邀请广大校友加入本项目维护，详见 [#67](https://github.com/SYSU-SCC/sysu-thesis/issues/67)、[#105](https://github.com/SYSU-SCC/sysu-thesis/pull/105)。希望加入 collaborator 团队的同学可联系 [@wu-kan](https://github.com/wu-kan)。**

## 如何使用

### overleaf 编辑（在线）

本模板可以使用 [overleaf](https://www.overleaf.com/) 在线编辑，需要在 [releases](https://github.com/SYSU-SCC/sysu-thesis/releases) 页面提前下载 `Source code (zip)`。

步骤如下：

1. 进入 [overleaf](https://overleaf.com) 并登录账号
2. 左侧 `New Project` 选择 `Upload Project`
3. 上传 `.zip` 压缩包，建立新项目
4. 点击 `menu`，滑动到下方 `Settings` 的 `Compiler` 选择 `XeLaTeX`
5. 打开 `main.tex` 文件，点击中间右侧上方的 `Recompile` 进行编译
6. 如果顺利可以看到 pdf 的预览
7. 如果无法加载图片只有路径信息，点击 `Recompile` 旁边的倒三角，其中的 `Compile Mode` 选择 `Normal` 模式

此时可以得到完整的 `main.pdf` 文件。

### GitHub Actions 自动构建（在线）

点击 [Use this template](https://github.com/SYSU-SCC/sysu-thesis/generate) 创建自己的论文仓库（推荐创建为私有仓库），随后直接在自己的仓库进行修改，随后 GitHub Actions 会自动进行构建，可在 Actions 中下载对应 artifact。此处给出一个[示例](https://github.com/wu-kan/bachelor-thesis)。

还可以使用 `git tag`，其会像本仓库一样将构建好的 artifact 永久发布到 [releases](https://github.com/SYSU-SCC/sysu-thesis/releases) 中。

### Devcontainer 编辑（本地 & 在线）

> [!IMPORTANT]  
> 无论是本地还是在线编辑，都需要首先创建自己的论文仓库，在自己的仓库进行修改，并建议及时 `commit & push` 到远程仓库进行备份。

本模板提供了 [VS Code Remote - Containers](https://code.visualstudio.com/docs/remote/containers) 相关配置文件，包含了 texlive 2022 和 VS Code 中文和 LaTeX Workshop 插件，可用于本地或在线容器化编辑。

- 对于在线编辑，可以使用 [GitHub Codespaces](https://docs.github.com/zh/codespaces/developing-in-a-codespace/creating-a-codespace-for-a-repository) 通过浏览器版本的 VS Code 进行编辑。（请注意，GitHub Codespaces 每月免费额度有限，请注意用量）。
- 而对于本地编辑，需要安装 [Docker](https://docs.docker.com/get-docker/) 和 [VS Code](https://code.visualstudio.com/)，并在 VSCode 中安装 [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) 插件。随后打开本仓库，键入 `F1`，选择 `Remote-Containers: Reopen in Container` 即可构建进入容器环境。

在容器环境中，可以使用 `make pdf` 进行编译并生成 `main.pdf` 文件，或者使用 LaTeX Workshop 插件进行编译与预览。

### texlive 编辑（本地）

本模板需要使用 texlive(>=2020) 进行编译，编译命令如下：

```
make pdf
```

即可生成 `main.pdf` 文件。如有环境问题，推荐对照 [GitHub Actions](./.github/workflows/test.yml) 中的环境进行配置。

## TODO List

- [ ] 增加 [overleaf](https://www.overleaf.com/) 等模板库的自动发布，可一键在 overleaf 中打开项目。
- [ ] 进一步优化代码，可支持多种需求

希望大家踊跃提出自己的想法，提交 pr，一起完善该 $\LaTeX$ 模板， Make **SYS**U Great Again！

## 需要注意的问题

1. 字体问题，见 [#29](https://github.com/SYSU-SCC/sysu-thesis/issues/29)

## 相关规范

1. [本科生](./specifications/附件1.中山大学本科生毕业论文（设计）写作与印制规范.doc)
2. [研究生](http://graduate.sysu.edu.cn/rules)

## 关于展示

答辩展示的样式涉及到不同人的需求，且学校未对格式做要求，因此目前本仓库提供了一个最简单的模板供大家学习和上手调整，在 overleaf 中使用时需要点击 `menu`，滑动到下方 `Settings` 的 `Main document` 选择 `pre.tex`。此处给出 [overleaf 的 Beamer 教程](https://overleaf.com/learn/latex/Beamer)。

我们欢迎大家自己定制一些符合自己要求的模板，并向我们提交 PR，在下方增加一个指向你的模板的链接作为推荐，参见 [#65](https://github.com/SYSU-SCC/sysu-thesis/issues/65) 。

- [Lovely-XPP/SYSU-PRE](https://github.com/Lovely-XPP/SYSU-PRE)
- [NelsonCheung-cn/SYSU-beamer-template](https://github.com/NelsonCheung-cn/SYSU-beamer-template)

## 一些说明

1. 已征得原作者，17 届中大数据院软件工程校友黄俊杰(@huangjj27)的同意，我们团队未来将长期维护该项目。
2. 原项目 repo 可见 [gitlab](https://gitlab.com/sysu-gitlab/latex-group/thesis)，原项目 wiki 可见 [wiki](https://gitlab.com/sysu-gitlab/latex-group/thesis/-/wikis/home)，原 repo 中的信息将会在之后更新到本 repo 中。

---

~~这里是分割线，以下是原始 repo 的 README~~

---

本维护项目由 17 届中大数据院软件工程校友黄俊杰(@huangjj27)发起, 发起理由如下:

1. 中山大学在 github 上[LaTeX 官方模板项目](http://github.com/sysu/sysuthesis)已经有 2 年多的时间没有维护
1. [@chunkwong](https://github.com/chungkwong)师兄在 github 上放出了中大的第一个[非官方的本科论文 LaTeX 模板](https://github.com/chungkwong/sysu_thesis), 并由[@guanyingc](https://github.com/guanyingc)师兄接力改进
1. 上述两位师兄毕业后均无法抽空维护项目

基于以上理由，本项目维护小组成立，并***诚邀各届校友参与开发维护, 为中大莘莘学子编写毕业论文提供方便***。

## 使用指南

请移步到[项目 wiki](https://gitlab.com/sysu-gitlab/latex-group/thesis/wikis/home)

_注意:　最新代码在 dev 分支上, 获取代码前请先确认分支._

## 致谢

1. 感谢[@chunkwong](https://github.com/chungkwong)师兄在 Github 上放出了中大第一个[非官方的本科论文 LaTex 模板](https://github.com/chungkwong/sysu_thesis)
1. 感谢[@guanyingc](https://github.com/guanyingc)师兄在模板结构化分解上作出了[极大的贡献](https://github.com/guanyingc/SYSU-LaTex-Thesis)
1. 感谢@huangjj27 师兄在模板样式规范化做出极大的贡献
1. 感谢@a20185 @Kinpzz @yttty @perqin @noeagles 等人[对 v4.6.0 作出极大的贡献](https://gitlab.com/sysu-gitlab/latex-group/thesis/merge_requests/32)
1. PPT 的模板源自<http://far.tooold.cn/post/latex/beamertsinghua>
1. 最后, 感谢 Donald Ervin Knuth 教授发明了`tex`这么好(zhe)用(teng)的工具。
   Finally, thanks Prof. Donald Ervin Knuth for inventing such useful tool as tex.

## 错误反馈以及改进

1. 同学们如果在编译或者使用过程中遇到了一些问题，请参照[这里](ihttps://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way)的步骤尝试解决问题。如果还是没法解决，请[email](mailto:incoming+sysu-gitlab/latex-group/thesis@gitlab.com)汇报错误。
1. 如果您想参与项目的维护，我们强烈建议您发起访问请求(Access request)到本项目，即可成为本项目的开发人员! 我们***非常欢迎校友的加入***。
   或者，克隆本仓库到您的 gitlab 仓库中，修改完成后给本项目提交`Merge Request`。

## 声明

1. 您可以任意地使用和修改这个模板，但该模板可能无法满足最新的《中山大学本科生毕业论文(设计)写作与印制规范》。
1. 目前项目组人手紧缺，**强烈欢迎校友们的加入**。
1. 目前基于 GitLab CI 的构建工具[使用的字体与规范要求有轻微的区别](https://gitlab.com/sysu-gitlab/latex-group/thesis/merge_requests/29#note_66184589)，请在使用时注意风险。
