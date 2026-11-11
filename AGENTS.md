# AGENTS.md — 项目分层智能体（Agent Layers）宪章与强制门禁协议

> **最高优先级指令（SYSTEM MANDATE）**：
> 本仓库启用了 **Personal Agent Layers（三层模型服务 + 四区文档隔离体系）**。
> **任何 Session 的唯一权威信息来源仅为 `.agent-layers/` 目录下的受控文档**。严禁跨 Session 假设上下文，严禁超越当前激活层级的权限边界读写文件，严禁使用 `subagent` / `invoke_subagent` 进行跨层级任务委派。

---

## 1. 会话初始门禁与角色激活协议（Role Handshake Protocol）

当一个新的会话（Session）启动时，默认处于**【未定级挂起态（Uninitialized）】**。在执行任何实质性文件探索、代码修改或方案设计前，必须根据人类用户的首条指令完成**角色定级与模型防呆自检**：

### 1.1 角色激活口令路由表（支持 `/` 或 `@` 前缀，大小写不敏感）

| 激活口令 | 绑定的模型层级与角色 | 必须立即读取并遵循的 Skill 规程 | 允许访问的 `.agent-layers/` 权限域 |
| :--- | :--- | :--- | :--- |
| **`/al1`** `[需求/指令]`<br>或 **`@al1`** `[需求/指令]` | **L1 决策层 (Decision Layer)**<br>战略对齐、全局架构维护、任务分派、Delta 合并与归档 | [`.agents/skills/al1-decision/SKILL.md`](.agents/skills/al1-decision/SKILL.md) | - `L1-decision/**` (`读写 / 追加`)<br>- `L2-dispatch/*/mandate.md` (`读写`)<br>- `L2-dispatch/*/briefing.md` (`只读`)<br>- `archive/**` (`只读`) |
| **`/al2a <task-id>`**<br>或 **`@al2a <task-id>`** | **L2a 调度层·方案主笔 (Drafter)**<br>代码库深入调研、边界条件分析与风险排查（挑刺）、撰写防御性技术初稿 | [`.agents/skills/al2a-drafter/SKILL.md`](.agents/skills/al2a-drafter/SKILL.md) | - `L1-decision/01-charter-and-specs.md` (`只读`)<br>- `L2-dispatch/<task-id>/**` (`只读`)<br>- `L2-internal/<task-id>/draft-plan.md` (`读写`)<br>- `L2-internal/<task-id>/review-notes.md` (`只读`)<br>- `L3-execution/<task-id>/**` (`只读`) |
| **`/al2b <task-id>`**<br>或 **`@al2b <task-id>`** | **L2b 调度层·审校与验收 (Reviewer)**<br>初稿审校、裁剪冗余枝蔓、定稿自包含 `spec.md`、执行验收与提炼简报 | [`.agents/skills/al2b-reviewer/SKILL.md`](.agents/skills/al2b-reviewer/SKILL.md) | - `L1-decision/01-charter-and-specs.md` (`只读`)<br>- `L2-dispatch/<task-id>/mandate.md` (`只读`)<br>- `L2-dispatch/<task-id>/briefing.md` (`读写`)<br>- `L2-internal/<task-id>/draft-plan.md` (`只读`)<br>- `L2-internal/<task-id>/review-notes.md` (`仅追加`)<br>- `L3-execution/<task-id>/spec.md` (`读写`)<br>- `L3-execution/<task-id>/worker-report.md` (`只读`) |
| **`/al3 <task-id>`**<br>或 **`@al3 <task-id>`** | **L3 执行层 (Worker)**<br>严格按自包含 `spec.md` 编写代码、运行测试验证、输出详细执行汇报 | [`.agents/skills/al3-worker/SKILL.md`](.agents/skills/al3-worker/SKILL.md) | - **仅限** `L3-execution/<task-id>/spec.md` (`内联只读`)<br>- **仅限** `L3-execution/<task-id>/worker-report.md` (`仅追加`) |

