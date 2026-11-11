# L2 任务执行简报 (`briefing.md`) — Task: `<TASK_ID>`

> **文档属性与权限约束**：
> - **文件路径**：`.agent-layers/L2-dispatch/<TASK_ID>/briefing.md`
> - **更新模式**：**里程碑快照覆写 (Milestone Snapshot)**。由 `L2b 调度审校` 在核验 `L3` 执行汇报后提炼生成，隐去所有底层调试细节与测试日志，专供 `L1 决策层` 与人类用户阅读。
> - **读写权限**：`L2b 调度审校`（**读写**）、`L1 决策层`（**只读**，据此验收并提取 `Delta`）、`L2a 主笔`（只读）、`L3 执行层`（🚫 **严禁访问**）

---

## 1. 结项状态摘要 (Executive Summary)

- **Task ID**：`<TASK_ID>`
- **当前汇总结论**：`READY_FOR_L1`（验收通过，待 L1 结项归档） | `BLOCKED_NEEDS_L1`（遇到战略/需求级卡点，需 L1 决策层或人类用户裁决）
- **核心成果一句话总结（≤100字）**：
  > `<简述最终完成了什么、效果如何>`

---

## 2. 验收标准达成核对 (Acceptance Criteria Verification)

| 验收项 | 达成状态 (`PASS`/`FAIL`) | 验证依据简述（由 L2b 核实） |
| :-: | :-: | :--- |
| `AC-1` | `PASS` | `<例如：单测全部通过，新增接口符合契约>` |
| `AC-2` | `PASS` | `<...>` |

---

## 3. 交付资产变更清单 (Delivered Artifacts)

- **新增文件**：`...`
- **修改文件**：`...`
- **移除文件**：`...`

---

## 4. 架构与规范增量 (OpenSpec Deltas — 供 L1 合并回 `01-charter-and-specs.md`)

> **说明**：请用 `ADDED` / `MODIFIED` / `REMOVED` 明确列出本次任务对全局架构规范（`L1-decision/01-charter-and-specs.md`）产生的持久性改变；若纯属局部实现且不影响全局架构，填写 `NONE`。

- **`[ADDED]`**：...
- **`[MODIFIED]`**：...
- **`[REMOVED]`**：...

---

## 5. 残余风险或需上层裁决事项 (Risks & Escalations)

- *(无，或列出需要 L1 决策层/人类用户注意的后续技术债与决策问题)*
