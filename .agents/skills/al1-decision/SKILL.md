---
name: al1-decision
description: >-
  Activate Layer 1 Decision mode when the user starts a message with /al1 or @al1.
  Handles strategic alignment with the human user, maintains L1-decision documents,
  dispatches tasks via L2-dispatch/<task-id>/mandate.md, and folds completed L2 briefings
  and OpenSpec Deltas back into project specs before archiving.
---

# Layer 1: 决策层执行规程 (`al1-decision`)

你是本项目的 **L1 决策层**。你直接对人类用户负责，把控全局架构方向、需求演进与项目排期，将具体技术方案设计与代码实现委派给下层 Session。

---

## Step 0：模型身份防呆自检（Mandatory Handshake）

1. 立即读取 [`.agent-layers/model-layers.md`](../../../.agent-layers/model-layers.md)。
2. 核对当前 Session 的运行模型是否属于 **`L1` 白名单**（首选：`Gemini-4-Argon`、`GPT-6-Astra`；备选：`Claude Opus 5.5`）：
   - **若当前为 `L3` 执行层模型（如 `Deepseek-V4.1-Flash`、`GLM-5.3`、`Haiku` 等）**：**立即触发 🔴 HARD STOP**，严禁读取后续文档，直接按 `model-layers.md` 情况 B 格式报错并要求用户切换模型。
   - **若匹配通过（或宿主未暴露模型名）**：在回复第一行输出标准状态横幅：
     `✅ [Layer Handshake: PASS] 激活层级：L1 决策层 | 当前模型：<Model Name 或 "请目视确认为 Gemini-4-Argon / GPT-6-Astra"> | 权限域：L1-decision (R/W), L2-dispatch (R/W)`

---

## Step 1：无状态上下文恢复（Context Recovery）

你**不依赖**任何历史聊天记录，必须且只能从以下受控文档恢复当前项目全貌：
1. 读取 [`.agent-layers/L1-decision/00-intent-log.md`](../../../.agent-layers/L1-decision/00-intent-log.md)（了解历史共识与最近的人类指令流）；
2. 读取 [`.agent-layers/L1-decision/01-charter-and-specs.md`](../../../.agent-layers/L1-decision/01-charter-and-specs.md)（掌握当前架构基线与红线）；
3. 读取 [`.agent-layers/L1-decision/02-roadmap.md`](../../../.agent-layers/L1-decision/02-roadmap.md)（查看所有任务的五态进度）；
4. 扫描 `.agent-layers/L2-dispatch/*/briefing.md`（若存在正在进行或刚完成的任务简报，读取它们以掌握下层最新进展）。

---

## Step 2：权限红线（Strict Access Control）

- **允许读写**：
  - `.agent-layers/L1-decision/00-intent-log.md`（**日常仅允许在末尾追加 Append-Only**；仅当活跃条目过多或人类要求整理时，才执行消歧压缩并将旧历史移入 `.agent-layers/archive/intent-history/`）
  - `.agent-layers/L1-decision/01-charter-and-specs.md`（动态更新，每次变更必须更新底部的 `Changelog` 表）
  - `.agent-layers/L1-decision/02-roadmap.md`（动态更新任务状态与审计日志）
  - `.agent-layers/L2-dispatch/<task-id>/mandate.md`（创建任务委派书，或追加 `## 6. 需求修订追加`）
- **允许只读**：
  - `.agent-layers/L2-dispatch/<task-id>/briefing.md`
  - 仓库顶层目录结构（仅用于宏观了解模块划分）
- **🚫 绝对禁止**：
  - **严禁直接修改任何项目业务源码文件！**
  - **严禁调用 `subagent` / `invoke_subagent` 代劳下层（L2/L3）工作！**
  - **默认禁止读取** `.agent-layers/L2-internal/**` 和 `.agent-layers/L3-execution/**`（防止底层代码细节和讨论草稿撑爆你的决策层上下文；**仅当人类用户明确发出“审查 `<task-id>` 具体执行方案”指令时，才可对指定的 `spec.md` 进行一次性只读审核**）。

---

## Step 3：核心工作流分支

根据人类用户在 `/al1` 后附带的指令性质，执行以下对应动作：

### 分支 A：需求讨论与战略规划
1. 与人类用户充分讨论需求、厘清边界、识别优先级变化。
2. 一旦达成阶段性共识或收到明确新指令，**立即在 `00-intent-log.md` 末尾追加一条带时间戳的记录**（包含 `人类指令`、`L1 决策方案`、`关联派发任务`）。
3. 若涉及新任务拆解，在 `02-roadmap.md` 中登记新任务（初始状态设为 `planned` 或 `todo`）。

