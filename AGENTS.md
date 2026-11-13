# AGENTS.md — 项目分层智能体（Agent Layers）宪章与强制门禁协议

> **最高优先级指令（SYSTEM MANDATE）**：
> 本仓库启用了 **Personal Agent Layers（三层模型服务 + 四区文档隔离体系）**。
> **任何 Session 的唯一权威信息来源仅为 `.agent-layers/` 目录下的受控文档**。严禁跨 Session 假设上下文，严禁超越当前激活层级的权限边界读写文件，严禁使用 `subagent` / `invoke_subagent` 进行跨层级任务委派。

---

## 1. 会话初始门禁与角色激活协议（Role Handshake Protocol）

当一个新的会话（Session）启动时，默认处于**【未定级挂起态（Uninitialized）】**。在执行任何实质性文件探索、代码修改或方案设计前，必须根据人类用户的首条指令完成**角色定级与模型防呆自检**：

> **两种启动方式均受本协议约束**：① **新建 Session 初始激活**（首条消息即带 `/al*-*` 或 `@al*` 口令）；② **既有同角色 Session 复用承接**——按 `## 3.5 Session 复用策略` 重新绑定新 `<task-id>` 或新阶段（`Phase`），并**重新执行 Step 0 握手与上下文恢复**（G1~G6 红线详见 §3.5）。

### 1.1 角色激活口令路由表（首选完整 Skill 口令 /al*-*，兼容简写 /al* 与 @al*，大小写不敏感）

| 激活口令 | 绑定的模型层级与角色 | 必须立即读取并遵循的 Skill 规程 | 允许访问的 `.agent-layers/` 权限域 |
| :--- | :--- | :--- | :--- |
| **`/al1-decision`** `[需求/指令]`<br>*(兼容简写：`/al1`、`@al1-decision`、`@al1`)* | **L1 决策层 (Decision Layer)**<br>战略对齐、全局架构维护、任务分派、Delta 合并与归档 | [`.agents/skills/al1-decision/SKILL.md`](.agents/skills/al1-decision/SKILL.md) | - `L1-decision/**` (`读写 / 追加`)<br>- `L2-dispatch/*/mandate.md` (`读写`)<br>- `L2-dispatch/*/briefing.md` (`只读`)<br>- `L1-decision/01-charter-changelog.md` & `02-roadmap-audit.md` (`默认不读，仅变更时追加或按需追溯`)<br>- `archive/**` (`只读`) |
| **`/al2a-drafter <task-id>`**<br>*(兼容简写：`/al2a <task-id>`、`@al2a-drafter <task-id>`、`@al2a <task-id>`)* | **L2a 调度层·方案主笔 (Drafter)**<br>代码库深入调研、边界条件分析与风险排查（挑刺）、撰写防御性技术初稿 | [`.agents/skills/al2a-drafter/SKILL.md`](.agents/skills/al2a-drafter/SKILL.md) | - `L1-decision/01-charter-and-specs.md` (`只读`)<br>- `L2-dispatch/<task-id>/**` (`只读`)<br>- `L2-internal/<task-id>/draft-plan.md` (`读写`)<br>- `L2-internal/<task-id>/review-notes.md` (`只读`)<br>- `L3-execution/<task-id>/**` (`只读`) |
| **`/al2b-reviewer <task-id>`**<br>*(兼容简写：`/al2b <task-id>`、`@al2b-reviewer <task-id>`、`@al2b <task-id>`)* | **L2b 调度层·审校与验收 (Reviewer)**<br>初稿审校、裁剪冗余枝蔓、定稿自包含 `spec.md`、执行验收与提炼简报 | [`.agents/skills/al2b-reviewer/SKILL.md`](.agents/skills/al2b-reviewer/SKILL.md) | - `L1-decision/01-charter-and-specs.md` (`只读`)<br>- `L2-dispatch/<task-id>/mandate.md` (`只读`)<br>- `L2-dispatch/<task-id>/briefing.md` (`读写`)<br>- `L2-internal/<task-id>/draft-plan.md` (`只读`)<br>- `L2-internal/<task-id>/review-notes.md` (`仅追加`)<br>- `L3-execution/<task-id>/spec.md` (`读写`)<br>- `L3-execution/<task-id>/worker-report.md` (`只读`) |
| **`/al3-worker <task-id>`**<br>*(兼容简写：`/al3 <task-id>`、`@al3-worker <task-id>`、`@al3 <task-id>`)* | **L3 执行层 (Worker)**<br>严格按自包含 `spec.md` 编写代码、运行测试验证、输出详细执行汇报 | [`.agents/skills/al3-worker/SKILL.md`](.agents/skills/al3-worker/SKILL.md) | - **仅限** `L3-execution/<task-id>/spec.md` (`内联只读`)<br>- **仅限** `L3-execution/<task-id>/worker-report.md` (`仅追加`)<br>- 仅当任务为经 `L1` 明确授权的框架文档维护任务且在 `spec.md` 白名单中逐一列出时，允许按限定例外操作指定框架文档 |

