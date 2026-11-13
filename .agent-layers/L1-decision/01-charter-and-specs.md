# L1 项目整体架构与现状规范 (`01-charter-and-specs.md`)

> **文档属性与权限约束**：
> - **层级归属**：`L1-decision`（项目全局业务愿景与架构规范的唯一真相源 Living State）
> - **Framework-Version**：`v0.1.1`（PAL 框架底座模板版本）
> - **Charter-Status**：`UNINITIALIZED` <!-- 首次通过 /al1-decision 与人类完成业务目标对齐后，改为 INITIALIZED -->
> - **Project-Name**：`<PROJECT_NAME>`
> - **当前业务架构版本**：`v0.1.0-draft`（待首次 `/al1-decision` 会话确认后正式定版）
> - **读写权限**：人类用户（读写）、`L1 决策层`（**读写**，负责首次初始化引导，并在任务结项时将 `L2/briefing.md` 中的业务架构 `Delta` 合并入本文档）、`L2a / L2b 调度层`（**只读**，作为技术方案设计的架构红线依据）、`L3 执行层 (Worker)`（🚫 **严禁访问**，所需上下文必须已由 `L2b` 内联进 `L3-execution/<task-id>/spec.md`）
> - **更新铁律**：本文档永远只反映**目标业务项目**当前已确立或已实现的真实架构状态。每次修改必须同步更新顶部的“当前业务架构版本”，并在同目录独立历史从属文件 [`01-charter-changelog.md`](01-charter-changelog.md) 末尾追加变更摘要与关联 `<task-id>`（日常恢复上下文时默认不读取 `01-charter-changelog.md`）。

---

## 0. 框架底座运行约束引用 (Framework Invariants Reference)

> 本项目启用了 **Personal Agent Layers (PAL)** 分层智能体工作流。关于三层模型角色路由（`/al1-decision`、`/al2a-drafter`、`/al2b-reviewer`、`/al3-worker`）、`L3-Standard / L3-Heavy` 升档审批门禁、四区文档物理隔离、`Inline-or-Never` 零跳执行契约、显式流转状态机以及同角色 Session 复用策略（G1~G6）的全部框架级强制规范，**唯一权威落点为仓库根目录的 [`AGENTS.md`](../../AGENTS.md)（详见其 `## 3. 框架底座运行约束与全局铁律`）**。本文档下方仅承载**本项目自身的业务愿景与技术架构规范**。

---

## 1. 项目愿景与业务边界 (Project Charter — 待首次 `/al1-decision` 初始化填充)

> **初始化提示**：当 `Charter-Status` 为 `UNINITIALIZED`（或 `Project-Name` 仍为 `<PROJECT_NAME>`）时，`L1 决策层` 在首次 `/al1-decision` 会话中应主动扫描仓库顶层结构并引导人类用户确认以下业务要素，填充完毕后将顶部 `Charter-Status` 更新为 `INITIALIZED`。

- **项目名称**：`<PROJECT_NAME>`
- **项目定位与核心解决的问题**：
  - `<待确认：一句话描述本项目面向什么用户/场景，解决什么核心业务或工程问题>`
- **核心业务与工程目标 (In-Scope Goals)**：
  1. `<目标 1：待人类与 L1 对齐后填入>`
  2. `<目标 2：待人类与 L1 对齐后填入>`
- **明确非目标与范围外事项 (Out of Scope)**：
  - `<非目标 1：当前阶段明确不做的事项或外部边界>`

---

## 2. 核心业务与技术架构规范 (Living Specifications — 待填充与持续演进)

### Spec-01：技术栈、运行环境与工程约定 (Tech Stack & Conventions)
- **[MUST]** **核心语言与框架**：`<待填充，如 TypeScript / Python / Rust / Go 等及版本约束>`
- **[MUST]** **构建、测试与代码质量门禁命令**：`<待填充，如单元测试、类型检查、Linter 命令，供 L2b 内联进 L3 spec.md>`
- **[MUST]** **目录结构与模块职责边界**：`<待填充，简述核心源码目录划分与依赖方向约束>`

### Spec-02：核心领域模型与接口契约 (Core Domain & API Contracts)
- **[MUST]** `<待随首个架构/功能任务结项通过 OpenSpec Delta 沉淀填入>`

### Spec-03：安全、性能与外部依赖红线 (Security & Operational Constraints)
- **[MUST]** `<待确认：如敏感配置管理、跨平台兼容性、性能基线或禁止引入的第三方依赖>`

---

## 3. 架构演进记录索引 (Changelog Reference)

- **当前框架底座模板版本**：`v0.1.1`
- **当前业务架构生效版本**：`v0.1.0-draft`（`UNINITIALIZED`）
- **历史演进明细**：已拆分为同目录独立从属文件 [`01-charter-changelog.md`](01-charter-changelog.md)（日常读取主文档时默认不加载；仅在 `L1` 完成章程初始化或合并 Delta 追加记录、以及按需追溯历史时访问）。
