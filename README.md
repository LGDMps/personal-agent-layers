# Personal Agent Layers — 面向单项目的三层模型服务与四区文档隔离体系

一套**与具体项目仓库（Repository）强绑定、与具体 Harness 软件（DeepSeek Harness / Antigravity / CodeX / ZCode / OpenCode）解耦**的分层智能体工作流规范与脚手架。

---

## 一、 核心设计理念

1. **按模型基础能力构建三层协同体系（Layered Model Architecture）**：
   - **人类用户（最高决策与监督者）**：把握最终战略方向与监督，主要与 `L1 决策层` 对话，少量介入 `L2 调度层`，原则上不直接对接 `L3 执行层`。
   - **`L1` 决策层（`/al1` 或 `@al1`）**：由全局综合能力最强的旗舰模型（`Gemini-4-Argon` / `GPT-6-Astra`）担任，负责需求对齐、维护全局架构真相源、下发任务委派书（`mandate.md`）并审阅 `L2` 结项简报。
   - **`L2` 调度层（双模型协作与互审 — `/al2a` + `/al2b`）**：
     - **`L2a` 调度层·方案主笔（`/al2a <task-id>`）**：由防御性逻辑与挑刺能力强的 `GPT-6.1-Sol` 担任，深入代码库只读调研，产出详尽的 `draft-plan.md`；
     - **`L2b` 调度层·方案审校与结果验收（`/al2b <task-id>`）**：由长文收敛与提炼能力强的 `Gemini-4-Argon` 担任，审校初稿、砍掉废话与过度设计的冗余枝蔓，蒸馏为面向执行层 Worker 模型的自包含 `spec.md`；并在执行完成后验收结果、提炼 `briefing.md`。
   - **`L3` 执行层（Worker — `/al3 <task-id>`）**：由高性价比执行层模型（`GLM-5.3` 与 `Deepseek-V4.1-Flash`）交替轮换，遵循 **Inline-or-Never** 原则只读单份 `spec.md`，在文件白名单内改代码、跑测试、输出详细汇报 `worker-report.md`。
2. **Session 无状态化 + 跨 Harness 手动转接友好（State-Compute Separation & Cross-Harness Handoff）**：
   - 任何层级都不与单个常驻 Session 强绑定；新开启的 Session 严禁尝试恢复旧会话聊天记录，100% 从 `.agent-layers/` 下的受控文档恢复上下文。
   - 跨层级委派**必须开启新 Session**，严禁使用 `subagent` 跨层代劳。
   - 每个层级的 Session 结束时，均会自动输出包含**「极简口令（方式 A）」**与**「跨 Harness 自包含引导块（方式 B）」**的双模式转接卡，支持人类在 `Antigravity`、`CodeX`、`DeepSeek Harness`、`ZCode` 等不同宿主间无缝手动复制转接。
3. **吸收 OpenSpec 的生命周期机制**：
   - 区分**「全局现状规范（`01-charter-and-specs.md`）」**与**「在途任务包（`<task-id>/`）」**；
   - 任务结项时通过 `briefing.md` 提取架构增量（`Delta: ADDED / MODIFIED / REMOVED`）回写 `L1`，并将过程文档一键移入 `.agent-layers/archive/<YYYY-MM-DD>-<task-id>/`，保持工作区长期清爽。

---

## 二、 仓库文件拓扑与四区文档更新模式

```text
<project-repo>/
├── AGENTS.md                                      # 跨 Harness 宪章、未定级门禁与 /al* 路由表
├── .agents/
│   └── skills/                                    # 渐进式披露 (Progressive Disclosure) 角色规程
│       ├── al1-decision/SKILL.md                  # /al1 决策层规程
│       ├── al2a-drafter/SKILL.md                  # /al2a 调度层·方案主笔规程
│       ├── al2b-reviewer/SKILL.md                 # /al2b 调度层·审校与验收规程
│       └── al3-worker/SKILL.md                    # /al3 执行层 (Worker) 规程
├── .agent-layers/
│   ├── model-layers.md                            # 模型服务分层配置与 Step 0 防呆纠错表
│   ├── L1-decision/                               # 【第一区：人类 ↔ L1 决策层】
│   │   ├── 00-intent-log.md                       # Append-Only 人类指令流 + 定期消歧压缩
│   │   ├── 01-charter-and-specs.md                # Versioned Living State 全局架构真相 + Changelog
│   │   └── 02-roadmap.md                          # 全局任务五态排期表 + 状态审计流
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
└── scripts/
    └── manage-layers.ps1                          # 跨仓库初始化、新建任务、状态查看、转接卡生成与归档脚本
```

---

## 三、 多级文档读写权限矩阵（Access Control Matrix）

