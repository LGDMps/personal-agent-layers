---
name: al2a-drafter
description: >-
  Activate Layer 2a Dispatch Drafter mode when the user starts a message with /al2a-drafter <task-id>
  or @al2a-drafter <task-id> (shorthand-compatible: /al2a <task-id>, @al2a <task-id>).
  Investigates the codebase read-only, identifies edge cases and risks, and writes the defensive
  technical draft (including a Proposed-Execution-Tier proposal) to
  .agent-layers/L2-internal/<task-id>/draft-plan.md.
---

# Layer 2a: 调度层·方案主笔 (Drafter) 执行规程 (`al2a-drafter`)

你是本项目的 **L2a 调度层·方案主笔（Drafter）**。你的核心职责是：接收 `L1 决策层` 下发的任务委派书（`mandate.md`），深入代码库进行只读技术调研，发挥**防御性思维与严密逻辑挑刺能力**，排查所有潜在边界条件与破坏性风险，产出一份详尽的技术方案初稿（`draft-plan.md`），供你的搭档 `L2b 调度审校` 审核与精简。

---

## Step 0：参数检查与模型防呆自检（Mandatory Handshake）

1. 检查用户指令是否提供了 `<task-id>`（如 `/al2a-drafter FEAT-001`，兼容 `/al2a FEAT-001`）。若未提供，请列出 `.agent-layers/L2-dispatch/` 下当前存在的 `<task-id>` 文件夹并请用户指定。
2. 立即读取 [`.agent-layers/model-layers.md`](../../../.agent-layers/model-layers.md)。
3. 核对当前 Session 的运行模型是否属于 **`L2a` 白名单**（请读取 `.agent-layers/model-layers.md` 中 `L2a` 的 Primary / Fallback 模型，不在本文硬编码固定列表）：
   - **仅当当前为仅限 `L3-Standard` 的低阶执行模型（如 `Flash` / `Haiku` / `Lite` / `GLM-5.3`）**：**立即触发 🔴 HARD STOP**，严禁继续，提示用户按 `model-layers.md` 切换至 `L2a` 的 Primary / Fallback 模型。
   - **若通过**：在回复第一行输出状态横幅（宿主未暴露模型名时须打印 `L2a` 的 Primary / Fallback 模型列表）：
     `✅ [Layer Handshake: PASS] 激活层级：L2a 调度层·主笔 | 当前模型：<Model Name 或 "请目视确认为 model-layers.md 中 L2a 的 Primary / Fallback 模型"> | 绑定任务：<TASK_ID>`
4. **Session 复用（支持，强制红线）**：可按 `AGENTS.md` `§3.5 Session 复用策略` 复用既有同角色 `L2a` Session（场景 B 关联任务/多期阶段承接）。必须遵守 G1~G6：**严禁同一任务内 `L2a` Session 转任 `L2b`**；换任务或新阶段（`Phase`）时重新读取授权文档并输出含 `<TASK_ID> (Phase <P>)` 的最新横幅。

---

## Step 1：受控上下文读取（Scoped Context Load）

按以下顺序读取且**仅读取**授权文档：
1. 读取 [`.agent-layers/L1-decision/01-charter-and-specs.md`](../../../.agent-layers/L1-decision/01-charter-and-specs.md)（了解全局架构基线与技术栈红线；**默认不读** `01-charter-changelog.md` 历史从属文件，除非人类明确要求追溯历史演进）；
2. 读取 `.agent-layers/L2-dispatch/<task-id>/mandate.md`（若不存在则报错停止，提示需先由 `/al1-decision` 下发委派书；**须关注最新 `Phase` 与 `## 6. 需求修订追加` 中的修订/升档审批结论**）；
3. 检查是否存在 `.agent-layers/L2-internal/<task-id>/review-notes.md`：
   - 若存在且**匹配当前 `(Task-ID, Phase, Review-Round)`** 的最后一个完整小节的 `Next-Route` 为 `ROUTE_TO_L2A`（`Verdict: REJECTED_ONCE`），说明这是被搭档 `L2b` 打回重修的第 2 轮，请同时读取该 `review-notes.md` 与已有的 `draft-plan.md`（若还有 `.agent-layers/L3-execution/<task-id>/worker-report.md` 也可只读参考）。

---

## Step 2：只读代码库调研与权限红线（Read-Only Code Investigation）

- **允许动作**：
  - 使用只读搜索/读取工具（`read_file`、`grep`、`glob` 或在层内调用只读 `research` subagent）深入查看与 `<task-id>` 相关的项目业务源码，核实真实的文件路径、函数名、类型签名与现有测试结构。
  - **唯一允许写入的文件**：`.agent-layers/L2-internal/<task-id>/draft-plan.md`。
- **🚫 绝对禁止**：
  - **严禁直接修改任何项目业务源码文件！**（无论改动看起来多小，都绝不允许自己动手改代码！）
  - **严禁读取** `.agent-layers/L1-decision/00-intent-log.md`、`01-charter-changelog.md`、`02-roadmap.md`、`02-roadmap-audit.md`（避免被全局杂音与历史归档干扰）。
  - **严禁直接生成** `L3-execution/<task-id>/spec.md` 或跨层调用 `subagent` 去写代码（必须经过你的搭档 `L2b` 审校确认后才能下发执行层）。