> **未带口令时的默认行为**：
> 若人类用户在新建 Session 的首条消息中**未包含**上述任何口令（`/al1-decision`、`/al2a-drafter`、`/al2b-reviewer`、`/al3-worker` 及其简写 `/al1`、`/al2a`、`/al2b`、`/al3` 或 `@al*`），请**不要**自行猜测角色或开始翻阅代码库，而是简短回复：
> `⏸️ 当前会话尚未绑定 Agent Layer。请指定本会话层级：/al1-decision (L1 决策层) | /al2a-drafter <task-id> (L2a 调度主笔) | /al2b-reviewer <task-id> (L2b 调度审校/验收) | /al3-worker <task-id> (L3 执行层 Worker)（均兼容 /al1、/al2a、/al2b、/al3 及 @ 前缀简写）。`

---

## 2. 跨层级模型防呆自检（Step 0 强制动作）

激活任一 `/al*` 角色后，**第一步必须读取 [`.agent-layers/model-layers.md`](.agent-layers/model-layers.md)**，将当前会话所运行的模型与配置表比对：
1. **能力不足硬拦截（Hard Stop）**：若当前运行在仅限 `L3-Standard` 的低阶执行模型（如 `Deepseek-V4.1-Flash`、`GLM-5.3`、`Claude Haiku 5.5` 等），但收到了 `/al1-decision`（`/al1`）、`/al2a-drafter`（`/al2a`）、`/al2b-reviewer`（`/al2b`）指令，或收到了 `/al3-worker <task-id>`（`/al3`）且 `spec.md` 中声明为 `Execution-Tier: L3-Heavy`，**必须立即中止执行**，严禁修改任何项目文档或代码，提示用户按 `.agent-layers/model-layers.md` 切换至对应层级/档位的 Primary/Fallback 高阶模型（除非用户显式回复 `"强制豁免"`）。
2. **算力档位核验与配额保护（Quota Warn & Heavy Tier Check）**：收到 `/al3-worker <task-id>`（`/al3`）时，必须先读取 `.agent-layers/model-layers.md` 与 `.agent-layers/L3-execution/<task-id>/spec.md` 的 `Execution-Tier` 字段：
   - 若 `Execution-Tier: L3-Heavy`（且含有效 `Heavy-Approval` 摘要）：使用 `model-layers.md` 中 `L3-Heavy` 允许的旗舰/高阶模型直接 `🟢 PASS`（不报配额警告）；
   - 若 `Execution-Tier: L3-Standard` 且当前运行在 `L1/L2` 旗舰/调度模型：**必须先暂停修改代码（`🟡 QUOTA WARN`）**，提醒用户当前正在消耗高阶配额，建议切换为 `model-layers.md` 中 `L3-Standard` 的推荐模型（除非用户显式回复 `"继续"`；回复 `"继续"` 仅豁免本轮告警，不将任务升档为 `L3-Heavy`）。
