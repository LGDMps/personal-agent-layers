<#
.SYNOPSIS
    Personal Agent Layers 仓库级脚手架与任务生命周期管理脚本。

.DESCRIPTION
    提供五个无状态子命令，支持将本体系一键部署到任意项目仓库，或辅助各层级快速创建/归档任务目录与生成跨 Harness 手动转接指令：
    1. init         : 将 AGENTS.md、.agent-layers/、.agents/skills/ 部署到目标项目仓库（默认不覆盖已存在的 AGENTS.md、model-layers.md 与 L1 文档，加 -Force 才覆盖）
    2. new-task     : 为指定 <TaskId> 初始化 L2-dispatch / L2-internal / L3-execution 目录并生成 mandate.md 草稿
    3. archive-task : 将已结项的 <TaskId> 从 L2/L3 活跃区折叠归档至 .agent-layers/archive/<YYYY-MM-DD>-<TaskId>/
    4. status       : 扫描并展示目标仓库当前在途任务的各层文档就绪状态
    5. handoff      : 根据指定 <TaskId> 当前已生成的文档进度，自动打印下一阶段【跨 Harness 手动转接自包含引导块】

.EXAMPLE
    pwsh ./scripts/manage-layers.ps1 init -TargetRepo "C:\LocalRepos\my-project" -ProjectName "MyProject"
    pwsh ./scripts/manage-layers.ps1 new-task -TaskId "FEAT-001" -Title "实现用户鉴权模块"
    pwsh ./scripts/manage-layers.ps1 handoff -TaskId "FEAT-001"
    pwsh ./scripts/manage-layers.ps1 status
    pwsh ./scripts/manage-layers.ps1 archive-task -TaskId "FEAT-001"
#>

param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet("init", "new-task", "archive-task", "status", "handoff")]
    [string]$Action,

    [Parameter()]
    [string]$TargetRepo = (Get-Location).Path,

    [Parameter()]
    [string]$ProjectName = "",

    [Parameter()]
    [string]$TaskId = "",

    [Parameter()]
    [string]$Title = "待填写任务标题",

    [Parameter()]
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$SourceRoot = Split-Path -Parent $PSScriptRoot
$ResolvedTarget = [System.IO.Path]::GetFullPath($TargetRepo)
$Today = (Get-Date).ToString("yyyy-MM-dd")
$NowStr = (Get-Date).ToString("yyyy-MM-dd HH:mm")

function Assert-TaskId([string]$Id) {
    if ([string]::IsNullOrWhiteSpace($Id)) {
        throw "必须通过 -TaskId 指定任务编号（例如 -TaskId 'FEAT-001'）。"
    }
    if ($Id -notmatch '^[A-Za-z0-9_-]+$') {
        throw "TaskId '$Id' 格式无效：仅允许字母、数字、下划线与连字符。"
    }
}

