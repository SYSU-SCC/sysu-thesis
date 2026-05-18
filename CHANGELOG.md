# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v2.0.0-beta7] 2026-05-17

### changed

- 整理和修改了 `CHANGELOG.md` 中的部分内容，使 `CHANGELOG.md` 文件更具可读性。
- 引用格式适配国标 GB/T 7714-2025

### fixed

- 修复 `package bicaption: main language is not set` 警告。
- 修复本科生模板中`headsep`、`headheight`、`footskip`未定义的问题。
- 按照本科生模板要求对本科生模板进行修订。

### deleted

- 删除了法语摘要。
- 删除了自动发布功能。

### added

- 添加了一些图片示例和代码示例。
- `release` 页面添加本科生和研究生论文格式规范。

## [v2.0.0-beta6] 2026-03-16

### changed

- 去掉扉页上原本预留给密级的空间，但仍保留对应代码以备不时之需（注：中山大学不接受涉密论文送审）。
- 将overleaf中的默认字体改为fandol。
- 修改了github CI。
- 将`author-year` 参考文献样式会议论文集析出形式由 [C]// 改为 [C].

### deleted

- 研究生论文格式可能要更改，之前的链接已失效。
- 移除图表目录中章之间的空行。

### fixed

- 修正 LuaTeX 部分符号错误地使用西文字体（[tuna/thuthesis#1022](https://github.com/tuna/thuthesis/issues/1022)）。
- 修复与`nomencl`宏包间的冲突。
- 修复vscode中latex插件无法一次编译全部生成的问题，详见[此处](https://github.com/ustctug/ustcthesis/issues/493)。
- 修正“关键词”的格式。
- 修正了调用 `mathtools` 后 `\eqref` 与前文间距的问题（[tuna/thuthesis#1043](https://github.com/tuna/thuthesis/discussions/1043)）。

## [v2.0.0-beta5] 2026-02-13

### added

- 添加 `author-year` 参考文献样式以及 `inline` 引用样式。
- 恢复参考文献引用样式示例。

### deleted

- 删除生僻字测试。

### changed

- 将证明完成的小方块从实心方块换成空心方块。
- 本科生内封英文标题改成 `\centering` 。
- 研究生扉页英文标题改成 `\centering` 。
- 对说明文档进行修订。
- 对参考文献样式进行更新。

### fixed

- 修正声明页中是否控阅选项错误换行的问题（好像不太用得上，中山大学不允许提交涉密论文）（见[此处](https://github.com/ustctug/ustcthesis/issues/470)）。
- 修复引用著作 edition=1 时 bibtex 无法通过编译的问题（见[此处](https://github.com/ustctug/ustcthesis/issues/476)）。

## [v2.0.0-beta4] 2025-05-03

### changed

- BibLaTeX 将会议论文集析出形式由 [C]// 改为 [C].
- 修改说明文档 `sysuthesis-guide.pdf` 。

### deleted

- 删去空白页页码。
- 删去 `sysuthesis.cls` 文件中的版本标识。
- 参考文献使用 BibLaTeX 编译时不显示 url 和 doi 链接。
- 减少示例内容，组图示例不再展示。

## [v2.0.0-beta3] 2025-04-20

### changed

- 本科生内封英文标题改成 `\centerlast` ，英文标题行间距由42 bp 改为37 bp 。
- 研究生扉页英文标题改成 `\centerlast` ，英文标题行间距由25 bp 改为29 bp ，中文标题行间距由28 bp 改为32 bp 。
- 更新 github Action ，减少 CI 所需时间，在发布版中附带说明文档 `sysuthesis-guide.pdf` 。
- 研究生页眉更改为：奇数页章标题，偶数页“中山大学博士（硕士）学位论文”。
- 对研究生扉页进行改动，论文题目与作者信息距离增大，不再挤在一起；委员会的签名栏居中放置。
- 符号说明不再从奇数页另起。

### added

- 空白页加上页码。
- 增加组图示例。

## [v2.0.0-beta2] 2025-04-12


[Unreleased]: https://github.com/1FCENdoge/sysuthesis/compare/v2.0.0-beta7...HEAD
[v2.0.0-beta7]: https://github.com/1FCENdoge/sysuthesis/compare/v2.0.0-beta6...v2.0.0-beta7
[v2.0.0-beta6]: https://github.com/1FCENdoge/sysuthesis/compare/v2.0.0-beta5...v2.0.0-beta6
[v2.0.0-beta5]: https://github.com/1FCENdoge/sysuthesis/compare/v2.0.0-beta4...v2.0.0-beta5
[v2.0.0-beta4]: https://github.com/1FCENdoge/sysuthesis/compare/v2.0.0-beta3...v2.0.0-beta4
[v2.0.0-beta3]: https://github.com/1FCENdoge/sysuthesis/compare/v2.0.0-beta2...v2.0.0-beta3
[v2.0.0-beta2]: https://github.com/1FCENdoge/sysuthesis/releases/tag/v2.0.0-beta2