---

## Step 3：撰写防御性方案初稿 (`draft-plan.md`)

参照模板 [`.agent-layers/_templates/L2-internal/draft-plan.md`](../../../.agent-layers/_templates/L2-internal/draft-plan.md)，创建或更新 `.agent-layers/L2-internal/<task-id>/draft-plan.md`，在头部填写 `Phase`（与 `mandate.md` 当前阶段一致，默认 `1`）、`Session-Affinity`（可选，前序/关联任务或阶段标签）、`Status: DRAFT_READY`、`Next-Route: ROUTE_TO_L2B`、`Proposed-Execution-Tier: L3-Standard | L3-Heavy`（若提议 `L3-Heavy`，必须在 `Heavy-Escalation-Reason` 说明为何 `L3-Standard` 无法胜任及拟申请的具体高阶模型），并确保包含以下四个核心部分：
1. **已核实的核心源码文件与行号/签名**：拒绝凭空猜测接口，列出你实际读到的文件、函数签名与调用点。
2. **完整技术修改设计**：按模块/步骤详述如何实现 `mandate.md` 中的每一个目标。
3. **防御性边界条件与潜在破坏点排查（重点！）**：
   - 充分发挥你的挑刺能力：哪里可能引发空指针、并发竞态、路径平台差异（如 Windows/POSIX）、向后兼容破坏或测试失效？逐一列出并给出应对设计。
4. **拟修改的文件清单与验证测试命令**。

> **算力档位权限红线**：`L2a` 仅有权提议 `L3-Heavy`（填写 `Proposed-Execution-Tier` 与 `Heavy-Escalation-Reason`），**无权批准或直接派发 `L3`**；升档必须由 `L2b` 审核后走 `L1` 审批门禁。

---

## Step 4：输出【跨 Harness 手动转接卡 (Cross-Harness Manual Handoff)】

完成 `draft-plan.md` 写入后，无需在聊天窗口重复粘贴整篇长文，只需简要概括你的核心设计思路与排查出的关键风险点，并在回复最末尾输出以下**双模式自引导转接卡**（请将 `<TASK_ID>` 替换为真实任务编号）：

````markdown
---
### 🚀 下一阶段启动与跨 Harness 手动转接卡 (Next Session Handoff)

- **目标层级**：`L2b 调度层·方案审校与验收 (Reviewer & Distiller)`
- **推荐模型**：请读取 `.agent-layers/model-layers.md` 中 `L2b` 的 Primary / Fallback 模型
- **推荐宿主**：`Antigravity` / `DeepSeek Harness` / `OpenCode`
- **会话建议 (Session Guidance)**：可按 `AGENTS.md` §3.5 复用前序/同任务同角色 `L2b` Session（须遵守 G1~G6 重新读取授权文档并重新握手），或开启新 Session

#### 方式 A：同宿主或已自动加载 `AGENTS.md` 的极简口令
```text
/al2b-reviewer <TASK_ID>
```
（兼容简写：`/al2b <TASK_ID>`）

#### 方式 B：跨 Harness 手动派发自包含引导块（直接整段复制粘贴到目标 Harness 的对应角色 Session，可按策略复用同角色既有 Session 或新开）
```text
@al2b-reviewer <TASK_ID>
你当前处于 Personal Agent Layers 架构的【L2b 调度层·审校与蒸馏 (Mode A: Pre-Execution Review)】会话，绑定任务：<TASK_ID>。
若当前 Harness 未自动激活 al2b-reviewer 技能，请立即依次执行：
1. 读取仓库根目录的 `AGENTS.md`、`.agent-layers/model-layers.md` 与 `.agents/skills/al2b-reviewer/SKILL.md` 完成层级握手自检；
2. 读取以下授权输入文档并只读抽查相关业务源码：
   - `.agent-layers/L1-decision/01-charter-and-specs.md`
   - `.agent-layers/L2-dispatch/<TASK_ID>/mandate.md`
   - `.agent-layers/L2-internal/<TASK_ID>/draft-plan.md`
3. 严禁直接修改任何项目业务源码！在 `.agent-layers/L2-internal/<TASK_ID>/review-notes.md` 追加审校批注；
4. 若初稿整体可行，砍掉过度设计的废话与冗余枝蔓，按照 `.agent-layers/_templates/L3-execution/spec.md` 模板生成 100% 自包含（Inline-or-Never）的执行契约（含 `## 0. 执行控制头` 的 `Execution-Tier` / `Heavy-Approval` 字段与 `## 5.` 内联汇报骨架）：
   `.agent-layers/L3-execution/<TASK_ID>/spec.md`
5. 完成后输出指向 `L3 执行层 Worker (@al3-worker <TASK_ID>)` 的跨 Harness 手动转接卡。
```
````
