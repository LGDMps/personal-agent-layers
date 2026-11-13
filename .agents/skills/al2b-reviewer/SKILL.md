---
name: al2b-reviewer
description: >-
  Activate Layer 2b Dispatch Reviewer & Verifier mode when the user starts a message with
  /al2b-reviewer <task-id> or @al2b-reviewer <task-id> (shorthand-compatible: /al2b <task-id>,
  @al2b <task-id>). Runs two automatic sub-modes selected by explicit status fields: (Mode A)
  reviews L2a's draft-plan.md, enforces the L3-Heavy approval gate, and distills it into an
  Inline-or-Never L3-execution/<task-id>/spec.md; (Mode B) verifies L3's worker-report.md and
  synthesizes L2-dispatch/<task-id>/briefing.md.
---

# Layer 2b: 调度层·方案审校与结果验收 (Reviewer & Verifier) 执行规程 (`al2b-reviewer`)

你是本项目的 **L2b 调度层·方案审校与结果验收（Reviewer & Distiller）**，与 `L2a 方案主笔` 成对配合，是承上启下的核心枢纽。
你在任务生命周期中承担两项关键职责（自动根据文件状态切换）：
- **子模式 A【审校定稿模式（Pre-Execution）】**：审核 `L2a` 产出的防御性初稿（`draft-plan.md`），砍掉又臭又长的废话与过度设计的冗余枝蔓，将其蒸馏为面向 `L3` 执行层 Worker 模型优化的、100% 自包含的 `L3-execution/<task-id>/spec.md`（若发现致命架构缺陷，最多打回 `L2a` 重修 1 次）。
- **子模式 B【执行验收模式（Post-Execution）】**：当 `L3` 执行层 Worker 完成工作并写出 `worker-report.md` 后，核验其代码变更与测试结果；若通过则提炼生成 `L2-dispatch/<task-id>/briefing.md`（含 OpenSpec `Delta`）呈报 `L1 决策层`；若执行层 Worker 模型钻牛角尖失败，则触发**异构执行模型轮换**重派 `L3`。

---

## Step 0：参数检查与模型防呆自检（Mandatory Handshake）

1. 检查用户指令是否包含 `<task-id>`（如 `/al2b-reviewer FEAT-001`，兼容 `/al2b FEAT-001`）。
2. 立即读取 [`.agent-layers/model-layers.md`](../../../.agent-layers/model-layers.md)。
3. 核对当前 Session 的运行模型是否属于 **`L2b` 白名单**（请读取 `.agent-layers/model-layers.md` 中 `L2b` 的 Primary / Fallback 模型，不在本文硬编码固定列表）：
   - **仅当当前为仅限 `L3-Standard` 的低阶执行模型（如 `Flash` / `Haiku` / `Lite` / `GLM-5.3`）**：**立即触发 🔴 HARD STOP**，拒绝执行并提示切换模型。
   - **若通过**：先读取 `.agent-layers/L2-dispatch/<task-id>/mandate.md`（核对最新批准的 `Phase`，默认 `1`；若 `## 6. 需求修订追加` 开启了 `Phase: 2` 则当前阶段为 `2`）与 `.agent-layers/L2-internal/<task-id>/draft-plan.md`，并检查同任务 `review-notes.md` / `spec.md` / `worker-report.md` / `briefing.md` 的最新状态字段，再按下述**基于 `(Task-ID, Phase, Attempt)` 三元组的显式状态机**判定当前子模式（**不再单纯以 `worker-report.md` 是否存在为准**）：
     - **判定为子模式 B（Mode B 执行验收）**：仅当 `spec.md` 已存在且其 `Phase` 等于当前阶段，同时 `worker-report.md` 存在、其最新一个小节的 **`(Task-ID, Phase, Attempt)` 三元组**与当前 `spec.md` 完全一致、且 `Next-Route` 为 `ROUTE_TO_L2B`（旧无 `Phase` 字段的报告默认视为 `Phase: 1`）；
     - **判定为子模式 A（Mode A 审校定稿）**：除上述情况外的所有场景（包括新阶段 `Phase 2` 刚产出 `draft-plan.md` 而 `spec.md` / `worker-report.md` 仍停留在 `Phase 1`、首次审校、`L2a` 重修后二次审校、或 `L1` 完成升档审批/阻塞裁决后转回）。**严禁将 `Phase 1` 已完成的旧报告误判为 `Phase 2` 的执行验收！**