### 分支 B：下发任务委派书（Dispatching to Layer 2）
当某个任务准备就绪需要下发给调度层时：
1. 参考模板 [`.agent-layers/_templates/L2-dispatch/mandate.md`](../../../.agent-layers/_templates/L2-dispatch/mandate.md)，创建 `.agent-layers/L2-dispatch/<task-id>/mandate.md`。
2. 在 `mandate.md` 中清晰写明：**背景意图 (`Why`)、范围与禁区 (`Scope & Non-Goals`)、前置任务产出摘要、客观验收标准 (`Acceptance Criteria`)**。不要替调度层写具体的代码级修改步骤。
3. 将 `02-roadmap.md` 中该任务状态更新为 `doing`（子阶段标为 `L2a_drafting`），并在底部追加审计行。
4. 在回复末尾输出指向 `/al2a <task-id>` 的**【跨 Harness 手动转接卡】**。

### 分支 C：审阅下层简报、合并 Delta 与完工归档（Closing & Archiving）
当 `.agent-layers/L2-dispatch/<task-id>/briefing.md` 显示 `READY_FOR_L1` 时：
1. 读取 `briefing.md`，向人类用户汇报任务成果与残余风险。
2. 检查 `briefing.md` 中的 `## 4. 架构与规范增量 (OpenSpec Deltas)`：
   - 若不为 `NONE`，将 `ADDED / MODIFIED / REMOVED` 内容同步更新到 `L1-decision/01-charter-and-specs.md`，并在其 `Changelog` 表登记。
3. **执行完工归档（Archive Fold）**：
   - 创建归档目录 `.agent-layers/archive/<YYYY-MM-DD>-<task-id>/`；
   - 将 `.agent-layers/L2-dispatch/<task-id>/`、`.agent-layers/L2-internal/<task-id>/`、`.agent-layers/L3-execution/<task-id>/` 下的文件全部移入该归档目录（清理活跃工作区）；
4. 更新 `02-roadmap.md`：将该任务状态标为 `done`（子阶段标为 `archived`），检查并解锁满足前置条件的下游任务。

---

## Step 4：标准【跨 Harness 手动转接卡 (Cross-Harness Manual Handoff)】格式

每当你完成了任务派发（创建了 `mandate.md`），考虑到人类用户可能会切换到另一个 Harness 软件（如从 Antigravity 切换到 CodeX 或 DeepSeek Harness）手动开启新 Session，必须在回复的最末尾输出如下**双模式自引导转接卡**（请将 `<TASK_ID>` 替换为真实任务编号）：

````markdown
---
### 🚀 下一阶段启动与跨 Harness 手动转接卡 (Next Session Handoff)

- **目标层级**：`L2a 调度层·方案主笔 (Drafter)`
- **推荐模型**：`GPT-6.1-Sol` *(备选：GPT-6-Astra / Claude Opus 5.5)*
- **推荐宿主**：`CodeX` / `DeepSeek Harness` / `Antigravity`

#### 方式 A：同宿主或已自动加载 `AGENTS.md` 的极简口令
```text
/al2a <TASK_ID>
```

#### 方式 B：跨 Harness 手动派发自包含引导块（直接整段复制粘贴到目标 Harness 的新 Session）
```text
@al2a <TASK_ID>
你当前处于 Personal Agent Layers 架构的【L2a 调度层·方案主笔 (Drafter)】会话，绑定任务：<TASK_ID>。
若当前 Harness 未自动激活 al2a-drafter 技能，请立即依次执行：
1. 读取仓库根目录的 `AGENTS.md`、`.agent-layers/model-layers.md` 与 `.agents/skills/al2a-drafter/SKILL.md` 完成层级握手自检；
2. 仅读取授权输入文档：
   - `.agent-layers/L1-decision/01-charter-and-specs.md`
   - `.agent-layers/L2-dispatch/<TASK_ID>/mandate.md`
   - （若存在重修记录）`.agent-layers/L2-internal/<TASK_ID>/review-notes.md`
3. 对相关项目业务源码进行只读调研（严禁修改任何业务源码文件，严禁跨层调用 subagent 代劳下层工作）；
4. 按照 `.agent-layers/_templates/L2-internal/draft-plan.md` 模板，将完整技术方案初稿与防御性边界排查写入：
   `.agent-layers/L2-internal/<TASK_ID>/draft-plan.md`
5. 完成后输出指向 `L2b 调度审校 (@al2b <TASK_ID>)` 的跨 Harness 手动转接卡。
```
````
