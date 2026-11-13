# Personal Agent Layers — 面向单项目的三层模型服务与四区文档隔离体系

一套**与具体项目仓库（Repository）强绑定、与具体 Harness 软件（DeepSeek Harness / Antigravity / CodeX / ZCode / OpenCode）解耦**的分层智能体工作流规范与脚手架。

---

## 一、 核心设计理念

1. **按模型基础能力构建三层协同体系（Layered Model Architecture）**：
   - **人类用户（最高决策与监督者）**：把握最终战略方向与监督，主要与 `L1 决策层` 对话，少量介入 `L2 调度层`，原则上不直接对接 `L3 执行层`。
   - **`L1` 决策层（`/al1-decision`，兼容 `/al1`、`@al1`）**：由全局综合能力最强的旗舰模型（请读取 [`.agent-layers/model-layers.md`](.agent-layers/model-layers.md) 中 `L1` 的 Primary / Fallback 模型）担任，负责需求对齐、维护全局架构真相源、下发任务委派书（`mandate.md`）并审阅 `L2` 结项简报。
   - **`L2` 调度层（双模型协作与互审 — `/al2a-drafter` + `/al2b-reviewer`）**：
     - **`L2a` 调度层·方案主笔（`/al2a-drafter <task-id>`，兼容 `/al2a <task-id>`）**：由模型配置表中 `L2a` 的防御性逻辑与挑刺能力强的 Primary 模型担任，深入代码库只读调研，产出详尽的 `draft-plan.md`；
     - **`L2b` 调度层·方案审校与结果验收（`/al2b-reviewer <task-id>`，兼容 `/al2b <task-id>`）**：由模型配置表中 `L2b` 的长文收敛与提炼能力强的 Primary 模型担任，审校初稿、砍掉废话与过度设计的冗余枝蔓，蒸馏为面向执行层 Worker 模型的自包含 `spec.md`；并在执行完成后验收结果、提炼 `briefing.md`。
   - **`L3` 执行层（Worker — `/al3-worker <task-id>`，兼容 `/al3 <task-id>`）**：按**双算力档位**运行：
     - **`L3-Standard`（常规编码 / 机械重构 / 脚本验证 / 初步检索）**：由高性价比执行层模型（`GLM-5.3` 与 `Deepseek-V4.1-Flash` 等，见 `model-layers.md`）交替轮换；
     - **`L3-Heavy`（深度文献分析 / 长篇报告撰写 / 高复杂度核心算法与架构攻坚）**：使用模型配置表中的旗舰级推理模型，但必须经 `L2b -> L1` 的 `AWAITING_L1_HEAVY_APPROVAL` 强制升档审批门禁批准后方可派发；
     - 两个档位均遵循 **Inline-or-Never** 原则只读单份 `spec.md`，在文件白名单内改代码、跑测试、输出详细汇报 `worker-report.md`。
   - **模型推荐统一由 [`.agent-layers/model-layers.md`](.agent-layers/model-layers.md) 动态配置**：所有 Skill、模板与转接卡均不写死固定型号，而是按当前层级 / 档位读取该表的 Primary / Fallback 模型。
2. **Session 无状态化 + 跨 Harness 手动转接友好（State-Compute Separation & Cross-Harness Handoff）**：
   - 任何层级都不与单个常驻 Session 强绑定；新开启的 Session 严禁尝试恢复旧会话聊天记录，100% 从 `.agent-layers/` 下的受控文档恢复上下文。
   - 跨层级委派必须由**独立的层级 Session** 承接（支持按 `AGENTS.md` §3.5 的 **Session 复用策略**复用同角色既有 Session——如「场景 A：谁派发谁验收」与「场景 B：关联任务同角色承接」，并受 G1~G6 六条红线约束；**严禁使用 `subagent` 跨层代劳**）。
   - 每个层级的 Session 结束时，均会自动输出包含**「极简口令（方式 A）」**与**「跨 Harness 自包含引导块（方式 B）」**的双模式转接卡，支持人类在 `Antigravity`、`CodeX`、`DeepSeek Harness`、`ZCode` 等不同宿主间无缝手动复制转接。