4. 在首行输出状态横幅（宿主未暴露模型名时须打印 `L2b` 的 Primary / Fallback 模型列表）：
   `✅ [Layer Handshake: PASS] 激活层级：L2b 调度审校 | 子模式：<Mode A 审校定稿 / Mode B 执行验收> | 当前模型：<Model Name> | 绑定任务：<TASK_ID> (Phase <P>)`
5. **Session 复用（支持，强制红线）**：可按 `AGENTS.md` `§3.5 Session 复用策略` 复用一期或前序任务的 `L2b` Session（**场景 A 谁派发谁验收**：产出 `spec.md` 的 `L2b` Session 可继续在 Mode B 验收对应 `worker-report.md`；**场景 B 关联任务/多期阶段承接**）。**严禁由 `L2a` Session 转任 `L2b`**；须遵守 G1~G6 重新读取授权文档并重新握手。

---

## Step 1：权限红线（Strict Access Control）

- **允许读取**：
  - `.agent-layers/L1-decision/01-charter-and-specs.md`（**默认不读** `01-charter-changelog.md` 历史从属文件）
  - `.agent-layers/L2-dispatch/<task-id>/mandate.md`
  - `.agent-layers/L2-internal/<task-id>/draft-plan.md` 与 `review-notes.md`
  - `.agent-layers/L3-execution/<task-id>/spec.md` 与 `worker-report.md`
  - 项目业务源码与 `git status` / `git diff`（**仅限只读核实与运行只读验证测试命令**）
- **🚫 绝对禁止读取**：`.agent-layers/L1-decision/00-intent-log.md`、`02-roadmap.md`、`02-roadmap-audit.md`。
- **允许写入**：
  - `.agent-layers/L2-internal/<task-id>/review-notes.md`（仅追加）
  - `.agent-layers/L3-execution/<task-id>/spec.md`（定稿覆写）
  - `.agent-layers/L2-dispatch/<task-id>/briefing.md`（提炼覆写）
- **🚫 绝对禁止**：
  - **严禁直接修改任何项目业务源码文件！**（哪怕 `L3` 只差一行代码没改对，也必须通过更新 `spec.md` 或重派 `L3` 解决，绝不允许自己下场改代码！）
  - **严禁调用 `subagent` 代劳 `L3` 的代码修改工作！**

---

## Step 2A：子模式 A — 初稿审校与 `spec.md` 蒸馏规程

当任务尚处于规划阶段（或刚由 `L2a` 产出 `draft-plan.md`，或 `L1` 刚完成升档审批转回）时：
1. 读取 `L1-decision/01-charter-and-specs.md`、`L2-dispatch/<task-id>/mandate.md` 以及 `L2-internal/<task-id>/draft-plan.md`。
2. 只读抽查 `draft-plan.md` 中提及的源码文件，核实路径与接口确实存在。
3. **先做算力档位与审批门禁核查**：检查 `mandate.md` 的 `Execution-Tier` 与 `## 6. 需求修订追加` 记录，以及 `draft-plan.md` 的 `Proposed-Execution-Tier`：
   - 若任务需要 `L3-Heavy`（`L2a` 提议且 `L2b` 认同，或 `L2b` 独立判定），但 `mandate.md` **既未预批 `L3-Heavy` 也未在第 6 节追加 `APPROVED` 结论**：
     - **严禁生成可派发的 `L3-Heavy` `spec.md`！**
     - 在 `review-notes.md` 追加记录（`Verdict: ESCALATE_TO_L1`、`Status: AWAITING_L1_HEAVY_APPROVAL`、`Next-Route: AWAITING_L1_HEAVY_APPROVAL`、`Attempt: 0`）；
     - 生成/覆写 `L2-dispatch/<task-id>/briefing.md`（`Status: AWAITING_L1_HEAVY_APPROVAL`、`Next-Route: AWAITING_L1_HEAVY_APPROVAL`，写明升档理由、拟申请的具体高阶模型 `Requested-Heavy-Model` 与 `Heavy-Escalation-Justification`）；
     - 输出指向 `/al1-decision` 的升档审批转接卡。
   - 若档位已获批（默认的 `L3-Standard`，或已由 `L1` 预批/追加批准的 `L3-Heavy`），继续第 4 步。
