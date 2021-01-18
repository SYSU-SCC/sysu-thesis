# 中山大学Latex论文项目模板

本项目现已得到中山大学计算机学院老师支持，我们正在努力增加feature，满足我院毕业设计的要求，并争取进一步完善，成为中大官方Latex毕设模板。

此项目将会得到长期维护，目前重点在于：

- [x] 增加Github Action支持，编译结果上传到[action](https://github.com/SYSU-SCC/sysu-thesis/actions)中的artifact，免去配置本地环境的烦恼。
- [x] 增加了一种新的封面，可见[#8](https://github.com/SYSU-SCC/sysu-thesis/pull/8)
- [x] 校验排版格式要求，满足相关文件中的格式要求。 如[附件1.中山大学本科生毕业论文（设计）写作与印制规范.doc](./specifications/附件1.中山大学本科生毕业论文（设计）写作与印制规范.doc)
    - 本科生版本done，可见 [#9](https://github.com/SYSU-SCC/sysu-thesis/pull/9) [#10](https://github.com/SYSU-SCC/sysu-thesis/pull/10)
    - 已merge到主线，学院老师已确认。
- [x] 增加使用说明，可见 [#12](https://github.com/SYSU-SCC/sysu-thesis/pull/12)
- [ ] 增加更多的例子、完善文献引用样式
- [ ] 增加CTAN、[overleaf](https://www.overleaf.com/) 等模板库的自动发布，可一键在overleaf中打开项目。

未来将要支持的feature如下：

- [ ] 拆分本科、硕士、与博士的 cls 并抽取出三者共同的基础 cls 配置
- [ ] 进一步完善答辩 ppt 的模板
- [ ] 待增加

希望大家踊跃提出自己的想法，提交pr，一起完善该Latex模板， Make **SYS**U Great Again！

## 相关规范

1. [本科生](./specifications/附件1.中山大学本科生毕业论文（设计）写作与印制规范.doc)
2. [研究生](http://graduate.sysu.edu.cn/rules)

## 一些说明

1. 已征得原作者，17届中大数据院软件工程校友黄俊杰(@huangjj27)的同意，我们团队未来将长期维护该项目。
2. 原项目repo可见[gitlab](https://gitlab.com/sysu-gitlab/latex-group/thesis)，原项目wiki可见[wiki](https://gitlab.com/sysu-gitlab/latex-group/thesis/-/wikis/home)，原repo中的信息将会在之后更新到本repo中。

-------------------------这里是分割线，原始repo的README------------------------------------

# 中山大学LaTeX论文项目模板(非官方)
本维护项目由17届中大数据院软件工程校友黄俊杰(@huangjj27)发起, 发起理由如下:
1. 中山大学在github上[LaTeX官方模板项目](http://github.com/sysu/sysuthesis)已经有2年多的时间没有维护
1. [@chunkwong](https://github.com/chungkwong)师兄在github上放出了中大的第一个[非官方的本科论文LaTeX模板](https://github.com/chungkwong/sysu_thesis), 并由[@GoYchen](https://github.com/GoYchen)师兄接力改进
1. 上述两位师兄毕业后均无法抽空维护项目

基于以上理由, 本项目维护小组成立, 并**_诚邀各届校友参与开发维护, 为中大莘莘学子编写毕业论文提供方便_**

## 使用指南
请移步到[项目wiki](https://gitlab.com/sysu-gitlab/latex-group/thesis/wikis/home)  
_注意:　最新代码在dev分支上, 获取代码前请先确认分支._

## 致谢
1. 感谢[@chunkwong](https://github.com/chungkwong)师兄在Github上放出了中大第一个[非官方的本科论文LaTex模板](https://github.com/chungkwong/sysu_thesis)
1. 感谢[@GoYchen](https://github.com/GoYchen)师兄在模板结构化分解上作出了[极大的贡献](https://github.com/GoYchen/sysu_thesis)
1. 感谢@huangjj27师兄在模板样式规范化做出极大的贡献
1. 感谢@a20185 @Kinpzz @yttty @perqin @noeagles 等人[对v4.6.0作出极大的贡献](https://gitlab.com/sysu-gitlab/latex-group/thesis/merge_requests/32)
1. PPT的模板源自<http://far.tooold.cn/post/latex/beamertsinghua>
1. 最后, 感谢Donald Ervin Knuth教授发明了`tex`这么好(zhe)用(teng)的工具  
    Finally, thanks Pro. Donald Ervin Knuth for inventing such useful tool as tex.

## 错误反馈以及改进
1. 同学们如果在编译或者使用过程中遇到了一些问题，请参照[这里](ihttps://github.com/ryanhanwu/How-To-Ask-Questions-The-Smart-Way)的步骤尝试解决问题。如果还是没法解决，请[email](mailto:incoming+sysu-gitlab/latex-group/thesis@gitlab.com)汇报错误。
1. 如果您想参与项目的维护，我们强烈建议您发起访问请求(Access request)到本项目，即可成为本项目的开发人员! 我们**_非常欢迎校友的加入_**  
    或者，克隆本仓库到您的gitlab仓库中，修改完成后给本项目提交`Merge Request`

## 声明
1. 您可以任意地使用和修改这个模板，但该模板可能无法满足最新的《中山大学本科生毕业论文(设计)写作与印制规范》。
1. 目前项目组人手紧缺, **强烈欢迎校友们的加入**
1. 目前基于GitLab CI的构建工具[使用的字体与规范要求有轻微的区别](https://gitlab.com/sysu-gitlab/latex-group/thesis/merge_requests/29#note_66184589)，请在使用时注意风险.
