# L1 项目整体架构与现状规范 (`01-charter-and-specs.md`)

> **文档属性与权限约束**：
> - **层级归属**：`L1-decision`（借鉴 OpenSpec 的 `project.md` + `specs/` 真相源模式）
> - **读写权限**：人类用户（读写）、`L1 决策层`（**读写**，负责在任务结项时将 `L2/briefing.md` 中的 `Delta` 合并入本文档并记录 `Changelog`）、`L2a / L2b 调度层`（**只读**，作为技术方案设计的架构红线依据）、`L3 执行层 (Worker)`（🚫 **严禁访问**，所需上下文必须已由 `L2b` 内联进 `L3-execution/<task-id>/spec.md`）
> - **更新铁律**：本文档永远只反映项目**当前已确立或已实现**的真实架构状态。每次修改必须在底部 `## 架构演进记录 (Changelog)` 登记变更摘要与关联的 `<task-id>`。

---

## 1. 项目愿景与边界 (Project Charter)

- **项目名称**：Personal Agent Layers（面向单项目的分层智能体工作流与多级文档隔离体系）
- **核心目标**：
  1. 依据基础模型能力差异实现职责分化（`L1 决策层`、`L2a/L2b 调度层双模型协作`、`L3 执行层 Worker`），最大化人类注意力价值并优化模型额度消耗。
  2. 以仓库本地 `.agent-layers/` 多级文档作为跨 Session、跨 Harness 的唯一权威状态源（Single Source of Truth），彻底消除长会话腐化与二跳检索上下文爆炸问题。
- **非目标（Out of Scope — 当前阶段）**：
  - 暂不构建接管外部 IM / GitHub Webhook 的通用常驻守护架构；
  - 严格限定在单个 Project / Workspace 仓库内部运作。

---

## 2. 核心架构规范 (Living Specifications)

### Spec-01：三层模型服务与职责边界
- **[MUST]** 跨层级的任务委派（`L1 → L2a → L2b → L3 → L2b → L1`）必须通过创建全新的 Session 完成，严禁使用 `subagent` 跨层执行。
- **[MUST]** `L1`、`L2a`、`L2b` 三个高层角色严禁直接修改业务源码，仅允许读写各自权限范围内的 `.agent-layers/` 文档；业务源码的修改权由 `L3 执行层 (Worker)` 独占。
- **[MUST]** 每次跨层交接时，当前 Session 必须生成自包含的【跨 Harness 人工转接指令块】，支持人类用户在任意外部 Harness 软件中直接粘贴启动下一层 Session。

### Spec-02：四区物理隔离与 Inline-or-Never 契约
- **[MUST]** `.agent-layers/` 下设四个活跃文档区：
  - `L1-decision/`：战略意图流、全局架构规范、全局排期表；
  - `L2-dispatch/<task-id>/`：决策层下发的 `mandate.md` 与调度层向上汇总的 `briefing.md`；
  - `L2-internal/<task-id>/`：调度层内部 `L2a` 初稿 (`draft-plan.md`) 与 `L2b` 审校记录 (`review-notes.md`)，对 `L1` 默认隐藏，对 `L3` 绝对不可见；
  - `L3-execution/<task-id>/`：经 `L2b` 提炼定稿的自包含执行规约 (`spec.md`) 与 `L3` 执行汇报 (`worker-report.md`)。
- **[MUST]** `L3-execution/<task-id>/spec.md` 必须自包含所有文件路径、接口签名、实现步骤与验证命令，使 `L3` 模型在零额外文档搜索（0-hop）的前提下完成工作。

### Spec-03：Delta 回写与完工归档 (Archive Lifecycle)
- **[MUST]** 任务在 `L2b` 验收通过后，必须在 `L2-dispatch/<task-id>/briefing.md` 中声明本次任务对架构规范产生的增量（`ADDED` / `MODIFIED` / `REMOVED`）。
- **[MUST]** `L1 决策层` 审阅结项时，先将增量合并入本文件，随后将 `<task-id>` 在 `L2-dispatch`、`L2-internal`、`L3-execution` 下的目录统一移入 `.agent-layers/archive/<YYYY-MM-DD>-<task-id>/`。

---

## 3. 架构演进记录 (Changelog)

| 日期 | 版本 | 关联任务 ID | 变更类型 (`ADDED`/`MODIFIED`/`REMOVED`) | 变更内容摘要 | 经办层级 |
| :-: | :-: | :-: | :-: | :--- | :---: |
| `<YYYY-MM-DD>` | `v0.1.0` | `-` | `ADDED` | 初始基线：三层模型服务规范（Spec-01）、四区文档隔离规范（Spec-02）与归档生命周期（Spec-03） | `L1` |