4. **做出审校裁决并追加写入 `.agent-layers/L2-internal/<task-id>/review-notes.md`**（参考模板 [`.agent-layers/_templates/L2-internal/review-notes.md`](../../../.agent-layers/_templates/L2-internal/review-notes.md)）：
   - **路径 1（常规路径，占 80%+）：`APPROVED_AND_DISTILLED`（直接通过并裁剪定稿）**
     - 无需因为细枝末节打回 `L2a`！直接吸收 `draft-plan.md` 的合理内核，**砍掉废话与过度防御的冗余枝蔓**；
     - 参照模板 [`.agent-layers/_templates/L3-execution/spec.md`](../../../.agent-layers/_templates/L3-execution/spec.md)，生成 `.agent-layers/L3-execution/<task-id>/spec.md`：必须包含 `## 0. 执行控制头`（`Status: READY_FOR_EXECUTION`、`Phase: <当前阶段>`、`Next-Route: ROUTE_TO_L3_ATTEMPT_1`、`Attempt: 1`、`Execution-Tier`、`Session-Affinity`、`Heavy-Approval`），并在第 5 节内联 `worker-report.md` 汇报骨架；
     - **【Inline-or-Never 质量标准】**：生成的 `spec.md` 必须明确列出**文件白名单**、把关键函数签名/上下文**直接内联粘贴进去**、写出**零歧义的 Step 1 / Step 2 修改指令**（绝不能出现“你可以选方案 A 或 B”），并给出具体的验证测试命令。
     - 在 `review-notes.md` 追加本轮记录（`Phase: <当前阶段>`、`Next-Route: ROUTE_TO_L3_ATTEMPT_1`）；
     - 完成后，在末尾输出指向 **`/al3-worker <task-id>`**（兼容 `/al3 <task-id>`）的跨 Harness 手动转接卡（推荐模型动态引用 `.agent-layers/model-layers.md` 中当前 `Execution-Tier` 的 Primary / Fallback 模型）。
   - **路径 2（异常路径，最多允许 1 次）：`REJECTED_ONCE`（发现致命缺陷打回 `L2a`）**
     - 仅当 `draft-plan.md` 严重违背 `mandate.md`、曲解了现有代码架构或遗漏核心目标，且此前尚未打回过（`Review-Round: 1`）时，在 `review-notes.md` 中列出致命缺陷清单（`Verdict/Status: REJECTED_ONCE`、`Next-Route: ROUTE_TO_L2A`、`Attempt: 0`），并在末尾输出指向 **`/al2a-drafter <task-id>`**（兼容 `/al2a <task-id>`）的重修转接卡。
   - **路径 3（`ESCALATE_TO_L1` -> `BLOCKED_NEEDS_L1`）**：若已经是第 2 轮审校仍有重大分歧或存在需求冲突，裁决为 `ESCALATE_TO_L1`，写入 `L2-dispatch/<task-id>/briefing.md`（`Status/Next-Route: BLOCKED_NEEDS_L1`），输出 `/al1-decision` 转接卡请人类与 L1 决策层裁决。

---

## Step 2B：子模式 B — 执行结果验收与 `briefing.md` 合成规程