3. **盲盒宿主显式回显**：若当前 Harness 环境未向 System Prompt 注入具体的模型名称，必须在首行状态横幅中打印从 `.agent-layers/model-layers.md` 读取的该层级（或 `L3-Standard` / `L3-Heavy` 档位）**Primary / Fallback 推荐模型列表**供人类目视核对。

---

## 3. 框架底座运行约束与全局铁律（Framework Invariants）

> 本节是 Personal Agent Layers (PAL) **通用框架约束的唯一权威落点**。各业务项目的 `.agent-layers/L1-decision/01-charter-and-specs.md` 不再复制本节条文，而是通过相对链接 `[../../AGENTS.md](../../AGENTS.md)` 引用本节，将正文让位给业务项目自身的愿景与技术架构。

### 3.1 独立层级会话流转与严禁跨层调用 Subagent（Spec-01 核心）
- 跨层级委派（`L1 → L2a → L2b → L3 → L2b → L1`）必须由**独立的层级 Session** 承接（可按 `## 3.5 Session 复用策略` 复用既有同角色 Session，或开启新 Session），**绝对禁止使用 `subagent` / `invoke_subagent` 代劳下一层级的工作**（唯一例外：`L2a` 可在层内派生只读 `research` 子智能体辅助搜索源码）。
- 角色口令以完整 Skill 名称（`/al1-decision`、`/al2a-drafter <task-id>`、`/al2b-reviewer <task-id>`、`/al3-worker <task-id>`）为首选标准口令，兼容 `/al*` 与 `@al*` 简写；所有模型推荐统一由 `.agent-layers/model-layers.md` 动态配置。

### 3.2 业务源码写入隔离与双算力档位审批门禁（Spec-01 核心）
- **`L1`、`L2a`、`L2b` 严禁直接修改任何项目业务源码文件！** 业务源码修改权由 `L3 执行层 (Worker)` 独占，且严格限制在 `L3-execution/<task-id>/spec.md` 的【允许操作的文件白名单】内。
- `L3` 分为 `L3-Standard`（默认常规档）与 `L3-Heavy`（高阶攻坚档）。当 `mandate.md` 未预批 `L3-Heavy` 而 `L2` 判定需升档时，`L2b` **严禁擅自直派 `L3-Heavy`**，必须先输出 `Status/Next-Route: AWAITING_L1_HEAVY_APPROVAL` 的 `briefing.md` 报请 `L1` 在 `mandate.md` 第 6 节持久化批准后，方可内联 `Heavy-Approval` 派发。

### 3.3 四区物理隔离、历史主从分离与 Inline-or-Never（Spec-02 核心 & 例外冻结）
- `.agent-layers/` 严格划分为 `L1-decision/`、`L2-dispatch/<task-id>/`、`L2-internal/<task-id>/`、`L3-execution/<task-id>/` 四区及 `archive/`。
- `L1-decision/` 采用现状主文档（`01-charter-and-specs.md`、`02-roadmap.md`）与历史从属文件（`01-charter-changelog.md`、`02-roadmap-audit.md`）分离结构；各层日常恢复上下文时**默认不读取**历史从属文件；`00-intent-log.md` 实施 **5 条活跃记录上限（`≥ 6` 条完整记录时折叠归档至 `archive/intent-history/`）**。
- **Inline-or-Never**：`L3` 启动后仅读本任务当前阶段的 `spec.md`（及同目录 `worker-report.md`）与白名单文件，严禁读取 `L1-decision/`、`L2-dispatch/`、`L2-internal/` 或其他任务目录。
- **`L1-Maintenance-Exemption` 定性与冻结**：对于经 `L1` 在 `mandate.md` 明确授权的框架文档维护任务，`L2b` 可在 `spec.md` 内联 `L1-Maintenance-Exemption` 与精确文件白名单供 `L3` 机械修改框架文档。**该机制仅属写权限例外（绝非 `L1 → L3` 跨层派发捷径，流转仍须经 `L2`）；未经人类明确授权，严禁新增任何其他跨层派发或跨层写权限例外。**

