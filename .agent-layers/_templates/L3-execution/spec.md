# L3 自包含执行规约 (`spec.md`) — Task: `<TASK_ID>`

> **【INLINE-OR-NEVER 铁律 — 供 L3 执行层 (Worker) 模型阅读】**：
> 1. 本文件由 `L2b 调度审校` 定稿冻结，包含你完成本任务所需的**全部**上下文、接口定义与实现步骤。
> 2. **你（`L3 执行层 Worker`）严禁去搜索或读取 `.agent-layers/` 下的任何其他目录（严禁读 `L1-decision`、`L2-dispatch`、`L2-internal` 或其他任务目录）！**
> 3. **你只能在下方 `## 1. 允许操作的文件白名单` 范围内读写业务代码！**
> 4. 若严格按本规约执行时遇到无法逾越的方案级错误（如指定的函数/依赖根本不存在，或测试报错证明方案逻辑矛盾），**严禁自行发挥修改架构**，请立即停止修改，在同目录的 `worker-report.md` 中如实记录报错现场并交回 `L2b`。

---

## 1. 允许操作的文件白名单 (Strict File Whitelist)

- **允许只读参考的源码文件 (Read-Only Context Files)**：
  - `<path/to/context_file_1>`
- **允许修改或新建的源码文件 (Read/Write Target Files)**：
  - `<path/to/target_file_1>`
  - `<path/to/test_file_1>`

---

## 2. 内联必备上下文与接口契约 (Inlined Context & Signatures)

<!-- 由 L2b 直接将相关数据结构、函数签名、常量定义内联粘贴在此，使 L3 无需全库 grep -->
```text
// 关键现有签名或上下文摘要
```

---

## 3. 分步执行指令 (Step-by-Step Implementation Instructions)

> **要求**：零歧义、确定性、不包含任何“方案 A 或方案 B”的犹豫表述。

### Step 1：`<具体文件与修改动作>`
- **目标位置**：`<文件路径 + 函数/行号范围>`
- **具体修改内容**：
  ...

### Step 2：`<具体文件与修改动作>`
- **目标位置**：`...`
- **具体修改内容**：
  ...

---

## 4. 必跑验证命令与通过标准 (Verification Commands & Pass Criteria)

在完成上述代码修改后，必须依次执行以下命令并检查输出：

1. **命令 1**：
   ```powershell
   <具体的语法检查或单元测试命令>
   ```
   - **通过标准**：退出码为 `0`，且输出包含 `<预期结果>`。

---

## 5. 汇报要求 (Reporting Mandate)

无论全部通过（`COMPLETED`）还是中途受阻（`BLOCKED`），必须在 `.agent-layers/L3-execution/<TASK_ID>/worker-report.md` 末尾追加本次执行的完整报告，然后输出指向 `/al2b <TASK_ID>` 的**【跨 Harness 手动转接卡】**。