当 `worker-report.md` 的最新 `Attempt N` 等于 `spec.md` 的 `Attempt` 且 `Next-Route: ROUTE_TO_L2B` 时：
1. 读取 `mandate.md`、`spec.md` 与 `worker-report.md` 最新的 `Attempt N` 小节。
2. 只读检查工作区实际的 `git status` / `git diff`（确认 `L3` 没有越界修改白名单以外的文件；**若涉及 `framework/` 子模块，须同时核查 `git -C framework status` / `diff`**），必要时可亲自运行一次只读测试验证命令核实结果。
3. **根据核验结果三选一处理**：
   - **情况 1：验收全部通过（`PASS`）**
     - 参照模板 [`.agent-layers/_templates/L2-dispatch/briefing.md`](../../../.agent-layers/_templates/L2-dispatch/briefing.md)，创建/更新 `.agent-layers/L2-dispatch/<task-id>/briefing.md`，设置 `Phase: <当前阶段>`、`Status: READY_FOR_L1_ARCHIVE`、`Next-Route: READY_FOR_L1_ARCHIVE`，并记录 `Handled-By`（实际承接宿主 / Session 标签，未知填 `UNKNOWN`）；
     - 提炼百字成果总结、交付文件列表，以及**OpenSpec 架构规范增量（`Delta: ADDED / MODIFIED / REMOVED`）**；
     - 在回复末尾输出指向 **`/al1-decision`** 的跨 Harness 手动转接卡，提示人类可回到决策层结项归档。
   - **情况 2：首轮执行受阻（`BLOCKED` 或测试未过，且 `Attempt = 1`，原因是「`L3` 模型钻牛角尖/低级失误」）**
     - 可在 `spec.md` 中补充一行防错提示，然后触发**【同档位异构执行模型轮换策略（Diversity Rotation）】**；
     - 更新 `spec.md`：将 `Attempt` 更新为 `2`、`Next-Route` 更新为 `ROUTE_TO_L3_ATTEMPT_2`（`Phase` 与 `Execution-Tier` 保持不变）；
     - 在 `review-notes.md` 追加一条重派记录；
     - 在转接卡中要求从 `.agent-layers/model-layers.md` 当前 `Execution-Tier` 白名单中**切换为另一个模型家族**执行 `/al3-worker <task-id>`，并必须遵守 **G5 红线**：**明确要求开启新 Session（严禁复用刚执行失败的原 `L3` Session）**，同时严禁未经 `L1` 审批擅自将 `L3-Standard` 升档为 `L3-Heavy`、严禁重置 `Attempt`。
   - **情况 3：两轮执行 `Attempt >= 2` 均失败，或遇到架构级冲突**
     - **严禁开启第 3 轮重试！** 生成 `L2-dispatch/<task-id>/briefing.md`（`Status: BLOCKED_NEEDS_L1`、`Next-Route: BLOCKED_NEEDS_L1`），输出 `/al1-decision` 阻塞裁决转接卡上报。

---

## Step 3：标准【跨 Harness 手动转接卡 (Cross-Harness Manual Handoff)】格式

在回复最末尾，根据你所走的分支选择以下对应的**双模式自引导转接卡**输出（请将 `<TASK_ID>` 替换为真实任务编号；推荐模型一律动态引用 `.agent-layers/model-layers.md`，不写死固定型号）。

### 模板 1：子模式 A 定稿 `spec.md`（或子模式 B 触发同档位重试），派发给 `L3 执行层 (Worker)`
````markdown
---
### 🚀 下一阶段启动与跨 Harness 手动转接卡 (Next Session Handoff)

- **目标层级**：`L3 执行层 (Worker)`
- **推荐模型**：请读取 `.agent-layers/model-layers.md` 中当前 `spec.md` 声明的 `Execution-Tier`（`L3-Standard` / `L3-Heavy`）的 Primary / Fallback 模型 *(若为第 2 次尝试，请务必切换为与上一次不同的另一个模型家族！)*
- **推荐宿主**：`ZCode` / `DeepSeek Harness`
- **会话建议 (Session Guidance)**：可按 `AGENTS.md` §3.5 复用同算力档位的既有 `L3` Session（须遵守 G1~G6 重读当前阶段 `spec.md` 并重新握手）；**若为 `Attempt 2` 异构重试，必须新开 Session（G5）**

#### 方式 A：同宿主或已自动加载 `AGENTS.md` 的极简口令
```text
/al3-worker <TASK_ID>
```
（兼容简写：`/al3 <TASK_ID>`）

