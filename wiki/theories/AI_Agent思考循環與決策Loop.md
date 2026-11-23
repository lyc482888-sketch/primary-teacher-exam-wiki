---
title: AI_Agent思考循環與決策Loop
category: theories
subject: AI Agents
tags: [AI Agents, 決策Loop, ReAct框架, StateGraph, 自我反思, 必考]
aliases: [Agent Loop, ReAct, 反思機制, Reflexion, 決策循環, 代理人工作流]
last_updated: 2026-11-23
---

# AI Agent 思考循環與決策 Loop

## 一句話定位
> AI Agent 的精髓在於「閉環自主循環（Autonomous Loop）」；透過 ReAct（推理 + 行動）與 Reflexion（自我反思）機制，擺脫一次性生成的脆弱性，實現逐步逼近正確答案的強健執行力。

---

## 一、 自主行動循環（Sense-Plan-Act-Reflect Loop）

AI Agent 的生命週期是由一個持續旋轉的決策圖（Graph）所驅動：

| 階段名稱 | 核心動作 | 實例推演（以整理教甄筆記為例） |
| :---: | :--- | :--- |
| **1. 感知（Perceive）** | 接收使用者目標與目前環境狀態。 | 讀取使用者給予的 70 頁 PDF 與「編譯成 Wiki」之指令。 |
| **2. 規劃（Plan）** | 評估現狀、分解子目標、決定下一步。 | 規劃執行路徑：先萃取實體 ➔ 再生成詞條 ➔ 建立雙向連結。 |
| **3. 行動（Act）** | 選擇並調用對應的專屬工具。 | 調用 `read_file` 讀取資料，調用 `write_file` 寫入 Markdown。 |
| **4. 觀察（Observe）** | 讀取工具執行返回的真實數據或報錯。 | 讀取寫入結果或命令列終端反饋。 |
| **5. 反思（Reflect）** | 判斷目標是否達成；若失敗則分析原因更換策略。 | 發現字元編碼異常導致格式混亂，自主決定修正清理邏輯。 |

---

## 二、 經典 ReAct 框架（Reasoning + Acting）

由 Yao 等人於 2022 年提出，將「符號推理」與「物理行動」緊密編織在一起：

```text
[使用者目標：查詢某測驗題目難度 P 並評估品質]
      │
      ▼
Thought 1: 「我需要先知道高分組與低分組的答對率。」
Action 1:  call_tool: calculate_P(PH=0.8, PL=0.2)
Observation 1: 「P = 0.50」
      │
      ▼
Thought 2: 「難度為 0.50，屬於極優良難度區間。接著我需要檢查鑑別度。」
Action 2:  call_tool: calculate_D(PH=0.8, PL=0.2)
Observation 2: 「D = 0.60」
      │
      ▼
Thought 3: 「鑑別度 D=0.60 大於 0.40，兩項指標均屬頂尖，我已可給出結論。」
Final Answer: 「該題為難度適中且鑑別度極高之優良試題。」
```

---

## 三、 自我反思（Reflexion）與狀態圖（Graph）架構

### 1. Reflexion 機制（失敗為成功之母）
傳統程式碼一旦出錯就直接崩潰，AI Agent 則具備語意級容錯能力：
- 當 Action 產生錯誤訊息時，LLM 讀取報錯日誌（Traceback）。
- 於內在記憶中寫入「反思經驗」：*剛剛用 A 方法失敗是因為參數格式不對，下一次應改採 B 格式*。
- 自動推進下一次迭代，直到達成成功條件。

### 2. StateGraph（狀態圖流轉）
當代進階 Agent 框架（如 LangGraph）將工作流建模為**有向圖（DAG）**：
- **節點（Nodes）**：代表特定功能的專職智能體或工具（如：審查節點、編譯節點）。
- **邊（Edges）**：代表條件跳轉邏輯（`if 檢查未通過 ➔ 跳回修復節點；if 檢查通過 ➔ 跳往輸出節點`）。

---

## 四、 相關概念與延伸連結
- 核心架構：[[AI_Agents核心定義與架構]]
- 工具調用：[[AI_Agent工具調用與外部記憶]]
- 多機協同：[[多代理人協作與Swarm系統]]

---

## 出處與參考來源
- 來源文獻：Yao et al. (2022) *ReAct: Synergizing Reasoning and Acting in Language Models*
- 來源文獻：Shinn et al. (2023) *Reflexion: Language Agents with Verbal Reinforcement Learning*
