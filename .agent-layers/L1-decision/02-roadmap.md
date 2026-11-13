# L1 全局进度与任务排期表 (`02-roadmap.md`)

> **文档属性与权限约束**：
> - **层级归属**：`L1-decision`（全局任务状态面板，可与外部任务 DAG 工具的 `graph.json` 双向同步；状态流转审计明细见同目录独立从属文件 [`02-roadmap-audit.md`](02-roadmap-audit.md)，日常默认不加载）
> - **读写权限**：人类用户（读写）、`L1 决策层`（**读写**，负责拆解任务、更新状态、标记结项与归档）、`L2a / L2b / L3`（🚫 **严禁访问**，下层模型只关注被明确派发的单个 `<task-id>`）
> - **任务五态定义**：
>   - `planned`（待规划）：仅占位，尚未生成 `L2-dispatch/<task-id>/mandate.md`
>   - `todo`（待开始）：已生成 `mandate.md`，前置条件满足即可派发 `/al2a <task-id>`
>   - `doing`（进行中）：正在 `L2a (方案主笔)` → `L2b (方案审校)` → `L3 (Worker 执行)` → `L2b (结果验收)` 流水线中流转
>   - `done`（已完成）：`L1` 已审阅 `briefing.md`、合并架构 `Delta` 并将过程文档移入 `archive/`
>   - `failed`（已失败）：任务终止或废弃，已解除对下游任务的阻塞

---

## 1. 项目里程碑 (Current Milestone)

- **当前目标里程碑**：`M1 — <待 L1 规划>`
- **整体进度统计**：已完成 `0` / 总计 `0`（进行中 `0`，可开始 `0`，待规划 `0`）

---

## 2. 任务主表 (Task Registry)

| Task ID | 任务标题 | 五态 (`Status`) | 当前所处子阶段 (`Stage`) | 前置依赖 (`Prereqs`) | 关联文档路径 / 归档路径 | 最后更新 |
| :-: | :--- | :-: | :-: | :-: | :--- | :-: |
| `<TASK-ID>` | `<任务标题>` | `planned` | `awaiting_mandate` | `<前置任务或 无>` | `L2-dispatch/<TASK-ID>/mandate.md` | `<YYYY-MM-DD>` |

---

## 3. 状态流转审计简志索引 (State Audit Trail Reference)

- **状态审计明细**：已拆分为同目录独立从属文件 [`02-roadmap-audit.md`](02-roadmap-audit.md)（日常读取主文档时默认不加载；仅在 `L1` 更新任务状态同步追加审计记录或按需追溯时访问）。