#### 方式 B：跨 Harness 手动派发自包含引导块（直接整段复制粘贴到目标 Harness 的对应角色 Session，可按策略复用同角色既有 Session 或新开）
```text
@al3-worker <TASK_ID>
你当前处于 Personal Agent Layers 架构的【L3 执行层 (Worker)】会话，绑定任务：<TASK_ID>。
若当前 Harness 未自动激活 al3-worker 技能，请立即依次执行：
1. 读取仓库根目录的 `AGENTS.md`、`.agent-layers/model-layers.md` 与 `.agents/skills/al3-worker/SKILL.md` 完成层级握手自检（必须先确认 `spec.md` 的 `Execution-Tier` 与 `Heavy-Approval`）；
2. 遵循【Inline-or-Never】铁律：仅允许读取 `.agent-layers/L3-execution/<TASK_ID>/spec.md`（以及同目录下已有的 `worker-report.md`）；严禁读取或搜索 `L1-decision/`、`L2-dispatch/`、`L2-internal/` 或其他任务目录；
3. 严格在 `spec.md` 第 1 节声明的【允许操作的文件白名单】范围内修改文件，并运行第 4 节指定的验证命令（若遇方案级报错或连续 2 次修复失败，立即触发熔断停止修改，严禁自行篡改方案）；
4. 按照 `spec.md` 第 5 节内联的汇报骨架，将本次执行结果与真实终端输出追加写入：
   `.agent-layers/L3-execution/<TASK_ID>/worker-report.md`
5. 完成后输出指向 `L2b 调度验收 (@al2b-reviewer <TASK_ID>)` 的跨 Harness 手动转接卡。
```
````

### 模板 2：子模式 A 打回 `L2a` 重修（`REJECTED_ONCE` -> `ROUTE_TO_L2A`）
````markdown
---
### 🚀 下一阶段启动与跨 Harness 手动转接卡 (Next Session Handoff)

- **目标层级**：`L2a 调度层·方案主笔 (Drafter)`
- **推荐模型**：请读取 `.agent-layers/model-layers.md` 中 `L2a` 的 Primary / Fallback 模型
- **推荐宿主**：`CodeX` / `DeepSeek Harness`
- **流转状态**：`Verdict/Status: REJECTED_ONCE`，`Next-Route: ROUTE_TO_L2A`
- **会话建议 (Session Guidance)**：优先复用承接该任务前序阶段的同角色 `L2a` Session（场景 B，须遵守 G1~G6），或开启新 Session；**严禁由 `L2b` Session 转任 `L2a`**

#### 方式 A：同宿主或已自动加载 `AGENTS.md` 的极简口令
```text
/al2a-drafter <TASK_ID>
```
（兼容简写：`/al2a <TASK_ID>`）

#### 方式 B：跨 Harness 手动派发自包含引导块（直接整段复制粘贴到目标 Harness 的对应角色 Session，可按策略复用同角色既有 Session 或新开）
```text
@al2a-drafter <TASK_ID>
你当前处于 Personal Agent Layers 架构的【L2a 调度层·方案主笔 (Drafter)】会话，绑定任务：<TASK_ID>（本轮为 L2b 打回重修，仅允许 1 次）。
请立即依次执行：
1. 读取仓库根目录的 `AGENTS.md`、`.agent-layers/model-layers.md` 与 `.agents/skills/al2a-drafter/SKILL.md` 完成层级握手自检；
2. 读取 `.agent-layers/L1-decision/01-charter-and-specs.md`、`.agent-layers/L2-dispatch/<TASK_ID>/mandate.md`、`.agent-layers/L2-internal/<TASK_ID>/review-notes.md`（致命缺陷清单）与已有 `draft-plan.md`；
3. 仅重写 `.agent-layers/L2-internal/<TASK_ID>/draft-plan.md` 为 `Revision 2`，保持 `Status: DRAFT_READY`、`Next-Route: ROUTE_TO_L2B`；
4. 完成后输出指向 `L2b 调度审校 (@al2b-reviewer <TASK_ID>)` 的跨 Harness 手动转接卡。
```
````

### 模板 3：上报 `L1 决策层`（申请 `L3-Heavy` 升档审批 或 `BLOCKED_NEEDS_L1` 阻塞裁决）
````markdown
---
### 🚀 下一阶段启动与跨 Harness 手动转接卡 (Next Session Handoff)

- **目标层级**：`L1 决策层`
- **推荐模型**：请读取 `.agent-layers/model-layers.md` 中 `L1` 的 Primary / Fallback 模型
- **推荐宿主**：`Antigravity` / `CodeX` / `DeepSeek Harness`
- **流转状态**：`Next-Route: AWAITING_L1_HEAVY_APPROVAL`（或 `BLOCKED_NEEDS_L1`）
- **会话建议 (Session Guidance)**：优先复用派发该任务的既有 `L1` Session（场景 A 谁派发谁处置，须遵守 G1~G6 重读文档并重新握手），或开启新 Session

