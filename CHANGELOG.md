# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [v2.0.0-beta4] 2025-05-03

### changed

- 对示例内容进行调整，减少示例内容，组图示例不再展示。
- 删去空白页页码。
- 参考文献使用 BibLaTeX 编译时不显示 url 和 doi 链接。
- 删去 `sysuthesis.cls` 文件中的版本标识。
- BibLaTeX 将会议论文集析出形式由 [C]// 改为 [C].
- 修改说明文档 `sysuthesis-guide.pdf` 。

## [v2.0.0-beta3] 2025-04-20

### changed

- 本科生内封英文标题改成 `\centerlast` ，英文标题行间距由42 bp 改为37 bp 。
- 研究生扉页英文标题改成 `\centerlast` ，英文标题行间距由25 bp 改为29 bp ，中文标题行间距由28 bp 改为32 bp 。
- 更新 github Action ，减少 CI 所需时间，在发布版中附带说明文档 `sysuthesis-guide.pdf` 。
- 空白页加上页码。
- 研究生页眉更改为：奇数页章标题，偶数页“中山大学博士（硕士）学位论文”。
- 增加组图示例。
- 对研究生扉页进行改动，论文题目与作者信息距离增大，不再挤在一起；委员会的签名栏居中放置。
- 符号说明不再从奇数页另起。

## [v2.0.0-beta2] 2025-04-12


[Unreleased]: https://github.com/1FCENdoge/sysuthesis/compare/v2.0.0-beta4...HEAD
[v2.0.0-beta4]: https://github.com/1FCENdoge/sysuthesis/compare/v2.0.0-beta3...v2.0.0-beta4
[v2.0.0-beta3]: https://github.com/1FCENdoge/sysuthesis/compare/v2.0.0-beta2...v2.0.0-beta3
[v2.0.0-beta2]: https://github.com/1FCENdoge/sysuthesis/releases/tag/v2.0.0-beta2

