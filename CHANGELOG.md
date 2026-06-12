# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- 默认数学符号风格 `math-style` 改为 `TeX`。
- 本科生模板去掉 pdf 文件内封面的书签。

### Fixed

- 修正了调用 `mathtools` 后 `\eqref` 与前文间距的问题（[tuna/thuthesis#1043](https://github.com/tuna/thuthesis/discussions/1043)）。
- 修正 biblatex 中 authoryear 参考文献样式不同作者仅因同姓被错误地认为是同一作者的错误（[ustctug/ustcthesis#499](https://github.com/ustctug/ustcthesis/issues/499)、[hushidong/biblatex-gb7714-2015#236](https://github.com/hushidong/biblatex-gb7714-2015/issues/236)）。
- biblatex：修正期刊类型避免无卷期时的报错。

## [2.1.0] - 2026-06-01

### 版本亮点

- 支持本科/研究生论文模板切换。
- 支持 GB/T 7714-2025 参考文献引用样式。
- 支持跨平台编译。
- 附带中山大学答辩 ppt LaTeX 模板。
- 简化示例内容。


[Unreleased]: https://github.com/SYSU-SCC/sysu-thesis/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/SYSU-SCC/sysu-thesis/releases/tag/v2.1.0