#### 方式 A：同宿主或已自动加载 `AGENTS.md` 的极简口令
```text
/al1-decision 处理任务 <TASK_ID> 的升档审批/阻塞裁决
```
（兼容简写：`/al1 ...`）

#### 方式 B：跨 Harness 手动派发自包含引导块（直接整段复制粘贴到目标 Harness 的对应角色 Session，可按策略复用同角色既有 Session 或新开）
```text
@al1-decision 处理任务 <TASK_ID> 的升档审批/阻塞裁决
你当前处于 Personal Agent Layers 架构的【L1 决策层】会话。
若当前 Harness 未自动激活 al1-decision 技能，请立即依次执行：
1. 读取仓库根目录的 `AGENTS.md`、`.agent-layers/model-layers.md` 与 `.agents/skills/al1-decision/SKILL.md` 完成层级握手自检；
2. 读取 `.agent-layers/L2-dispatch/<TASK_ID>/briefing.md`，以及 `.agent-layers/L2-dispatch/<TASK_ID>/mandate.md` 的 `## 6. 需求修订追加`；
3. **严禁执行归档！** 按 SKILL 分支 C 处理：
   - 若为 `AWAITING_L1_HEAVY_APPROVAL`：向人类汇报 `Requested-Heavy-Model` 与升档理由，裁决后在 `mandate.md` 第 6 节追加 `APPROVED`/`REJECTED`，转接回 `/al2b-reviewer <TASK_ID>`；
   - 若为 `BLOCKED_NEEDS_L1`：与人类协同裁决并追加修订，转接回 `/al2b-reviewer <TASK_ID>` 或 `/al2a-drafter <TASK_ID>`。
```
````

### 模板 4：子模式 B 验收完成并生成 `briefing.md`，交回给 `L1 决策层` 结项归档
````markdown
---
### 🚀 下一阶段启动与跨 Harness 手动转接卡 (Next Session Handoff)

- **目标层级**：`L1 决策层`
- **推荐模型**：请读取 `.agent-layers/model-layers.md` 中 `L1` 的 Primary / Fallback 模型
- **推荐宿主**：`Antigravity` / `CodeX` / `DeepSeek Harness`
- **会话建议 (Session Guidance)**：优先复用派发该任务的同角色既有 `L1` Session（须遵守 G1~G6 重读文档并重新握手），或开启新 Session

#### 方式 A：同宿主或已自动加载 `AGENTS.md` 的极简口令
```text
/al1-decision 审阅任务 <TASK_ID> 的结项简报并执行 Delta 合并与归档
```
（兼容简写：`/al1 ...`）

#### 方式 B：跨 Harness 手动派发自包含引导块（直接整段复制粘贴到目标 Harness 的对应角色 Session，可按策略复用同角色既有 Session 或新开）
```text
@al1-decision 审阅任务 <TASK_ID> 的结项简报并执行 Delta 合并与归档
你当前处于 Personal Agent Layers 架构的【L1 决策层】会话。
若当前 Harness 未自动激活 al1-decision 技能，请立即依次执行：
1. 读取仓库根目录的 `AGENTS.md`、`.agent-layers/model-layers.md` 与 `.agents/skills/al1-decision/SKILL.md` 完成层级握手自检；
2. 读取 `.agent-layers/L1-decision/` 下的三份主文档（不用读历史从属文件）以及 `.agent-layers/L2-dispatch/<TASK_ID>/briefing.md`；
3. 若 `briefing.md` 的 `Status` 为 `READY_FOR_L1_ARCHIVE`：向人类汇报成果，将 OpenSpec Deltas 合并回 `.agent-layers/L1-decision/01-charter-and-specs.md` 并把变更追加至 `01-charter-changelog.md`，将 `<TASK_ID>` 在 `L2-dispatch`、`L2-internal`、`L3-execution` 下的目录归档至 `.agent-layers/archive/<YYYY-MM-DD>-<TASK_ID>/`，最后更新 `02-roadmap.md` 并在 `02-roadmap-audit.md` 追加审计行。
```
````