### 3.4 显式流转状态机、Delta 回写与交接转接卡（Spec-03 核心）
- 过程文档头部统一维护 `(Task-ID, Phase, Attempt)` 及 `Status` / `Next-Route` / `Execution-Tier` 字段，覆盖 `ROUTE_TO_L2B`、`ROUTE_TO_L2A`、`ROUTE_TO_L3_ATTEMPT_<N>`、`AWAITING_L1_HEAVY_APPROVAL`、`BLOCKED_NEEDS_L1`、`READY_FOR_L1_ARCHIVE` 标准路由；同阶段最多允许 2 轮异构模型执行（`Attempt 1`、`Attempt 2`）。
- 每次跨层交接必须在回复末尾输出自包含的【跨 Harness 人工转接指令块】。`L1` 仅在 `briefing.md` 状态为 `READY_FOR_L1_ARCHIVE` 时合并 OpenSpec Deltas 并归档三区任务目录。

### 3.5 Session 复用策略（Session Reuse Policy — 场景 A/B 与 G1~G6 红线）
- **场景 A（汇总验收复用 — 谁派发，谁验收）**：`[MAY]` / `[SHOULD]` `L1` 派出多个任务后可复用同一 `L1` Session 依次处理各任务的 `briefing.md`；`L2b` 产出 `spec.md` 后可复用同一 `L2b` Session 在 Mode B 验收对应 `worker-report.md`。
- **场景 B（关联任务承接复用）**：`[MAY]` / `[SHOULD]` 存在前序任务、多期阶段（`Phase`）或性质相近任务时，可复用当时承接它的同角色 `L2a`、`L2b` 或同算力档位 `L3` Session。
- **六条强制复用红线（Guardrails G1~G6）**：
  1. **G1 文档仍是唯一依据**：每次接新任务或新 `Phase` 必须重新读取授权文档，残留记忆仅作缓存，冲突时以文档为准；
  2. **G2 仅同层同角色复用**：严禁跨层复用，同一任务内 `L2a` Session 不得转任 `L2b`，严禁 `subagent` 跨层代劳；
  3. **G3 换任务/换阶段重新握手**：绑定新 `<task-id>` 或新 `Phase` 时须重做 Step 0 自检并更新首行横幅，`L3-Standard` 与 `L3-Heavy` Session 严禁混用；
  4. **G4 L3 零跳检索不放松**：复用的 `L3` Session 仅以当前任务当前 `Phase` 的 `spec.md` 为唯一规约依据，严禁把前序任务 `spec.md` 或经验当作授权来源，严禁读其他任务目录；
  5. **G5 重试换模型优先于复用**：`L3` 失败重派（`Attempt 2`）必须按 `model-layers.md` 跨模型家族轮换，严禁复用刚失败的 Session；
  6. **G6 上下文过满即新开**：Session 上下文接近上限、出现污染或反复纠错时必须新开 Session，并在转接卡中注明原因。
- **阶段与复用元数据字段**：六份 `_templates/` 统一含 `Phase` 字段（旧记录无该字段默认兼容视为 `Phase: 1`）；`mandate.md` / `spec.md` 可填 `Session-Affinity`（仅作人工转接复用建议，不赋予跨任务读取权限）；`briefing.md` / `worker-report.md` 记录 `Handled-By`；所有跨 Harness 转接卡均带「会话建议 (Session Guidance)」。
- **三元组状态匹配**：`L2b` 与 `L3` 核对执行与验收状态时统一按 **`(Task-ID, Phase, Attempt)`** 三元组匹配（审校轮次按 `(Task-ID, Phase, Review-Round)`），彻底杜绝上一阶段已完成的 `worker-report.md` 或 `briefing.md` 误触发下一阶段验收或归档。
