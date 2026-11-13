# L3 执行层工作详细汇报 (`worker-report.md`) — Task: `<TASK_ID>`

> **文档属性与权限约束**：
> - **文件路径**：`.agent-layers/L3-execution/<TASK_ID>/worker-report.md`
> - **更新模式**：**按执行轮次追加 (Append-per-Attempt)**。每次 `L3` 会话结束时，在末尾新增一个 `## Attempt N` 小节，最后一个完整 Attempt 小节代表最新执行状态，严禁删改历史小节。
> - **读写权限**：`L3 执行层`（**仅追加**）、`L2b 调度审校 / L2a 主笔`（**只读**）、`L1 决策层`（🚫 **严禁访问**，只看 `L2/briefing.md`）

---

## Attempt 1 — `<YYYY-MM-DD HH:mm>` (Worker Model: `<实际运行模型名称>`)

### 1. 执行状态与路由 (`Outcome & Routing`)
- **Task-ID**：`<TASK_ID>`
- **Phase**：`1`
- **Attempt**：`1`
- **Execution-Tier**：`L3-Standard`
- **Status**：`COMPLETED`
- **Next-Route**：`ROUTE_TO_L2B`
- **Handled-By**：`<Host / Session Label>`
<!-- Status 枚举：COMPLETED（全部步骤与验证命令均通过） | BLOCKED（遇到阻塞，已按熔断规则停机）
     Next-Route 固定为：ROUTE_TO_L2B（交由 L2b 独立验收，L3 严禁自行宣布结项归档） -->

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
