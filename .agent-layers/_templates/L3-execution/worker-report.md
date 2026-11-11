# L3 执行层工作详细汇报 (`worker-report.md`) — Task: `<TASK_ID>`

> **文档属性与权限约束**：
> - **文件路径**：`.agent-layers/L3-execution/<TASK_ID>/worker-report.md`
> - **更新模式**：**按执行轮次追加 (Append-per-Attempt)**。每次 `L3` 会话结束时，在末尾新增一个 `## Attempt N` 小节，严禁删改之前的 Attempt 记录。
> - **读写权限**：`L3 执行层`（**仅追加**）、`L2b 调度审校 / L2a 主笔`（**只读**）、`L1 决策层`（🚫 **严禁访问**，只看 `L2/briefing.md`）

---

## Attempt 1 — `<YYYY-MM-DD HH:mm>` (Worker Model: `<GLM-5.3 / Deepseek-V4.1-Flash / ...>`)

### 1. 执行结论 (`Outcome`)
- **状态**：`COMPLETED`（全部步骤与验证命令均通过） | `BLOCKED`（遇到阻塞，已按熔断规则停机）

### 2. 分步完成核对 (Step Checklist)
- [x] Step 1：...
- [x] Step 2：...

### 3. 实际修改文件与改动摘要 (Modified Files & Diff Summary)
- `<path/to/file1>`：`<简述实际改了哪些函数/行>`

### 4. 验证命令真实输出 (Raw Verification Output)
```text
<粘贴真实的测试/构建命令运行输出与 Exit Code>
```

### 5. 阻塞现场与异常说明 (Blocker Details — 仅在 `BLOCKED` 时填写)
- **卡点位置**：...
- **复现报错信息**：...
- **为何无法在不突破 `spec.md` 的前提下解决**：...
