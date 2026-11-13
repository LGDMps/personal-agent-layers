# L1 架构演进历史记录 (`01-charter-changelog.md`)

> **文档属性与读取约束**：
> - **层级归属**：`L1-decision`（`01-charter-and-specs.md` 的历史从属文件）
> - **读取策略**：**日常默认不读取（Load-on-Demand Only）**。`L1`、`L2a`、`L2b` 在恢复常规架构上下文时仅读取主文档 `01-charter-and-specs.md`，默认不加载本文件以节约上下文 Token；仅当 `L1` 在任务结项合并 OpenSpec Delta 需要追加记录，或人类用户明确要求追溯历史版本演进时才按需访问。
> - **读写权限**：人类用户（读写）、`L1 决策层`（**仅追加 Append-Only**）、`L2a / L2b / L3`（🚫 **默认不读 / 严禁访问**）

---

## 3. 架构演进记录 (Changelog)

| 日期 | 版本 | 关联任务 ID | 变更类型 (`ADDED`/`MODIFIED`/`REMOVED`) | 变更内容摘要 | 经办层级 |
| :-: | :-: | :-: | :-: | :--- | :---: |
| `<YYYY-MM-DD>` | `v0.1.0` | `-` | `ADDED` | 初始基线：三层模型服务规范（Spec-01）、四区文档隔离规范（Spec-02）与归档生命周期（Spec-03） | `L1` |
| `<YYYY-MM-DD>` | v0.1.1 | - | MODIFIED | 将 PAL 通用运行约束统一收口至根目录 AGENTS.md，并将本章程主文档解耦为面向外部业务项目的待初始化引导模板（Charter-Status: UNINITIALIZED） | L1 |