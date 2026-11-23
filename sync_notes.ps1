# ========================================================
# 國小教甄 LLM Wiki - 筆記自動同步腳本 (sync_notes.ps1)
# 執行方式：在 PowerShell 執行 .\sync_notes.ps1
# 功能：自動掃描 wiki/ 目錄所有 Markdown 與投影片，將全文與中繼資料打包至 data/notes.js
# ========================================================

$ErrorActionPreference = "SilentlyContinue"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

Write-Host "🔍 開始掃描 wiki/ 目錄檔案..." -ForegroundColor Cyan

$WikiDir = Join-Path $ScriptDir "wiki"
$DataDir = Join-Path $ScriptDir "data"
if (-not (Test-Path $DataDir)) {
    New-Item -ItemType Directory -Path $DataDir -Force | Out-Null
}

$CategoryMap = @{
    "scholars" = "學者人物";
    "theories" = "核心理論";
    "curriculum" = "課程教學";
    "administration" = "教育行政";
    "comparisons" = "橫向對照";
    "exam_traps" = "考點題眼";
    "slides" = "精選簡報"
}

$NotesList = @()

# 掃描 wiki 內的 Markdown 檔案
$MdFiles = Get-ChildItem -Path $WikiDir -Recurse -Filter "*.md" | Where-Object { $_.FullName -notmatch "\\\.obsidian\\" }

