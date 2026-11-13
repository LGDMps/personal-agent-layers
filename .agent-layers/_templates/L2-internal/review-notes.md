# L2 调度层内部工作区：审校批注记录 (`review-notes.md`) — Task: `<TASK_ID>`

> **文档属性与权限约束**：
> - **文件路径**：`.agent-layers/L2-internal/<TASK_ID>/review-notes.md`
> - **更新模式**：**按审校轮次追加 (Append-per-Review)**。由 `L2b 调度审校`（推荐读取 `.agent-layers/model-layers.md` 中 `L2b` 的 Primary/Fallback 模型）在审阅 `draft-plan.md` 后追加写入；**最后一个完整 Review Round 小节为当前最新状态，严禁篡改历史小节**。
> - **读写权限**：`L2b 调度审校`（**仅追加**）、`L2a 调度主笔`（**只读**）、`L1 决策层`（🔒 默认不读）、`L3 执行层`（🚫 **绝对禁止访问**）

---

## Review Round 1 — `<YYYY-MM-DD HH:mm>` (Reviewer: `L2b`)

- **Task-ID**：`<TASK_ID>`
- **Phase**：`1`
- **Review-Round**：`1`
- **Proposed-Execution-Tier**：`L3-Standard`
- **Execution-Tier**：`L3-Standard`
- **Attempt**：`1`
- **Verdict**：`APPROVED_AND_DISTILLED`
- **Status**：`APPROVED_AND_DISTILLED`
- **Next-Route**：`ROUTE_TO_L3_ATTEMPT_1`

<!-- 状态与路由枚举映射：
1. 审校通过派发执行：Verdict/Status = APPROVED_AND_DISTILLED | Next-Route = ROUTE_TO_L3_ATTEMPT_1 (或 ROUTE_TO_L3_ATTEMPT_2)
2. 首轮打回 L2a 重修（最多 1 次，Review-Round=1）：Verdict/Status = REJECTED_ONCE | Next-Route = ROUTE_TO_L2A | Attempt = 0
3. 申请 L3-Heavy 升档审批（mandate 未预批时严禁直派 Heavy）：Verdict = ESCALATE_TO_L1 | Status = AWAITING_L1_HEAVY_APPROVAL | Next-Route = AWAITING_L1_HEAVY_APPROVAL | Attempt = 0
4. 重大架构冲突或第 2 轮仍失败上报 L1：Verdict = ESCALATE_TO_L1 | Status = BLOCKED_NEEDS_L1 | Next-Route = BLOCKED_NEEDS_L1

审校轮次按 (Task-ID, Phase, Review-Round) 匹配；执行轮次按 (Task-ID, Phase, Attempt) 匹配。
-->

- **审校裁决说明**：`APPROVED_AND_DISTILLED`（通过并已提炼生成 `L3-execution/<TASK_ID>/spec.md`） | `REJECTED_ONCE`（存在致命缺陷，打回 `L2a` 重修 1 次） | `ESCALATE_TO_L1`（超出调度层权限或存在需求冲突，上报 `L1`）
- **针对 `mandate.md` 的一致性核查**：
  - ...
- **裁剪掉的过度设计 / 冗余项（Distillation Cuts）**：
  <!-- 记录从 L2a 初稿中砍掉的废话、不必要或过于繁琐的防御性枝蔓，确保下发给 L3 的 spec.md 极简纯粹 -->
  - ...
- **若为 `REJECTED_ONCE`，要求 `L2a` 修正的致命问题清单**：
  1. ...
