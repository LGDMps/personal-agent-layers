# L2 任务执行简报 (`briefing.md`) — Task: `<TASK_ID>`

> **文档属性与权限约束**：
> - **文件路径**：`.agent-layers/L2-dispatch/<TASK_ID>/briefing.md`
> - **更新模式**：**里程碑快照覆写 (Milestone Snapshot)**。由 `L2b 调度审校` 在核验 `L3` 执行汇报后提炼生成，隐去所有底层调试细节与测试日志，专供 `L1 决策层` 与人类用户阅读。
> - **读写权限**：`L2b 调度审校`（**读写**）、`L1 决策层`（**只读**，据此验收并提取 `Delta`）、`L2a 主笔`（只读）、`L3 执行层`（🚫 **严禁访问**）

---

## 1. 结项状态摘要 (Executive Summary)

- **Task-ID**：`<TASK_ID>`
- **Phase**：`1`
- **Status**：`READY_FOR_L1_ARCHIVE`
- **Next-Route**：`READY_FOR_L1_ARCHIVE`
- **Attempt**：`1`
- **Execution-Tier**：`L3-Standard`
- **Handled-By**：`<Host / Session Label>`
- **Requested-Heavy-Model**：`NONE`
- **Heavy-Escalation-Justification**：`NONE`
- **核心结论一句话总结（≤100字）**：
  > `<简述最终完成了什么、或为何申请升档/遇到何种阻塞>`

<!-- Status 与 Next-Route 枚举（两者保持一致）：
1. READY_FOR_L1_ARCHIVE：L2b 验收全部通过，请求 L1 合并 Delta 并归档（兼容识别旧标识 READY_FOR_L1）
2. AWAITING_L1_HEAVY_APPROVAL：mandate 默认为 L3-Standard 但 L2 判定必须升档为 L3-Heavy，请求 L1/人类在 mandate.md 第 6 节审批（此时尚未执行 L3，Attempt=0，须填写 Requested-Heavy-Model 与 Heavy-Escalation-Justification）
3. BLOCKED_NEEDS_L1：遇到战略/需求级冲突，或两轮审校/两轮异构 L3 执行均失败，请求 L1 裁决 -->

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

> **说明**：请用 `ADDED` / `MODIFIED` / `REMOVED` 明确列出本次任务对全局架构规范（`L1-decision/01-charter-and-specs.md`）产生的持久性改变；若纯属局部实现且不影响全局架构，填写 `NONE`。若项目采用内外双仓拓扑，须分别注明「供 L1 合并入外层章程」与「已由 L3 落入 `framework` 的位置」，避免向已业务模板化的 `framework` 章程重复回写框架内部条文。

- **`[ADDED]`**：...
- **`[MODIFIED]`**：...
- **`[REMOVED]`**：...

---

## 5. 残余风险或需上层裁决事项 (Risks & Escalations)

- *(无，或列出需要 L1 决策层/人类用户注意的后续技术债与决策问题)*