3. **吸收 OpenSpec 的生命周期机制**：
   - 区分**「全局现状规范（`01-charter-and-specs.md`）」**与**「在途任务包（`<task-id>/`）」**；
   - 任务结项时通过 `briefing.md` 提取架构增量（`Delta: ADDED / MODIFIED / REMOVED`）回写 `L1`，并将过程文档一键移入 `.agent-layers/archive/<YYYY-MM-DD>-<task-id>/`，保持工作区长期清爽。

---

## 二、 仓库文件拓扑与四区文档更新模式

```text
<project-repo>/
├── AGENTS.md                                      # 跨 Harness 宪章、未定级门禁与 /al* 路由表
├── DEPLOY.md                                      # 面向 Agent 的声明式安装与非破坏性增量升级规程（无脚本体系）
├── .agents/
│   └── skills/                                    # 渐进式披露 (Progressive Disclosure) 角色规程
│       ├── al1-decision/SKILL.md                  # /al1-decision 决策层规程
│       ├── al2a-drafter/SKILL.md                  # /al2a-drafter 调度层·方案主笔规程
│       ├── al2b-reviewer/SKILL.md                 # /al2b-reviewer 调度层·审校与验收规程
│       └── al3-worker/SKILL.md                    # /al3-worker 执行层 (Worker) 规程
├── .agent-layers/
│   ├── model-layers.md                            # 模型服务分层配置与 Step 0 防呆纠错表
│   ├── L1-decision/                               # 【第一区：人类 ↔ L1 决策层】
│   │   ├── 00-intent-log.md                       # Append-Only 人类指令流（超 5 条活跃记录触发折叠归档）
│   │   ├── 01-charter-and-specs.md                # Versioned Living State 全局架构现状真相（主文档）
│   │   ├── 01-charter-changelog.md                # 架构演进历史记录（从属文件，日常默认不加载）
│   │   ├── 02-roadmap.md                          # 全局任务五态排期主表（主文档）
│   │   └── 02-roadmap-audit.md                    # 状态流转审计简志（从属文件，日常默认不加载）
│   ├── L2-dispatch/<task-id>/                     # 【第二区：L1 决策层 ↔ L2 调度层】
│   │   ├── mandate.md                             # 派工即锁定（含背景、边界、验收标准）
│   │   └── briefing.md                            # 调度验收后提炼的百字简报 + OpenSpec Delta
│   ├── L2-internal/<task-id>/                     # 【第三区：L2a ↔ L2b 调度层内部互审工作区】
│   │   ├── draft-plan.md                          # L2a 防御性方案初稿（对 L3 绝对不可见）
│   │   └── review-notes.md                        # L2b 审校裁决与裁剪记录
│   ├── L3-execution/<task-id>/                    # 【第四区：L2b ↔ L3 单任务执行区】
│   │   ├── spec.md                                # 定稿即冻结的 Inline-or-Never 自包含执行契约
│   │   └── worker-report.md                       # 按 Attempt 追加的详细代码修改与测试输出汇报
│   ├── _templates/                                # 各层级标准 Markdown 模板库
│   └── archive/<YYYY-MM-DD>-<task-id>/            # 已结项归档的历史任务包
```

---

## 三、 多级文档读写权限矩阵（Access Control Matrix）