switch ($Action) {
    "init" {
        if (-not (Test-Path -LiteralPath $ResolvedTarget)) {
            New-Item -ItemType Directory -Path $ResolvedTarget -Force | Out-Null
        }
        $ProjTitle = if ([string]::IsNullOrWhiteSpace($ProjectName)) { Split-Path -Leaf $ResolvedTarget } else { $ProjectName }

        # 1. 复制或合并 AGENTS.md
        $TargetAgentsMd = Join-Path $ResolvedTarget "AGENTS.md"
        $SourceAgentsMd = Join-Path $SourceRoot "AGENTS.md"
        if ((-not (Test-Path -LiteralPath $TargetAgentsMd)) -or $Force) {
            Copy-Item -LiteralPath $SourceAgentsMd -Destination $TargetAgentsMd -Force
            Write-Host "[OK] 已写入 $TargetAgentsMd" -ForegroundColor Green
        } else {
            Write-Host "[SKIP] $TargetAgentsMd 已存在（如需覆盖请加 -Force）" -ForegroundColor Yellow
        }

        # 2. 创建 .agent-layers 目录结构与模板
        $LayersRoot = Join-Path $ResolvedTarget ".agent-layers"
        $SubDirs = @(
            "L1-decision",
            "L2-dispatch",
            "L2-internal",
            "L3-execution",
            "archive",
            "_templates/L2-dispatch",
            "_templates/L2-internal",
            "_templates/L3-execution"
        )
        foreach ($sub in $SubDirs) {
            $dirPath = Join-Path $LayersRoot $sub
            if (-not (Test-Path -LiteralPath $dirPath)) {
                New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
            }
        }

        # 复制 model-layers.md（已存在则保留本地配置，避免覆盖订阅信息）与 _templates
        $dstModel = Join-Path $LayersRoot "model-layers.md"
        if ((-not (Test-Path -LiteralPath $dstModel)) -or $Force) {
            Copy-Item -LiteralPath (Join-Path $SourceRoot ".agent-layers/model-layers.md") -Destination $dstModel -Force
        } else {
            Write-Host "[SKIP] $dstModel 已存在（保留本地配置，如需重置请加 -Force）" -ForegroundColor Yellow
        }
        Copy-Item -Path (Join-Path $SourceRoot ".agent-layers/_templates/*") -Destination (Join-Path $LayersRoot "_templates") -Recurse -Force

        # 初始化 L1-decision 三份基础文档（若不存在或 -Force）
        $L1Files = @("00-intent-log.md", "01-charter-and-specs.md", "02-roadmap.md")
        foreach ($f in $L1Files) {
            $dst = Join-Path $LayersRoot "L1-decision/$f"
            if ((-not (Test-Path -LiteralPath $dst)) -or $Force) {
                $content = Get-Content -LiteralPath (Join-Path $SourceRoot ".agent-layers/L1-decision/$f") -Raw -Encoding UTF8
                Set-Content -LiteralPath $dst -Value $content -Encoding UTF8
            }
        }

        # 3. 复制 .agents/skills/al* 四个层级 Skills
        $SkillsDest = Join-Path $ResolvedTarget ".agents/skills"
        if (-not (Test-Path -LiteralPath $SkillsDest)) {
            New-Item -ItemType Directory -Path $SkillsDest -Force | Out-Null
        }
        $SkillNames = @("al1-decision", "al2a-drafter", "al2b-reviewer", "al3-worker")
        foreach ($s in $SkillNames) {
            $srcSkill = Join-Path $SourceRoot ".agents/skills/$s"
            $dstSkill = Join-Path $SkillsDest $s
            if (Test-Path -LiteralPath $dstSkill) {
                Remove-Item -LiteralPath $dstSkill -Recurse -Force
            }
            Copy-Item -LiteralPath $srcSkill -Destination $dstSkill -Recurse -Force
        }

        Write-Host "✅ 已在 [$ProjTitle] ($ResolvedTarget) 完成 Personal Agent Layers 初始化！" -ForegroundColor Cyan
        Write-Host "👉 开启新 Session 后输入 '/al1' 或 '@al1' 即可进入 L1 决策层。" -ForegroundColor Cyan
    }

    "new-task" {
        Assert-TaskId $TaskId
        $LayersRoot = Join-Path $ResolvedTarget ".agent-layers"
        if (-not (Test-Path -LiteralPath $LayersRoot)) {
            throw "目标仓库尚未初始化 .agent-layers，请先运行 init。"
        }

        $L2DispatchDir = Join-Path $LayersRoot "L2-dispatch/$TaskId"
        $L2InternalDir = Join-Path $LayersRoot "L2-internal/$TaskId"
        $L3ExecDir     = Join-Path $LayersRoot "L3-execution/$TaskId"

        foreach ($d in @($L2DispatchDir, $L2InternalDir, $L3ExecDir)) {
            if (-not (Test-Path -LiteralPath $d)) {
                New-Item -ItemType Directory -Path $d -Force | Out-Null
            }
        }

        $MandatePath = Join-Path $L2DispatchDir "mandate.md"
        if ((-not (Test-Path -LiteralPath $MandatePath)) -or $Force) {
            $tpl = Get-Content -LiteralPath (Join-Path $LayersRoot "_templates/L2-dispatch/mandate.md") -Raw -Encoding UTF8
            $rendered = $tpl.Replace("<TASK_ID>", $TaskId).Replace("<TASK_TITLE>", $Title).Replace("<YYYY-MM-DD HH:mm>", $NowStr)
            Set-Content -LiteralPath $MandatePath -Value $rendered -Encoding UTF8
            Write-Host "[OK] 已生成任务委派书模板：$MandatePath" -ForegroundColor Green
        } else {
            Write-Host "[SKIP] $MandatePath 已存在。" -ForegroundColor Yellow
        }
    }

    "archive-task" {
        Assert-TaskId $TaskId
        $LayersRoot = Join-Path $ResolvedTarget ".agent-layers"
        $ArchiveDir = Join-Path $LayersRoot "archive/$Today-$TaskId"
        if (-not (Test-Path -LiteralPath $ArchiveDir)) {
            New-Item -ItemType Directory -Path $ArchiveDir -Force | Out-Null
        }

        $Zones = @("L2-dispatch", "L2-internal", "L3-execution")
        $MovedCount = 0
        foreach ($z in $Zones) {
            $srcZoneTask = Join-Path $LayersRoot "$z/$TaskId"
            if (Test-Path -LiteralPath $srcZoneTask) {
                $dstZoneTask = Join-Path $ArchiveDir $z
                Move-Item -LiteralPath $srcZoneTask -Destination $dstZoneTask -Force
                $MovedCount++
            }
        }

        if ($MovedCount -eq 0) {
            Remove-Item -LiteralPath $ArchiveDir -Force -ErrorAction SilentlyContinue
            throw "未在 L2-dispatch / L2-internal / L3-execution 下找到任务 '$TaskId'。"
        }
        Write-Host "📦 已将任务 [$TaskId] 的 $MovedCount 个层级目录归档至：$ArchiveDir" -ForegroundColor Cyan
    }

    "status" {
        $LayersRoot = Join-Path $ResolvedTarget ".agent-layers"
        if (-not (Test-Path -LiteralPath $LayersRoot)) {
            throw "目标仓库未找到 .agent-layers 目录：$ResolvedTarget"
        }

        $TaskIds = @()
        foreach ($z in @("L2-dispatch", "L2-internal", "L3-execution")) {
            $zPath = Join-Path $LayersRoot $z
            if (Test-Path -LiteralPath $zPath) {
                $dirs = Get-ChildItem -LiteralPath $zPath -Directory | Select-Object -ExpandProperty Name
                $TaskIds += $dirs
            }
        }
        $UniqueTasks = $TaskIds | Sort-Object -Unique

        Write-Host "=== Personal Agent Layers 在途任务状态 ($ResolvedTarget) ===" -ForegroundColor Cyan
        if ($UniqueTasks.Count -eq 0) {
            Write-Host "（当前无在途任务，L2/L3 活跃区为空）" -ForegroundColor Gray
        } else {
            $Rows = foreach ($id in $UniqueTasks) {
                $hasMandate  = Test-Path -LiteralPath (Join-Path $LayersRoot "L2-dispatch/$id/mandate.md")
                $hasDraft    = Test-Path -LiteralPath (Join-Path $LayersRoot "L2-internal/$id/draft-plan.md")
                $hasReview   = Test-Path -LiteralPath (Join-Path $LayersRoot "L2-internal/$id/review-notes.md")
                $hasSpec     = Test-Path -LiteralPath (Join-Path $LayersRoot "L3-execution/$id/spec.md")
                $hasReport   = Test-Path -LiteralPath (Join-Path $LayersRoot "L3-execution/$id/worker-report.md")
                $hasBriefing = Test-Path -LiteralPath (Join-Path $LayersRoot "L2-dispatch/$id/briefing.md")

                $nextCmd = if ($hasBriefing) { "/al1 (待结项归档)" }
                           elseif ($hasReport) { "/al2b $id (待验收)" }
                           elseif ($hasSpec) { "/al3 $id (待执行)" }
                           elseif ($hasDraft) { "/al2b $id (待审校)" }
                           elseif ($hasMandate) { "/al2a $id (待主笔)" }
                           else { "/al1 (待写 mandate)" }

                [PSCustomObject]@{
                    TaskId       = $id
                    L2_Mandate   = if ($hasMandate)  { "✅" } else { "⬜" }
                    L2a_Draft    = if ($hasDraft)    { "✅" } else { "⬜" }
                    L2b_Review   = if ($hasReview)   { "✅" } else { "⬜" }
                    L3_Spec      = if ($hasSpec)     { "✅" } else { "⬜" }
                    L3_Report    = if ($hasReport)   { "✅" } else { "⬜" }
                    L2b_Briefing = if ($hasBriefing) { "✅" } else { "⬜" }
                    NextAction   = $nextCmd
                }
            }
            $Rows | Format-Table -AutoSize
        }
    }

    "handoff" {
        Assert-TaskId $TaskId
        $LayersRoot = Join-Path $ResolvedTarget ".agent-layers"
        if (-not (Test-Path -LiteralPath $LayersRoot)) {
            throw "目标仓库未找到 .agent-layers 目录：$ResolvedTarget"
        }

        $hasMandate  = Test-Path -LiteralPath (Join-Path $LayersRoot "L2-dispatch/$TaskId/mandate.md")
        $hasDraft    = Test-Path -LiteralPath (Join-Path $LayersRoot "L2-internal/$TaskId/draft-plan.md")
        $hasSpec     = Test-Path -LiteralPath (Join-Path $LayersRoot "L3-execution/$TaskId/spec.md")
        $hasReport   = Test-Path -LiteralPath (Join-Path $LayersRoot "L3-execution/$TaskId/worker-report.md")
        $hasBriefing = Test-Path -LiteralPath (Join-Path $LayersRoot "L2-dispatch/$TaskId/briefing.md")

        Write-Host "=== 任务 [$TaskId] 跨 Harness 手动转接卡 (Cross-Harness Manual Handoff) ===" -ForegroundColor Cyan

        if ($hasBriefing) {
            Write-Host "目标层级 : L1 决策层 | 推荐模型 : Gemini-4-Argon / GPT-6-Astra" -ForegroundColor Green
            Write-Host "------------------- 请复制以下内容到目标 Harness 新 Session -------------------" -ForegroundColor Yellow
            @"
@al1 审阅任务 $TaskId 的结项简报并执行 Delta 合并与归档
你当前处于 Personal Agent Layers 架构的【L1 决策层】会话。
若当前 Harness 未自动激活 al1-decision 技能，请立即依次执行：
1. 读取仓库根目录的 ``AGENTS.md``、``.agent-layers/model-layers.md`` 与 ``.agents/skills/al1-decision/SKILL.md`` 完成层级握手自检；
2. 读取 ``.agent-layers/L1-decision/`` 下的三份核心文档以及 ``.agent-layers/L2-dispatch/$TaskId/briefing.md``；
3. 若 ``briefing.md`` 状态为 ``READY_FOR_L1``，向人类用户汇报成果，将其中的 OpenSpec Deltas 合并回 ``.agent-layers/L1-decision/01-charter-and-specs.md``，并将 ``$TaskId`` 归档至 ``.agent-layers/archive/``，最后更新 ``02-roadmap.md``。
"@ | Write-Output
        }
        elseif ($hasReport) {
            Write-Host "目标层级 : L2b 调度层·执行验收 (Mode B) | 推荐模型 : Gemini-4-Argon / Claude Sonnet 5.5" -ForegroundColor Green
            Write-Host "------------------- 请复制以下内容到目标 Harness 新 Session -------------------" -ForegroundColor Yellow
            @"
@al2b $TaskId
你当前处于 Personal Agent Layers 架构的【L2b 调度层·执行验收 (Mode B: Post-Execution Verification)】会话，绑定任务：$TaskId。
若当前 Harness 未自动激活 al2b-reviewer 技能，请立即依次执行：
1. 读取仓库根目录的 ``AGENTS.md``、``.agent-layers/model-layers.md`` 与 ``.agents/skills/al2b-reviewer/SKILL.md`` 完成层级握手自检；
2. 读取 ``.agent-layers/L2-dispatch/$TaskId/mandate.md``、``.agent-layers/L3-execution/$TaskId/spec.md`` 与 ``.agent-layers/L3-execution/$TaskId/worker-report.md``，并只读核查 git status / git diff（严禁直接修改业务源码）；
3. 若验收通过，按模板生成 ``.agent-layers/L2-dispatch/$TaskId/briefing.md``（含 OpenSpec Deltas）并输出交回 L1 的转接卡；若受阻，按规则触发异构执行模型轮换重试或上报 L1。
"@ | Write-Output
        }
        elseif ($hasSpec) {
            Write-Host "目标层级 : L3 执行层 (Worker) | 推荐模型 : GLM-5.3 / Deepseek-V4.1-Flash" -ForegroundColor Green
            Write-Host "------------------- 请复制以下内容到目标 Harness 新 Session -------------------" -ForegroundColor Yellow
            @"
@al3 $TaskId
你当前处于 Personal Agent Layers 架构的【L3 执行层 (Worker)】会话，绑定任务：$TaskId。
若当前 Harness 未自动激活 al3-worker 技能，请立即依次执行：
1. 读取仓库根目录的 ``AGENTS.md``、``.agent-layers/model-layers.md`` 与 ``.agents/skills/al3-worker/SKILL.md`` 完成层级握手自检；
2. 遵循【Inline-or-Never】铁律：仅允许读取 ``.agent-layers/L3-execution/$TaskId/spec.md``（及同目录已有的 ``worker-report.md``）；严禁读取或搜索 ``L1-decision/``、``L2-dispatch/``、``L2-internal/`` 或其他任务目录；
3. 严格在 ``spec.md`` 第 1 节声明的【允许操作的文件白名单】范围内修改源码，并运行第 4 节指定的验证命令；
4. 将本次执行结果与真实终端输出追加写入 ``.agent-layers/L3-execution/$TaskId/worker-report.md``，完成后输出指向 ``@al2b $TaskId`` 的转接卡。
"@ | Write-Output
        }
        elseif ($hasDraft) {
            Write-Host "目标层级 : L2b 调度层·方案审校 (Mode A) | 推荐模型 : Gemini-4-Argon / Claude Sonnet 5.5" -ForegroundColor Green
            Write-Host "------------------- 请复制以下内容到目标 Harness 新 Session -------------------" -ForegroundColor Yellow
            @"
@al2b $TaskId
你当前处于 Personal Agent Layers 架构的【L2b 调度层·审校与蒸馏 (Mode A: Pre-Execution Review)】会话，绑定任务：$TaskId。
若当前 Harness 未自动激活 al2b-reviewer 技能，请立即依次执行：
1. 读取仓库根目录的 ``AGENTS.md``、``.agent-layers/model-layers.md`` 与 ``.agents/skills/al2b-reviewer/SKILL.md`` 完成层级握手自检；
2. 读取 ``.agent-layers/L1-decision/01-charter-and-specs.md``、``.agent-layers/L2-dispatch/$TaskId/mandate.md`` 与 ``.agent-layers/L2-internal/$TaskId/draft-plan.md``；
3. 严禁修改任何业务源码！在 ``.agent-layers/L2-internal/$TaskId/review-notes.md`` 追加审校记录，砍掉过度设计的废话与冗余枝蔓，生成 100% 自包含的 ``.agent-layers/L3-execution/$TaskId/spec.md``；
4. 完成后输出指向 ``L3 执行层 Worker (@al3 $TaskId)`` 的跨 Harness 手动转接卡。
"@ | Write-Output
        }
        elseif ($hasMandate) {
            Write-Host "目标层级 : L2a 调度层·方案主笔 (Drafter) | 推荐模型 : GPT-6.1-Sol" -ForegroundColor Green
            Write-Host "------------------- 请复制以下内容到目标 Harness 新 Session -------------------" -ForegroundColor Yellow
            @"
@al2a $TaskId
你当前处于 Personal Agent Layers 架构的【L2a 调度层·方案主笔 (Drafter)】会话，绑定任务：$TaskId。
若当前 Harness 未自动激活 al2a-drafter 技能，请立即依次执行：
1. 读取仓库根目录的 ``AGENTS.md``、``.agent-layers/model-layers.md`` 与 ``.agents/skills/al2a-drafter/SKILL.md`` 完成层级握手自检；
2. 仅读取 ``.agent-layers/L1-decision/01-charter-and-specs.md`` 与 ``.agent-layers/L2-dispatch/$TaskId/mandate.md``（及若存在的 ``L2-internal/$TaskId/review-notes.md``）；
3. 对相关项目业务源码进行只读调研（严禁修改任何业务源码文件，严禁跨层调用 subagent）；
4. 将完整技术方案初稿与防御性边界排查写入 ``.agent-layers/L2-internal/$TaskId/draft-plan.md``，完成后输出指向 ``@al2b $TaskId`` 的转接卡。
"@ | Write-Output
        }
        else {
            Write-Host "任务 [$TaskId] 尚未生成 mandate.md，请先在 L1 决策层 (@al1) 完成任务委派书撰写。" -ForegroundColor Red
        }
    }
}
