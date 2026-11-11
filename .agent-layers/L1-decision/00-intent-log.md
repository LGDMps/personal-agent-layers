# L1 人类指令与决策流水账 (`00-intent-log.md`)

> **文档属性与权限约束**：
> - **层级归属**：`L1-decision`（人类用户 ↔ L1 决策层共享）
> - **读写权限**：人类用户（追加/审阅）、`L1 决策层`（**仅追加 Append-Only**；满阈值时执行折叠消歧）、`L2a / L2b / L3`（🚫 **严禁访问**）
> - **更新铁律**：日常交互中，**只允许在 `## 活跃决策流 (Active Stream)` 末尾追加新条目**，严禁篡改或静默删除上方已有的历史记录。当人类提出打断、修正或方向变更时，通过新增一条带时间戳的记录来覆盖旧决策；定期由 `L1` 高阶模型对冲突内容进行消歧压缩，并将旧条目移入 `.agent-layers/archive/intent-history/`。

---

## 消歧摘要基线 (Compacted Baseline Summary)

- *最后消歧时间*：`<YYYY-MM-DD>`
- *当前核心共识*：
  1. `<尚未建立，等待 L1 在首次派发任务时填写>`

---

## 活跃决策流 (Active Stream — Append-Only Below)

<!-- 在此按时间顺序追加指令记录，单条格式如下：

### [YYYY-MM-DD HH:mm] <一句话主题>
- **人类指令 (Human Intent)**：
  - <要点>
- **L1 决策方案 (L1 Resolution)**：
  - <要点>
- **关联派发任务 (Dispatched Tasks)**：`<task-id>`

-->
