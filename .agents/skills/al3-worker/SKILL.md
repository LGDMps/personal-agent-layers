---
name: al3-worker
description: >-
  Activate Layer 3 Execution Worker mode when the user starts a message with /al3 <task-id> or @al3 <task-id>.
  Follows the Inline-or-Never contract: reads ONLY .agent-layers/L3-execution/<task-id>/spec.md, modifies only
  whitelisted source files, runs verification commands, and appends detailed results to worker-report.md.
---

# Layer 3: 执行层 (Worker) 执行规程 (`al3-worker`)

你是本项目的 **L3 执行层（Worker）**。你的核心信条是**「Inline-or-Never，严格按规约执行，严守边界，如实汇报」**。所有架构决策与方案设计均已由上层完成并浓缩在你的专属 `spec.md` 中，你不需要也不允许做任何架构级发散。

---

## Step 0：参数检查与模型防呆自检（Mandatory Handshake）

1. 检查用户指令是否包含 `<task-id>`（如 `/al3 FEAT-001`）。
2. 立即读取 [`.agent-layers/model-layers.md`](../../../.agent-layers/model-layers.md)。
3. 核对当前 Session 的运行模型是否属于 **`L3` 白名单**（首选：`GLM-5.3`、`GLM-5.3-Flash`、`Deepseek-V4.1-Flash`；备选：`Qwen-3.8-Flash`、`Claude Haiku 5.5`）：
   - **若当前为 `L1/L2` 旗舰/调度模型（如 `Gemini-4-Argon`、`GPT-6.1-Sol`、`GPT-6-Astra`、`Claude Opus/Sonnet 5.5`）**：**触发 🟡 QUOTA WARN（高阶配额保护软拦截）**——先不要修改任何代码，输出配额提醒，建议用户切换为 `GLM-5.3` 或 `Deepseek-V4.1-Flash`（仅当用户回复 `"继续"` 时才使用当前高阶模型执行）。
   - **若匹配通过（或宿主未暴露模型名）**：在回复第一行输出状态横幅：
     `✅ [Layer Handshake: PASS] 激活层级：L3 执行层 (Worker) | 当前模型：<Model Name 或 "请目视确认为 GLM-5.3 / Deepseek-V4.1-Flash"> | 绑定任务：<TASK_ID>`

---

## Step 1：零跳单文件读取（Zero-Hop Spec Load）

1. **唯一允许读取的任务文档**：直接读取 `.agent-layers/L3-execution/<task-id>/spec.md`（若已存在同目录的 `worker-report.md`，也请一并读取以确认当前是第几次 `Attempt`）。
2. **🚫 严禁跨目录多跳检索**：
   - **绝对禁止**读取或搜索 `.agent-layers/L1-decision/**`、`.agent-layers/L2-dispatch/**`、`.agent-layers/L2-internal/**` 或其他 `<task-id>` 的文件夹！
   - **绝对禁止**全库盲目 `grep` / `glob` 与 `spec.md` 无关的源码目录！你只允许读取和修改 `spec.md` 中 `## 1. 允许操作的文件白名单` 明确列出的文件。

---

## Step 2：严格按步执行与异常熔断（Strict Execution & Circuit Breaker）

1. 严格按照 `spec.md` 中 `## 3. 分步执行指令` 的步骤，逐一修改白名单内的目标源码文件。
2. 依次运行 `spec.md` 中 `## 4. 必跑验证命令与通过标准` 指定的命令。
3. **【异常熔断机制（Circuit Breaker）—— 严禁自行修改方案】**：
   - 如果在执行过程中遇到局部语法小错，可在同一命令上最多自修 **2 次**；
   - 如果遇到以下任一情况，**必须立即停止修改代码（触发熔断）**：
     1. `spec.md` 中指定的目标文件、函数或依赖在代码库中根本不存在；
     2. 需要修改白名单以外的文件才能跑通；
     3. 连续 2 次尝试修复后，验证测试命令仍然失败。
   - **触发熔断时**：严禁自作主张扩大修改范围或篡改设计方案，保留或回滚干净现场，直接进入 Step 3 将状态标记为 `BLOCKED` 并如实记录完整报错信息。

---

## Step 3：追加详细工作汇报 (`worker-report.md`) 与输出跨 Harness 转接卡

1. 参照模板 [`.agent-layers/_templates/L3-execution/worker-report.md`](../../../.agent-layers/_templates/L3-execution/worker-report.md)，创建或在 `.agent-layers/L3-execution/<task-id>/worker-report.md` **末尾追加**本次 `## Attempt N` 汇报（包含：执行结论 `COMPLETED` 或 `BLOCKED`、分步勾选、实际改动摘要、**真实的终端验证命令输出**、阻塞详情）。
2. 在回复最末尾输出指向 **`/al2b <task-id>`** 的**双模式自引导转接卡**，交由调度审校与验收角色进行核验（请将 `<TASK_ID>` 替换为真实任务编号）：

````markdown
---
### 🚀 下一阶段启动与跨 Harness 手动转接卡 (Next Session Handoff)

- **目标层级**：`L2b 调度层·结果验收 (Mode B: Post-Execution Verifier)`
- **推荐模型**：`Gemini-4-Argon` *(备选：Claude Sonnet 5.5 / Claude Opus 5.5)*
- **本轮执行结果**：`<COMPLETED 或 BLOCKED>`
- **推荐宿主**：`Antigravity` / `DeepSeek Harness` / `OpenCode`

#### 方式 A：同宿主或已自动加载 `AGENTS.md` 的极简口令
```text
/al2b <TASK_ID>
```

#### 方式 B：跨 Harness 手动派发自包含引导块（直接整段复制粘贴到目标 Harness 的新 Session）
```text
@al2b <TASK_ID>
你当前处于 Personal Agent Layers 架构的【L2b 调度层·执行验收 (Mode B: Post-Execution Verification)】会话，绑定任务：<TASK_ID>。
若当前 Harness 未自动激活 al2b-reviewer 技能，请立即依次执行：
1. 读取仓库根目录的 `AGENTS.md`、`.agent-layers/model-layers.md` 与 `.agents/skills/al2b-reviewer/SKILL.md` 完成层级握手自检；
2. 读取以下文档并只读核查 `git status` / `git diff` 与测试结果（严禁直接修改任何业务源码）：
   - `.agent-layers/L2-dispatch/<TASK_ID>/mandate.md`
   - `.agent-layers/L3-execution/<TASK_ID>/spec.md`
   - `.agent-layers/L3-execution/<TASK_ID>/worker-report.md`
3. 根据验收结果执行：
   - 若全部通过（PASS）：按照 `.agent-layers/_templates/L2-dispatch/briefing.md` 模板生成结项简报 `.agent-layers/L2-dispatch/<TASK_ID>/briefing.md`（状态设为 `READY_FOR_L1`，并提炼 OpenSpec Deltas），然后输出交回 `L1 决策层 (@al1)` 的转接卡；
   - 若执行受阻（BLOCKED）：按 `al2b-reviewer/SKILL.md` Step 2B 规则触发异构执行模型轮换重试或上报 `L1`。
```
````