| 文档路径 / 资产类别 | 人类用户 | `L1` 决策层<br>(`/al1-decision`) | `L2a` 调度主笔<br>(`/al2a-drafter <id>`) | `L2b` 调度审校<br>(`/al2b-reviewer <id>`) | `L3` 执行层 (Worker)<br>(`/al3-worker <id>`) |
| :--- | :-: | :-: | :-: | :-: | :-: |
| **`AGENTS.md` & `.agent-layers/model-layers.md`** | ✍️ 读写 | 👁️ 只读 | 👁️ 只读 | 👁️ 只读 | 👁️ 只读 |
| **`L1-decision/00-intent-log.md`** | ➕ 追加/审阅 | ➕ **仅追加 + 折叠** | 🚫 禁止访问 | 🚫 禁止访问 | 🚫 禁止访问 |
| **`L1-decision/01-charter-and-specs.md`** | ✍️ 读写 | ✍️ **读写 (主文档)** | 👁️ 只读 | 👁️ 只读 | 🚫 禁止访问 |
| **`L1-decision/01-charter-changelog.md` & `02-roadmap-audit.md`** | 👁️ 按需审阅 | ➕ **仅追加 (默认不读)** | 🚫 默认不读 | 🚫 默认不读 | 🚫 严禁访问 |
| **`L1-decision/02-roadmap.md`** | ✍️ 读写 | ✍️ **读写** | 🚫 禁止访问 | 🚫 禁止访问 | 🚫 禁止访问 |
| **`L2-dispatch/<id>/mandate.md`** | 👁️ 审阅 | ✍️ **读写** | 👁️ 只读 | 👁️ 只读 | 🚫 禁止访问 |
| **`L2-dispatch/<id>/briefing.md`** | 👁️ 审阅 | 👁️ **只读** | 👁️ 只读 | ✍️ **读写** | 🚫 禁止访问 |
| **`L2-internal/<id>/draft-plan.md`** | *(默认不看)* | 🔒 特批只读 | ✍️ **读写** | 👁️ 只读 | 🚫 **严禁访问** |
| **`L2-internal/<id>/review-notes.md`** | *(默认不看)* | 🔒 特批只读 | 👁️ 只读 | ➕ **仅追加** | 🚫 **严禁访问** |
| **`L3-execution/<id>/spec.md`** | *(默认不看)* | 🔒 特批只读 | 👁️ 只读 | ✍️ **读写 (定稿)** | 📌 **唯一内联只读**（经 `L1` 明确授权的框架维护任务，可按 `spec.md` 的 `L1-Maintenance-Exemption` 白名单执行限定维护） |
| **`L3-execution/<id>/worker-report.md`** | *(默认不看)* | 🚫 禁止访问 | 👁️ 只读 | 👁️ **只读 (验收)** | ➕ **仅追加** |
| **项目业务源码文件** | ✍️ 读写 | 👁️ 仅顶层目录 | 👁️ **只读调研 (禁改)** | 👁️ **只读核实 (禁改)** | ✍️ **白名单内读写**（经 `L1` 明确授权的框架维护任务，可按 `spec.md` 的 `L1-Maintenance-Exemption` 白名单执行限定维护） |

---

## 四、 快速使用指南

### 1. 将本体系声明式部署或非破坏性升级到任意项目仓库（基于 DEPLOY.md）

> 完整安装/升级规程见 [`DEPLOY.md`](DEPLOY.md)。将下面整段提示词交给具备文件读写权限的通用工程 Agent 即可：

