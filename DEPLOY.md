# Personal Agent Layers (PAL) 声明式部署与升级指南 (`DEPLOY.md`)

> **文档属性**：`framework/DEPLOY.md` — 面向 Agent 的纯声明式部署/升级规程。
> **设计原则**：**零脚本依赖（Agent-Native）**。本文件不含任何 `.ps1` / `.sh` / `.py` / `.js` 可执行脚本，全部操作为有权限的 Agent 按本文件描述的确定性步骤完成。
> **适用对象**：希望把 PAL 三层模型服务 + 四区文档隔离体系，安装或非破坏性升级到外部业务项目仓库的人类用户与工程 Agent。

---

## 1. 概述与权限原则 (Overview & Authority Rules)

本指南供人类把 PAL **首次安装**或**增量升级**到任意目标业务项目仓库时，直接交给一个具备文件读写权限的 Agent 执行。Agent 只需阅读本文件即可完成任务，不需要任何外部脚本。

- **权威落点**：PAL 的通用框架约束（三层角色路由、双算力档位审批门禁、四区隔离、Inline-or-Never、显式流转状态机、Session 复用策略 G1~G6）统一收口于部署后目标项目根目录的 `AGENTS.md` 第 3 节；本指南只负责**文件怎么放、冲突怎么处理**，不重复框架条文。
- **权限防呆（强制）**：
  1. 若当前执行会话已激活某个 PAL 层级角色（如 `/al1-decision`、`/al2a-drafter`、`/al2b-reviewer`、`/al3-worker`），**不得借部署指令突破当前角色的写权限红线**；
  2. 部署/升级应在**未绑定受限角色的通用工程 Agent 会话**中执行，或经 `L1 -> L2 -> L3` 明确白名单授权的框架维护会话执行；
  3. 部署 Agent **只允许**创建/补齐 PAL 框架文件，**严禁**顺手修改目标项目的业务源码。
- **非破坏性承诺**：任何模式下都不得删除目标项目已有的业务文件、任务包、模型配置与决策记录（详见第 5 节绝对保护区）。

---

## 2. Step 0：同源目录与真实路径硬拦截（Mandatory Path Guard）

在执行任何文件写入前，Agent 必须解析、规范化并**打印**以下两个路径：

- `SOURCE_FRAMEWORK_DIR`：源框架目录的真实规范化绝对路径。必须是**公开 `framework` 目录**（该目录下应同时存在 `DEPLOY.md`、`AGENTS.md`、`.agents/skills/`、`.agent-layers/_templates/`）。**不得**直接把私有主仓根目录当作源。
- `TARGET_PROJECT_DIR`：目标业务项目仓库的真实规范化绝对路径。必须解析 `.`、`..`、大小写差异、符号链接与目录联接后再比较。

**硬拦截条件（命中任意一条必须立即中止，严禁写入任何文件）**：

1. `SOURCE_FRAMEWORK_DIR` 与 `TARGET_PROJECT_DIR` 指向同一真实目录；
2. `TARGET_PROJECT_DIR` 就是公开框架仓库本身，或位于 `SOURCE_FRAMEWORK_DIR` 的子目录内；
3. 源目录缺失核心框架资产（`DEPLOY.md` / `AGENTS.md` / `.agents/skills/al1-decision/SKILL.md` / `.agent-layers/_templates/` 任一缺失）；
4. `TARGET_PROJECT_DIR` 不存在或不可写。

拦截时必须向人类输出命中的具体条件与两个规范化路径，等待人类处理后重试，**严禁**为了“先跑起来”而跳过校验。

---

## 3. Step 1：首次安装（Fresh Install）vs 增量更新（Upgrade）自动分流

检查 `TARGET_PROJECT_DIR` 下是否已存在 `.agent-layers/` 目录或 `.agents/skills/al1-decision/` 等 PAL 角色目录：

- **两者均不存在** → 进入 **模式 A：首次安装（Fresh Install）**，见第 4 节；
- **任一已存在** → 进入 **模式 B：增量更新与非破坏性差异比对（Non-Destructive Upgrade & Diff）**，见第 5 节。

