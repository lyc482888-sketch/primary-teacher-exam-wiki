---
title: AI_Agent工具調用與外部記憶
category: theories
subject: AI Agents
tags: [AI Agents, 工具調用, Function Calling, MCP, 外部記憶, LLM Wiki, 必考]
aliases: [Tool Calling, MCP, 模型上下文協議, 外部記憶體系, 長期記憶]
last_updated: 2026-11-23
---

# AI Agent 工具調用與外部記憶

## 一句話定位
> 工具調用（Tool Calling）賦予 AI Agent 操作真實世界的「雙手」，而外部記憶（Memory / LLM Wiki）則突破了模型上下文視窗的限制，使其具備持續累積終身知識的「外接大腦」。

---

## 一、 工具調用（Tool Calling / Function Calling）原理

大型語言模型本身只是純粹的數學權重矩陣，無法直接操控電腦檔案或瀏覽即時網路。工具調用是透過以下四步精巧設計達成的：

1. **工具聲明（Schema Registration）**：
   在對話開始前，系統以 JSON Schema 向模型描述可用的工具名稱、功能說明與所需參數（例如：`read_file(Path)`、`run_command(CommandLine)`）。
2. **模型生成調用語意（Function Call Generation）**：
   當模型判斷需要外力輔助時，不再輸出自然語言文字，而是輸出結構化的調用指令（如：`call: read_file { Path: "data.txt" }`）。
3. **外部環境執行（Execution by Host）**：
   受控的宿主環境（Host）截獲該調用指令，在沙盒或系統中真實執行，取得真實輸出或錯誤訊息。
4. **結果注入與續寫（Observation Injection）**：
   宿主將真實執行結果包裝為「Observation」回傳給模型，模型閱讀結果後繼續進行下一步決策。

---

## 二、 模型上下文協議（MCP, Model Context Protocol）

由 Anthropic 於 2024 年底提出並開源，被譽為「AI 時代的 USB Type-C」標準：

| 傳統工具對接模式 | MCP 標準化生態 |
| :--- | :--- |
| 每個 LLM 廠商、每個開發框架都有自己專屬的 Function 格式，開發者必須為每一套系統重寫接口。 | **統一開放協定**：將資料庫、檔案系統、搜尋引擎與第三方軟體標準化為 MCP Server。 |
| 碎片化、難以跨工具遷移。 | 任何相容 MCP 的 Agent（如 Claude、Cursor、Antigravity）皆可隨插即用海量現成工具。 |

---

## 三、 Agent 記憶系統階層架構

| 記憶類型 | 技術實現方式 | 保存時限 | 特性與教甄比喻 |
| :--- | :--- | :--- | :--- |
| **工作記憶**<br>(Working Memory) | 模型當前上下文視窗（Context Window）。 | 單次回合（Turn）結束即清空。 | 如同人類大腦正在思考的當下念頭，速度最快但容量極為有限。 |
| **短期記憶**<br>(Short-Term Memory) | 對話歷史紀錄（Transcript / Chat History）。 | 整個對話 Session 期間。 | 類似會議記錄，隨著對話增長會面臨上下文膨脹與遺忘問題。 |
| **長期記憶**<br>(Long-Term Memory) | **向量資料庫（RAG）或結構化外部知識庫（LLM Wiki）**。 | 永久保存於磁碟。 | 突破 token 限制，以文件、超連結與標籤交織沉澱長效知識。 |

---

## 四、 相關概念與延伸連結
- 架構基礎：[[AI_Agents核心定義與架構]]
- 決策推演：[[AI_Agent思考循環與決策Loop]]
- 應用實例：[[AI_Agents在教學與日常實務應用]]

---

## 出處與參考來源
- 來源文獻：OpenAI (2023) *Function Calling and Other API Updates*
- 官方標準：Anthropic (2024) *Introducing the Model Context Protocol (MCP)*