```text
请读取源框架目录 `<SOURCE_FRAMEWORK_ABSOLUTE_PATH>/DEPLOY.md`，将 Personal Agent Layers (PAL) 安装或非破坏性升级到目标项目 `<TARGET_PROJECT_ABSOLUTE_PATH>`：
1. 先解析并核对源目录与目标目录的真实绝对路径；若同源、目标为公开框架仓本身或路径无效，立即停止并报错。
2. 自动判断首次安装（Fresh Install）或增量更新（Upgrade）：
   - 若已存在 `.agent-layers/` 或 `.agents/skills/al1-decision/`，进入非破坏性差异比对模式：默认保留目标项目所有内容不同的既有文件与自定义额外文件，绝不覆盖已有的 `.agent-layers/model-layers.md` 与 `.agent-layers/L1-decision/**` 业务记录。
   - 请向我输出完整的差异清单（Diff Summary），仅在我明确点名要求覆盖指定文件后才执行替换。
3. 严禁复制源仓库的在途任务或私有历史流水，严禁创建任何 `.ps1/.sh/.py/.js` 脚本。
4. 完成后汇报实际写入/保留的文件清单与验证结果，并提示我开启首次 `/al1-decision` 会话完成目标项目业务章程（`01-charter-and-specs.md`）的初始化对齐。
```

### 2. 日常跨层级/跨 Harness 协同循环
> 每个步骤的模型选择均以 [`.agent-layers/model-layers.md`](.agent-layers/model-layers.md) 中对应层级 / 档位的 Primary / Fallback 模型为准（下表仅示例）。

1. **战略决策与派工 (`L1`)**：在 `Antigravity` / `DeepSeek Harness` 开启或按 G1~G6 复用同角色 Session → 选 `model-layers.md` 中 `L1` 的 Primary 模型 → 输入 `/al1-decision 讨论需求并派发任务 FEAT-001`（兼容 `/al1 ...`）；
2. **调度主笔写初稿 (`L2a`)**：切换到 `CodeX` / `DeepSeek Harness` 开启或复用同角色 `L2a` Session → 选 `model-layers.md` 中 `L2a` 的 Primary 模型 → 粘贴上一步末尾输出的 `/al2a-drafter FEAT-001`（兼容 `/al2a FEAT-001`，或**跨 Harness 自包含引导块**）；
3. **调度审校定稿 Spec (`L2b`)**：开启或复用同角色 `L2b` Session → 选 `model-layers.md` 中 `L2b` 的 Primary 模型 → 粘贴 `/al2b-reviewer FEAT-001`（兼容 `/al2b FEAT-001`，或自包含引导块）；
4. **执行层 Worker 写代码 (`L3`)**：切换到 `ZCode` / `DeepSeek Harness` 开启或复用同算力档位 `L3` Session → 选 `model-layers.md` 中当前 `Execution-Tier`（`L3-Standard` / `L3-Heavy`）的 Primary 模型 → 粘贴 `/al3-worker FEAT-001`（兼容 `/al3 FEAT-001`，或自包含引导块；`Attempt 2` 异构重试必须新开 Session）；
5. **调度验收与决策层归档 (`L2b → L1`)**：复用派发该 `spec.md` 的 `L2b` Session 跑 `/al2b-reviewer FEAT-001` 生成 `briefing.md` → 回到 `/al1-decision` 合并 `Delta` 并执行归档。

### 3. 纯 Agent 声明式日常管理操作（零脚本 Agent-Native 工作流）

| 操作 | 推荐入口 | 受控文档流转方式 |
| :--- | :--- | :--- |
| **部署与升级** | 未绑定受限角色的通用工程 Agent 会话 | 按 [`DEPLOY.md`](DEPLOY.md) 执行；升级走非破坏性 `Diff Summary`，绝不覆盖 `model-layers.md` 与 `L1-decision/` 业务记录 |
| **新建任务并派工** | `/al1-decision` | `L1` 创建 `.agent-layers/L2-dispatch/<task-id>/mandate.md`（含 `Phase` / `Execution-Tier`），更新 `02-roadmap.md` 并在 `02-roadmap-audit.md` 追加审计行，输出 `/al2a-drafter` 转接卡 |
| **查看在途任务状态** | `/al1-decision` | 读取 `02-roadmap.md` 主表与 `L2-dispatch/*/briefing.md`；更深层状态可由 `/al2b-reviewer <task-id>` 检查各过程文档头部的 `Phase` / `Status` / `Next-Route` / `Attempt` 字段 |
| **获取下一步跨 Harness 转接卡** | 任一完成当前阶段工作的层级 Session | 该 Session 按文档显式 `Next-Route` / `Status` 状态自动在回复末尾输出【跨 Harness 手动转接卡】，无需脚本 |
| **完工 Delta 合并与归档** | `/al1-decision` | 仅当 `briefing.md` 为 `READY_FOR_L1_ARCHIVE` 时：合并 OpenSpec Deltas 至 `01-charter-and-specs.md`（变更追加至 `01-charter-changelog.md`），并将 `L2-dispatch` / `L2-internal` / `L3-execution` 下任务目录移入 `.agent-layers/archive/<YYYY-MM-DD>-<task-id>/` |

---

## 五、 许可证

本项目基于 [MIT License](LICENSE) 开源，可自由使用、修改与分发，请保留原始版权声明。