> **禁止**：把“半安装”“历史安装过但目录不全”的目标项目直接重置覆盖；半安装项目同样按模式 B 处理（缺失项补齐、差异项保留）。

---

## 4. 模式 A：首次安装规程与空白骨架初始化（Fresh Install）

按以下顺序执行，全部内容均来自 `SOURCE_FRAMEWORK_DIR`：

### 4.1 根目录 `AGENTS.md` 保护性安装

- 若目标项目**不存在** `AGENTS.md`：直接从源复制 `AGENTS.md` 到目标项目根目录。
- 若目标项目**已存在自定义** `AGENTS.md`：**默认保留目标文件**，向人类展示「目标现有条目不丢失」的合并差异建议；**仅当人类明确同意合并或覆盖后**才写入。

### 4.2 安装通用 Skills 与模板库

- 复制 `.agents/skills/{al1-decision,al2a-drafter,al2b-reviewer,al3-worker}/SKILL.md`（共 4 个文件）。
- 复制 `.agent-layers/_templates/` 下的 6 个标准模板文件（`L2-dispatch/mandate.md`、`L2-dispatch/briefing.md`、`L2-internal/draft-plan.md`、`L2-internal/review-notes.md`、`L3-execution/spec.md`、`L3-execution/worker-report.md`）。
- 创建空目录：`.agent-layers/L2-dispatch/`、`.agent-layers/L2-internal/`、`.agent-layers/L3-execution/`、`.agent-layers/archive/intent-history/`。

### 4.3 初始化 `.agent-layers/model-layers.md`

- 目标**不存在**该文件：从源复制通用示例版 `model-layers.md`，并提醒人类按自己实际可用的模型池替换型号（本文件是模型-层级映射的唯一权威配置）。
- 目标**已存在**该文件：无条件保留，不覆盖。

### 4.4 初始化 `.agent-layers/L1-decision/` 五份受控文档

**严禁复制源仓库的真实历史、真实决策流水或在途任务包**，只允许安装占位模板：

1. `01-charter-and-specs.md`：从源 `framework/.agent-layers/L1-decision/01-charter-and-specs.md` 复制**待初始化业务章程模板**（顶部含 `Charter-Status: UNINITIALIZED`、`Framework-Version`、`Project-Name: <PROJECT_NAME>`）。
2. 其余 4 份文件若目标不存在，按下方内联空白骨架直接生成（仅含权限/读取规则与空表头，不带任何源仓库历史记录）。

**内联空白骨架 `00-intent-log.md`**：

```markdown
# L1 人类指令与决策流水账 (`00-intent-log.md`)

> **文档属性与权限约束**：
> - **层级归属**：`L1-decision`（人类用户 ↔ L1 决策层共享）
> - **读写权限**：人类用户（追加/审阅）、`L1 决策层`（**仅追加 Append-Only**；满阈值时执行折叠归档）、`L2a / L2b / L3`（🚫 **严禁访问**）
> - **更新铁律**：只允许在 `## 活跃决策流 (Active Intent Stream)` 末尾追加新条目，严禁篡改或静默删除已有记录。
> - **5 条活跃记录上限（5-Entry Active Cap）**：当完整活跃决策记录超过 **5 条**（即 `≥ 6` 条完整记录）时，保留最新 **5 条**，将更早记录无损移入 `.agent-layers/archive/intent-history/<YYYY-MM-DD>-intent-archive.md`，并在本文件归档索引区保留简短链接。
> - **关联历史从属文件默认不加载**：日常上下文恢复仅读取 `00-intent-log.md`、`01-charter-and-specs.md`、`02-roadmap.md` 三份主文档，默认不读 `01-charter-changelog.md`、`02-roadmap-audit.md` 与历史归档文件。

---

## 活跃决策流 (Active Intent Stream)

<!-- 在此按时间顺序追加：### [YYYY-MM-DD HH:mm] <一句话主题> -->

---

## 历史归档索引 (Archived Intent Index)

- *（暂无归档）*
```

**内联空白骨架 `01-charter-changelog.md`**：

```markdown
# L1 架构演进历史记录 (`01-charter-changelog.md`)