| 文档路径 / 资产类别 | 人类用户 | `L1` 决策层<br>(`/al1`) | `L2a` 调度主笔<br>(`/al2a <id>`) | `L2b` 调度审校<br>(`/al2b <id>`) | `L3` 执行层 (Worker)<br>(`/al3 <id>`) |
| :--- | :-: | :-: | :-: | :-: | :-: |
| **`AGENTS.md` & `.agent-layers/model-layers.md`** | ✍️ 读写 | 👁️ 只读 | 👁️ 只读 | 👁️ 只读 | 👁️ 只读 |
| **`L1-decision/00-intent-log.md`** | ➕ 追加/审阅 | ➕ **仅追加 + 折叠** | 🚫 禁止访问 | 🚫 禁止访问 | 🚫 禁止访问 |
| **`L1-decision/01-charter-and-specs.md`** | ✍️ 读写 | ✍️ **读写 (含 Changelog)** | 👁️ 只读 | 👁️ 只读 | 🚫 禁止访问 |
| **`L1-decision/02-roadmap.md`** | ✍️ 读写 | ✍️ **读写** | 🚫 禁止访问 | 🚫 禁止访问 | 🚫 禁止访问 |
| **`L2-dispatch/<id>/mandate.md`** | 👁️ 审阅 | ✍️ **读写** | 👁️ 只读 | 👁️ 只读 | 🚫 禁止访问 |
| **`L2-dispatch/<id>/briefing.md`** | 👁️ 审阅 | 👁️ **只读** | 👁️ 只读 | ✍️ **读写** | 🚫 禁止访问 |
| **`L2-internal/<id>/draft-plan.md`** | *(默认不看)* | 🔒 特批只读 | ✍️ **读写** | 👁️ 只读 | 🚫 **严禁访问** |
| **`L2-internal/<id>/review-notes.md`** | *(默认不看)* | 🔒 特批只读 | 👁️ 只读 | ➕ **仅追加** | 🚫 **严禁访问** |
| **`L3-execution/<id>/spec.md`** | *(默认不看)* | 🔒 特批只读 | 👁️ 只读 | ✍️ **读写 (定稿)** | 📌 **唯一内联只读** |
| **`L3-execution/<id>/worker-report.md`** | *(默认不看)* | 🚫 禁止访问 | 👁️ 只读 | 👁️ **只读 (验收)** | ➕ **仅追加** |
| **项目业务源码文件** | ✍️ 读写 | 👁️ 仅顶层目录 | 👁️ **只读调研 (禁改)** | 👁️ **只读核实 (禁改)** | ✍️ **白名单内读写** |

---

## 四、 快速使用指南

### 1. 将本体系一键部署到任意项目仓库
```powershell
pwsh ./scripts/manage-layers.ps1 init -TargetRepo "C:\path\to\your-project" -ProjectName "YourProject"
```

### 2. 日常跨层级/跨 Harness 协同循环
1. **战略决策与派工 (`L1`)**：在 `Antigravity` / `DeepSeek Harness` 新建 Session → 选模型 `Gemini-4-Argon` → 输入 `/al1 讨论需求并派发任务 FEAT-001`；
2. **调度主笔写初稿 (`L2a`)**：切换到 `CodeX` / `DeepSeek Harness` 新建 Session → 选模型 `GPT-6.1-Sol` → 粘贴上一步末尾输出的 `/al2a FEAT-001`（或**跨 Harness 自包含引导块**）；
3. **调度审校定稿 Spec (`L2b`)**：新建 Session → 选模型 `Gemini-4-Argon` → 粘贴 `/al2b FEAT-001`（或自包含引导块）；
4. **执行层 Worker 写代码 (`L3`)**：切换到 `ZCode` / `DeepSeek Harness` 新建 Session → 选模型 `GLM-5.3`（或 `Deepseek-V4.1-Flash`）→ 粘贴 `/al3 FEAT-001`（或自包含引导块）；
5. **调度验收与决策层归档 (`L2b → L1`)**：新建 Session 跑 `/al2b FEAT-001` 生成 `briefing.md` → 回到 `/al1` 合并 `Delta` 并执行归档。

### 3. 命令行辅助查看状态、生成跨 Harness 转接块或手动归档
```powershell
# 查看当前仓库所有在途任务的各层文档勾选状态与下一步推荐指令
pwsh ./scripts/manage-layers.ps1 status

# 快速创建某个任务的 L2/L3 文件夹与 mandate.md 模板
pwsh ./scripts/manage-layers.ps1 new-task -TaskId "FEAT-001" -Title "新增鉴权中间件"

# 根据任务当前进度，在终端一键打印下一阶段【跨 Harness 手动转接自包含引导块】
pwsh ./scripts/manage-layers.ps1 handoff -TaskId "FEAT-001"

# 将已结项任务的 L2/L3 过程文档一键移入 .agent-layers/archive/
pwsh ./scripts/manage-layers.ps1 archive-task -TaskId "FEAT-001"
```

---

## 五、 许可证

本项目基于 [MIT License](LICENSE) 开源，可自由使用、修改与分发，请保留原始版权声明。
