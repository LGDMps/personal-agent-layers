# 模型服务分层配置与防呆纠错表 (`model-layers.md`)

> **用途说明**：
> 1. 本文件是 `.agent-layers` 体系中**模型能力与层级映射的唯一权威配置表**。
> 2. 任何 Session 在收到 `/al1`、`/al2a`、`/al2b`、`/al3`（或 `@al*`）指令时，必须在 **Step 0** 读取本表完成自检。
> 3. 当模型版本迭代（如新模型发布）或可用模型发生变化时，人类用户只需直接编辑本文件中的表格，无需修改各 Skill 内部逻辑。
> 4. 仓库内置的是一份通用示例：部署到新项目后，请按自己实际可用的模型，替换下表中的服务商、型号与调用端。

---

## 一、 当前可用模型池总览

| 服务商 | 可用模型系列 | 常用 Harness 调用端 | 层级定位 |
| :-: | :--- | :--- | :--- |
| **Google** | `Gemini-4-Argon`<br>`Claude Opus 5.5` / `Sonnet 5.5` | Antigravity App/CLI / DeepSeek Harness | **高阶综合池**：长上下文、全局架构综合、方案审校裁剪与收敛 |
| **OpenAI** | `GPT-6` 系列<br>(`GPT-6-Astra`, `GPT-6.1-Sol`) | CodeX / DeepSeek Harness | **攻坚池**：严密逻辑推理、防御性方案主笔、边界条件分析与风险排查（挑刺） |
| **智谱** | `GLM-5.3` 系列<br>(`GLM-5.3`, `GLM-5.3-Flash`) | ZCode / DeepSeek Harness | **执行池**：高频代码编写与测试迭代 |
| **DeepSeek** | `Deepseek-V4.1-Flash` | DeepSeek Harness | **执行池**：高性价比执行层 Worker，与 `GLM-5.3` 交替轮换防钻牛角尖 |
| **OpenCode** | `Gemini-4-Argon`<br>`Claude Haiku 5.5` | OpenCode / DeepSeek Harness | **备用池**：可选接入，不作为强依赖 |

---

## 二、 模型层级映射与白名单矩阵（Active Mapping）

| 层级代号 | 激活口令 | 角色定位与核心认知要求 | 首选模型 (Primary) | 备选/替补模型 (Fallback) | 模型标识匹配规则 (Case-Insensitive Substring / Glob) | 严禁使用的模型类别 |
| :-: | :-: | :--- | :--- | :--- | :--- | :--- |
| **`L1`** | `/al1`<br>`@al1` | **决策层 (Decision Layer)**<br>高阶意图理解、多任务优先级权衡、全局架构演进与文档消歧 | - `Gemini-4-Argon`<br>- `GPT-6-Astra` | - `Claude Opus 5.5` | `gemini-4-argon*`<br>`gpt-6-astra*`<br>`claude-opus-5*` | ❌ 严禁使用任何 `Flash` / `Haiku` / `Lite` 及 `L3` 模型 |
| **`L2a`** | `/al2a <id>`<br>`@al2a <id>` | **调度层·方案主笔 (Drafter)**<br>深入代码库检索、严密防御性设计、全面排查边界条件与潜在破坏点（挑刺） | - `GPT-6.1-Sol` | - `GPT-6-Astra`<br>- `Claude Opus 5.5` | `gpt-6.1-sol*`<br>`gpt-6-astra*`<br>`claude-opus-5*` | ❌ 严禁使用 `L3` 执行层模型；不建议用偏向发散或精简的模型替代防御型主笔 |
| **`L2b`** | `/al2b <id>`<br>`@al2b <id>` | **调度层·审校与验收 (Reviewer)**<br>批判性审核初稿、砍掉冗余设计与非必要枝蔓、提炼零歧义 `spec.md`、验收执行结果并压缩为 `briefing.md` | - `Gemini-4-Argon` | - `Claude Sonnet 5.5`<br>- `Claude Opus 5.5` | `gemini-4-argon*`<br>`claude-sonnet-5*`<br>`claude-opus-5*` | ❌ 严禁使用 `L3` 执行层模型；避免与刚写完初稿的 `L2a` 使用完全相同的会话而不做角色切换 |
| **`L3`** | `/al3 <id>`<br>`@al3 <id>` | **执行层 (Worker)**<br>严格遵从自包含 `spec.md` 执行编码与测试命令，零架构发散，高吞吐低成本 | - `GLM-5.3` / `GLM-5.3-Flash`<br>- `Deepseek-V4.1-Flash` | - `Qwen-3.8-Flash`<br>- `Claude Haiku 5.5` | `glm-5.3*`<br>`deepseek-v4.1-flash*`<br>`qwen-3.8-flash*`<br>`claude-haiku-5*` | ⚠️ 避免使用 `L1`/`L2` 旗舰模型（防止高阶配额在底层编码执行环节被快速耗尽） |