foreach ($file in $MdFiles) {
    $relativePath = $file.FullName.Substring($ScriptDir.Length).TrimStart("\/").Replace("\", "/")
    $rawText = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $lines = $rawText -split "`r?`n"
    
    # 提取 YAML Frontmatter 與正文
    $inYaml = $false
    $yamlLines = @()
    $bodyLines = @()
    
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($i -eq 0 -and $line.Trim() -eq "---") {
            $inYaml = $true
            continue
        }
        if ($inYaml) {
            if ($line.Trim() -eq "---") {
                $inYaml = $false
                continue
            }
            $yamlLines += $line
        } else {
            $bodyLines += $line
        }
    }
    
    $cleanBody = ($bodyLines -join "`n").Trim()
    
    $title = $file.BaseName
    $categoryKey = $file.Directory.Name
    $date = (Get-Date -Date $file.LastWriteTime -Format "yyyy-MM-dd")
    $tags = @("國小教甄")
    $aliases = @()
    $summary = ""
    $subject = "教育社會學" # 預設大科目
    $hasExplicitSubject = $false
    
    foreach ($y in $yamlLines) {
        if ($y -match "^title:\s*(.+)$") { $title = $matches[1].Trim().Trim('"').Trim("'") }
        if ($y -match "^subject:\s*(.+)$") { 
            $subject = $matches[1].Trim().Trim('"').Trim("'")
            if ($subject -eq "教育測驗與評量") { $subject = "測驗與評量" }
            $hasExplicitSubject = $true 
        }
        if ($y -match "^category:\s*(.+)$") { $categoryKey = $matches[1].Trim().Trim('"').Trim("'") }
        if ($y -match "^last_updated:\s*(.+)$") { $date = $matches[1].Trim().Trim('"').Trim("'") }
        if ($y -match "^tags:\s*\[(.+)\]$") { 
            $tags = $matches[1].Split(",") | ForEach-Object { $_.Trim().Trim("'`"") } | Where-Object { $_ -ne "" }
        }
        if ($y -match "^aliases:\s*\[(.+)\]$") { 
            $aliases = $matches[1].Split(",") | ForEach-Object { $_.Trim().Trim("'`"") } | Where-Object { $_ -ne "" }
        }
    }
    
    # 若無在 YAML 明確指定 subject，則自動依路徑或標籤識別大考科
    if (-not $hasExplicitSubject) {
        if ($categoryKey -eq "administration" -or $relativePath -match "administration" -or $tags -contains "教育行政" -or $tags -contains "法規") {
            $subject = "教育行政與法規"
        } elseif ($tags -contains "教育人物" -or $tags -contains "教育哲學" -or $tags -contains "教育思想") {
            $subject = "教育人物與哲學"
        } elseif ($tags -contains "輔導原理" -or $tags -contains "輔導" -or $tags -contains "諮商" -or $tags -contains "青少年發展") {
            $subject = "輔導原理與實務"
        } elseif ($tags -contains "測驗與評量" -or $tags -contains "教育測驗與評量" -or $tags -contains "測驗" -or $tags -contains "評量") {
            $subject = "測驗與評量"
        } elseif ($tags -contains "AI Agents" -or $tags -contains "Agent" -or $tags -contains "人工智慧") {
            $subject = "AI Agents"
        }
    }
    
    # 提取摘要（優先讀取 blockquote，若無則抓正文有意義的第一段）
    foreach ($b in $bodyLines) {
        $trimmed = $b.Trim()
        if ($trimmed -match "^>\s*(.+)$") {
            $summary = $matches[1].Trim().Replace("**", "").Replace("[[", "").Replace("]]", "").Replace("<br>", " ")
            break
        } elseif ($summary -eq "" -and $trimmed -ne "" -and -not ($trimmed.StartsWith("#")) -and -not ($trimmed.StartsWith("- 講師")) -and -not ($trimmed.StartsWith("- 主講"))) {
            $candidate = $trimmed.Replace("**", "").Replace("[[", "").Replace("]]", "").Replace("<br>", " ")
            if ($candidate.Length -gt 15) {
                $summary = $candidate
                if ($summary.Length -gt 120) { $summary = $summary.Substring(0, 120) + "..." }
                break
            }
        }
    }
    if ($summary -eq "") { 
        $summary = "收錄於國小教甄知識庫之精選教育專業筆記與核心考點解析。" 
    }
    
    $categoryName = if ($CategoryMap.ContainsKey($categoryKey)) { $CategoryMap[$categoryKey] } else { $categoryKey }
    
    # 確保內文乾淨無遺留轉義符
    $cleanBody = $cleanBody.Replace("\u003c", "<").Replace("\u003e", ">")

    $noteObj = [PSCustomObject]@{
        id = ($categoryKey + "-" + [System.IO.Path]::GetFileNameWithoutExtension($file.Name));
        title = $title;
        subject = $subject;
        category = $categoryName;
        categoryKey = $categoryKey;
        date = $date;
        summary = $summary;
        tags = $tags;
        aliases = $aliases;
        path = $relativePath;
        type = "markdown";
        content = $cleanBody
    }
    
    # 檢查是否有同名的 HTML 投影片
    $htmlSlidePath = [System.IO.Path]::ChangeExtension($file.FullName, ".html")
    if (Test-Path $htmlSlidePath) {
        $noteObj.type = "html_slide"
        $noteObj | Add-Member -MemberType NoteProperty -Name "slideUrl" -Value ($relativePath.Replace(".md", ".html"))
    }
    
    $NotesList += $noteObj
}

# 輸出成 JS 格式（供外部引入）
$JsonData = $NotesList | ConvertTo-Json -Depth 5 -Compress
$JsContent = "// 國小教甄 LLM Wiki 知識庫資料 - 自動同步產生（含全文內容，無須 fetch 避免 CORS 限制）`r`nwindow.NOTES_DATA = $JsonData;`r`n"
Set-Content -Path (Join-Path $DataDir "notes.js") -Value $JsContent -Encoding UTF8

# 同步嵌入 index.html 內部（確保單檔離線雙擊時 100% 絕對可用，無任何路徑或 CORS 問題）
$IndexPath = Join-Path $ScriptDir "index.html"
if (Test-Path $IndexPath) {
    $IndexContent = [System.IO.File]::ReadAllText($IndexPath, [System.Text.Encoding]::UTF8)
    $startTag = "// === EMBEDDED_DATA_START ==="
    $endTag = "// === EMBEDDED_DATA_END ==="
    $startIndex = $IndexContent.IndexOf($startTag)
    $endIndex = $IndexContent.LastIndexOf($endTag)
    if ($startIndex -ge 0 -and $endIndex -gt $startIndex) {
        $before = $IndexContent.Substring(0, $startIndex + $startTag.Length)
        $after = $IndexContent.Substring($endIndex)
        $UpdatedIndex = $before + "`r`nwindow.NOTES_DATA = " + $JsonData + ";`r`n" + $after
        [System.IO.File]::WriteAllText($IndexPath, $UpdatedIndex, [System.Text.Encoding]::UTF8)
        Write-Host "✅ 已同步將最新資料內嵌至 index.html！" -ForegroundColor Green
    }
}

Write-Host "✅ 成功同步 $($NotesList.Count) 篇筆記（含完整全文）至 data/notes.js 與 index.html！" -ForegroundColor Green
Write-Host "💡 本機開啟 index.html 將直接呈現完整內文，絕無任何 CORS 跨域阻擋！" -ForegroundColor Yellow