> **文档属性与读取约束**：
> - **层级归属**：`L1-decision`（`01-charter-and-specs.md` 的历史从属文件）
> - **读取策略**：**日常默认不读取（Load-on-Demand Only）**；仅在 `L1` 合并 Delta 追加记录或人类要求追溯历史时按需访问。
> - **读写权限**：人类用户（读写）、`L1 决策层`（**仅追加 Append-Only**）、`L2a / L2b / L3`（🚫 **默认不读 / 严禁访问**）

---

## 3. 架构演进记录 (Changelog)

| 日期 | 版本 | 关联任务 ID | 变更类型 (`ADDED`/`MODIFIED`/`REMOVED`) | 变更内容摘要 | 经办层级 |
| :-: | :-: | :-: | :-: | :--- | :---: |
| `<YYYY-MM-DD>` | `v0.1.0` | `-` | `ADDED` | 初始化 PAL 分层工作流基线 | `L1` |
```

**内联空白骨架 `02-roadmap.md`**：

```markdown
# L1 全局进度与任务排期表 (`02-roadmap.md`)

> **文档属性与权限约束**：
> - **层级归属**：`L1-decision`（全局任务状态面板；状态流转审计明细见同目录独立从属文件 [`02-roadmap-audit.md`](02-roadmap-audit.md)，日常默认不加载）
> - **读写权限**：人类用户（读写）、`L1 决策层`（**读写**）、`L2a / L2b / L3`（🚫 **严禁访问**）
> - **任务五态**：`planned`（待规划） | `todo`（待开始） | `doing`（进行中） | `done`（已完成） | `failed`（已失败）

---

## 1. 项目里程碑 (Current Milestone)

- **当前目标里程碑**：`M1 — <待 L1 规划>`
- **整体进度统计**：已完成 `0` / 总计 `0`

---

## 2. 任务主表 (Task Registry)

| Task ID | 任务标题 | 五态 (`Status`) | 当前所处子阶段 (`Stage`) | 前置依赖 (`Prereqs`) | 关联文档路径 / 归档路径 | 最后更新 |
| :-: | :--- | :-: | :-: | :-: | :--- | :-: |
| `<TASK-ID>` | `<任务标题>` | `planned` | `awaiting_mandate` | `<前置任务或 无>` | `L2-dispatch/<TASK-ID>/mandate.md` | `<YYYY-MM-DD>` |

---

## 3. 状态流转审计简志索引 (State Audit Trail Reference)

- **状态审计明细**：已拆分为同目录独立从属文件 [`02-roadmap-audit.md`](02-roadmap-audit.md)（日常读取主文档时默认不加载；仅在 `L1` 更新任务状态同步追加审计记录或按需追溯时访问）。
```

**内联空白骨架 `02-roadmap-audit.md`**：

```markdown
# L1 路线图状态流转审计简志 (`02-roadmap-audit.md`)

> **文档属性与读取约束**：
> - **层级归属**：`L1-decision`（`02-roadmap.md` 的历史审计从属文件）
> - **读取策略**：**日常默认不读取（Load-on-Demand Only）**；仅在追加状态审计行或人类要求追溯流转轨迹时按需访问。
> - **读写权限**：人类用户（读写）、`L1 决策层`（**仅追加 Append-Only**）、`L2a / L2b / L3`（🚫 **严禁访问**）

---

## 3. 状态流转审计简志 (State Audit Trail — Append-Only)

