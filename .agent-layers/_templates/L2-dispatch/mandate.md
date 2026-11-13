# L2 任务委派书 (`mandate.md`) — Task: `<TASK_ID>`

> **文档属性与权限约束**：
> - **文件路径**：`.agent-layers/L2-dispatch/<TASK_ID>/mandate.md`
> - **更新模式**：**派工即锁定 (Write-Once per Dispatch)**。由 `L1 决策层` 创建下发；若人类中途变更需求，由 `L1` 在底部 `## 需求修订追加 (Amendments)` 小节追加，严禁下层模型自行修改。
> - **读写权限**：`L1 决策层`（读写）、`L2a 主笔 / L2b 审校`（**只读**）、`L3 执行层`（🚫 **严禁访问**）

---

## 1. 任务元信息 (Metadata)

- **Task ID**：`<TASK_ID>`
- **Phase**：`1`
- **Session-Affinity**：`NONE`
- **任务标题**：`<TASK_TITLE>`
- **派发时间**：`<YYYY-MM-DD HH:mm>`
- **前置依赖任务**：`<NONE 或 前置 Task ID 列表>`
- **Execution-Tier**：`L3-Standard`
- **Recommended-Model**：`<读取 .agent-layers/model-layers.md 中对应 Execution-Tier 的 Primary/Fallback 模型>`
- **Heavy-Approval**：`NONE`

<!-- Execution-Tier 枚举：L3-Standard（默认） | L3-Heavy（若由 L1 直接预批，须在 Heavy-Approval 填写：APPROVED_BY_L1 (<YYYY-MM-DD>, 指定高阶模型：<型号>)） -->
<!-- Phase 默认为 1（若任务重开多期则在修订中递增）；Session-Affinity 可选填写前序/关联任务或阶段标签（如 FEAT-001 或 ARCH-001 Phase-1），供人工按 Session 复用策略（G1~G6）参考。 -->

---

## 2. 背景与战略意图 (Why & Context)

<!-- 说明为什么要做这个任务，它解决什么业务/架构问题。不要写底层代码实现步骤。 -->

---

## 3. 范围边界 (Scope & Non-Goals)

### 3.1 必须完成的目标 (In-Scope)
- [ ] 目标 1：...
- [ ] 目标 2：...

### 3.2 明确不做的事 / 禁区红线 (Out-of-Scope & Constraints)
- 🚫 严禁触碰的模块/接口：...
- 🚫 本次不处理的旁枝需求：...

---

## 4. 前置任务产出摘要 (Upstream Artifacts Summary)

<!-- 由 L1 从已完成前置任务的 briefing.md 中摘录关键结论，避免 L2 再去翻阅无关历史任务 -->
- 无（或列出前置任务提供的接口/文件/结论）

---

## 5. 最终验收标准 (Acceptance Criteria)

<!-- 采用可验证的客观标准（如测试通过、接口契约满足、文档产出等） -->
1. **[AC-1]**：...
2. **[AC-2]**：...

---

## 6. 需求修订追加 (Amendments — Append-Only by L1)

- *(暂无修订)*

<!-- 若 L2b 提交 AWAITING_L1_HEAVY_APPROVAL 申请升档，L1/人类裁决后在此追加：
- **[<YYYY-MM-DD HH:mm> L3-Heavy 升档审批]**：`APPROVED`（批准升档为 `L3-Heavy`，指定推荐模型：`<模型名>`） 或 `REJECTED`（维持 `L3-Standard`，理由：`...`）
-->