---

## 三、 执行层（L3 Worker）异构模型轮换策略（Diversity Rotation）

为防止单一执行层模型在某个具体 Bug 或测试报错上“钻牛角尖”（陷入死循环重复无效修改），`L2b` 在派发或重派 `/al3 <task-id>` 时遵循以下轮换规则：
1. **首轮派发（Attempt 1）**：默认优先指派 **`GLM-5.3`**（编码能力与成本的平衡点），或按任务奇偶交替指派 `GLM-5.3` 与 `Deepseek-V4.1-Flash`。
2. **受阻重派（Attempt 2）**：若 Attempt 1 的执行层汇报 `BLOCKED` 或测试未通过，且经 `L2b` 审校确认并非 `spec.md` 方案本身缺陷，则在下一阶段跨 Harness 转接指令块中**强制切换为另一个执行层模型**（例如 Attempt 1 用了 `GLM-5.3`，Attempt 2 必须指定 `Deepseek-V4.1-Flash`）。
3. **熔断上报（Attempt > 2）**：若两个不同家族的执行层模型均执行失败，严禁继续盲目重试 `L3`，必须由 `L2b` 修订 `spec.md` 或写入 `briefing.md` 上报 `L1` 决策层。

---

## 四、 Step 0 防呆自检执行规范（供各 `/al*` Skill 调用）

当 Agent 收到激活口令后，按以下顺序判定并输出首行状态横幅：

### 情况 A：环境已暴露当前模型身份，且匹配当前层级白名单（🟢 PASS）
直接输出以下单行横幅并立即进入正式工作：
> `✅ [Layer Handshake: PASS] 激活层级：<L1 / L2a / L2b / L3> | 当前模型：<Model Name> | 绑定任务：<Global 或 task-id>`

### 情况 B：下位模型越级调用，例如用 L3 模型调用了 `/al1` 或 `/al2a` / `/al2b`（🔴 HARD STOP）
**立即停止一切后续工具调用（严禁读取项目文档或代码）**，仅输出：
> `❌ [层级-模型能力不匹配拦截] 当前会话模型为 <Model Name>（归属 L3 执行层），不具备 <目标层级> 所需的推理与规划能力。`
> `👉 请在宿主界面将模型切换为：<该层级 Primary / Fallback 模型列表>，然后重新发送指令。（如确需强行测试，请显式回复 "强制豁免"）`

### 情况 C：上位模型降级调用，例如用 L1/L2 旗舰模型调用了 `/al3`（🟡 QUOTA WARN）
**先读取 `L3-execution/<task-id>/spec.md` 但在动手修改代码前暂停**，输出：
> `⚠️ [高阶配额保护提示] 当前会话模型为 <Model Name>（属于 L1/L2 旗舰/调度池），而当前激活的是 L3 执行层 Worker 任务。`
> `👉 建议切换为 GLM-5.3 或 Deepseek-V4.1-Flash 执行以节约高阶额度；若确认直接使用当前模型执行，请回复 "继续"。`

### 情况 D：宿主环境未在上下文暴露具体模型名（🔵 BLIND CHECK）
若从 System Prompt 与环境信息中无法确定具体模型版本，输出显式核对横幅后继续执行：
> `ℹ️ [Layer Handshake: 请目视确认模型] 激活层级：<目标层级> | 请确认您已将模型选择器设为：<该层级 Primary 模型> | 绑定任务：<Global 或 task-id>`