- `[YYYY-MM-DD HH:mm] [L1]` 创建初始路线图，登记首个规划任务。
```

---

## 5. 模式 B：增量更新与非破坏性差异比对规程（Non-Destructive Upgrade）

### 5.1 绝对保护区（Never Overwrite）

以下内容**始终 100% 保留**，严禁覆盖、重置或删除：

- 目标项目已有的 `.agent-layers/model-layers.md`；
- `.agent-layers/L1-decision/**` 下全部 5 份业务决策与历史文件；
- 全部在途任务包与归档：`.agent-layers/L2-dispatch/`、`L2-internal/`、`L3-execution/`、`archive/`；
- 目标项目业务源码与已有自定义 `AGENTS.md`（未经人类逐条确认不得覆盖）。

### 5.2 通用协议资产逐项比对与默认保留规则

对以下 **11 项核心通用资产**逐一进行内容比对（忽略 CRLF/LF 差异）：

1. `AGENTS.md`
2. `.agents/skills/al1-decision/SKILL.md`
3. `.agents/skills/al2a-drafter/SKILL.md`
4. `.agents/skills/al2b-reviewer/SKILL.md`
5. `.agents/skills/al3-worker/SKILL.md`
6. `.agent-layers/_templates/L2-dispatch/mandate.md`
7. `.agent-layers/_templates/L2-dispatch/briefing.md`
8. `.agent-layers/_templates/L2-internal/draft-plan.md`
9. `.agent-layers/_templates/L2-internal/review-notes.md`
10. `.agent-layers/_templates/L3-execution/spec.md`
11. `.agent-layers/_templates/L3-execution/worker-report.md`

逐项状态判定：

- **`MISSING`（缺失项）**：目标不存在该通用文件 → 直接补齐安装；
- **`IDENTICAL`（一致项）**：内容一致 → 跳过不写；
- **`MODIFIED_OR_DIFFERENT`（差异项）**：**默认保留目标项目现有文件，严禁擅自覆盖！**
- **`EXTRA_CUSTOM`（自定义额外文件）**：目标在 `.agents/skills/` 或 `_templates/` 下新增的自定义 Skill / 模板 → **默认全部保留，严禁删除**。

### 5.3 输出差异汇总表（Diff Summary）与按需覆盖

Agent 必须向人类输出清晰的 `Diff Summary` 表格，列至少包含：相对路径、状态（`IDENTICAL` / `INSTALLED_MISSING` / `KEPT_DIFFERENT` / `KEPT_CUSTOM` / `PROTECTED_STATE`）、核心差异摘要、建议动作。

**覆盖规则**：

- 仅当人类在阅读 `Diff Summary` 后**显式点名**要求覆盖某几个**具体文件路径**时，才对被点名的通用协议/模板文件执行替换；
- 即使人类说“全部更新”，也**绝不覆盖** 5.1 绝对保护区内的 `model-layers.md` 与 `L1-decision/` 业务记录；
- 覆盖前建议先备份原文件（如在目标目录旁生成 `.bak` 文本副本，这不是新脚本）。

---

## 6. 一键复制给 Agent 的声明式安装/升级启动 Prompt

将下面整段提示词复制给具备文件读写权限的通用工程 Agent 即可启动部署：

```text
请读取源框架目录 `<SOURCE_FRAMEWORK_ABSOLUTE_PATH>/DEPLOY.md`，将 Personal Agent Layers (PAL) 安装或非破坏性升级到目标项目 `<TARGET_PROJECT_ABSOLUTE_PATH>`：
1. 先解析并核对源目录与目标目录的真实绝对路径；若同源、目标为公开框架仓本身或路径无效，立即停止并报错。
2. 自动判断首次安装（Fresh Install）或增量更新（Upgrade）：
   - 若已存在 `.agent-layers/` 或 `.agents/skills/al1-decision/`，进入非破坏性差异比对模式：默认保留目标项目所有内容不同的既有文件与自定义额外文件，绝不覆盖已有的 `.agent-layers/model-layers.md` 与 `.agent-layers/L1-decision/**` 业务记录。
   - 请向我输出完整的差异清单（Diff Summary），仅在我明确点名要求覆盖指定文件后才执行替换。
3. 严禁复制源仓库的在途任务或私有历史流水，严禁创建任何 `.ps1/.sh/.py/.js` 脚本。
4. 完成后汇报实际写入/保留的文件清单与验证结果，并提示我开启首次 `/al1-decision` 会话完成目标项目业务章程（`01-charter-and-specs.md`）的初始化对齐。
```

> **部署完成后的人类下一步**：在目标项目开启 `/al1-decision` 会话。若 `01-charter-and-specs.md` 顶部仍为 `Charter-Status: UNINITIALIZED`，`L1` 会先引导你完成业务愿景、技术栈与测试门禁的对齐，再开始派发具体任务。