> **未带口令时的默认行为**：
> 若人类用户在新建 Session 的首条消息中**未包含**上述任何口令（`/al1`、`/al2a`、`/al2b`、`/al3` 或 `@al*`），请**不要**自行猜测角色或开始翻阅代码库，而是简短回复：
> `⏸️ 当前会话尚未绑定 Agent Layer。请指定本会话层级：/al1 (L1 决策层) | /al2a <task-id> (L2a 调度主笔) | /al2b <task-id> (L2b 调度审校/验收) | /al3 <task-id> (L3 执行层 Worker)。`

---

## 2. 跨层级模型防呆自检（Step 0 强制动作）

激活任一 `/al*` 角色后，**第一步必须读取 [`.agent-layers/model-layers.md`](.agent-layers/model-layers.md)**，将当前会话所运行的模型与配置表比对：
1. **能力不足硬拦截（Hard Stop）**：若当前运行在 `L3` 执行层模型（如 `Deepseek-V4.1-Flash`、`GLM-5.3` 等），但收到了 `/al1`、`/al2a` 或 `/al2b` 指令，**必须立即中止执行**，严禁读取或修改任何项目文档，提示用户切换至对应的高阶模型（除非用户显式回复 `"强制豁免"`）。
2. **算力浪费软提醒（Quota Warn）**：若当前运行在 `L1/L2` 旗舰/调度模型（如 `GPT-6.1-Sol`、`Gemini-4-Argon`、`Claude Opus 5.5`），但收到了 `/al3 <task-id>` 执行层指令，**必须先暂停修改代码**，提醒用户当前正在消耗高阶配额，建议切换为 `GLM-5.3` 或 `Deepseek-V4.1-Flash`（除非用户显式回复 `"继续"`）。
3. **盲盒宿主显式回显**：若当前 Harness 环境未向 System Prompt 注入具体的模型名称，必须在首行状态横幅中打印该层级**应当使用的推荐模型列表**供人类目视核对。

---

## 3. 全局四大铁律（Irrevocable Invariants）

1. **严禁跨层调用 Subagent**：
   - `L1 → L2`、`L2a → L2b`、`L2b → L3`、`L3 → L2b` 的流转，**必须通过产出文档 + 输出跨 Harness 人工转接指令块（由新 Session 承接）**来完成，绝对禁止使用 `subagent` / `invoke_subagent` 代劳下一层级的工作。
   - *唯一例外*：`L2a（调度主笔）` 在进行只读代码库调研时，可在层内派生只读 `research` 子智能体辅助搜索文件。
2. **业务源码写入隔离（Code Write Isolation）**：
   - **`L1（决策层）`、`L2a（调度主笔）`、`L2b（调度审校）` 严禁直接修改任何项目业务源码文件！** 它们只能修改各自权限域内的 `.agent-layers/` 文档。
   - **只有 `L3（执行层 Worker）` 允许修改业务源码**，且严格限制在 `L3-execution/<task-id>/spec.md` 声明的【允许修改文件白名单】内。
3. **Inline-or-Never（禁止执行层二跳检索）**：
   - `L2b` 产出的 `L3-execution/<task-id>/spec.md` 必须是 100% 自包含的执行契约（包含精确文件路径、函数签名、分步修改逻辑与验证命令）。
   - `L3` 执行层启动后只读该份 `spec.md` 与白名单源码文件，**严禁去搜索或读取 `L1-decision/`、`L2-dispatch/`、`L2-internal/` 或其他任务的目录**。
4. **交接即输出跨 Harness 人工转接指令块（Cross-Harness Manual Handoff Block）**：
   - 考虑到不同层级 Session 可能运行在不同 Harness 软件中并由人类手动派发转接，任何层级的 Session 在完成本阶段文档写入后，必须在回复最末尾输出**自包含的【跨 Harness 人工转接指令块】**（包含目标层级、推荐模型、激活口令、规程文件路径、只读输入文档路径、目标输出文档路径及核心权限红线），确保人类将其直接复制粘贴到任何 Harness 的新 Session 时均能零歧义自引导启动。
