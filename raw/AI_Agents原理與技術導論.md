# AI Agents 原理、架構與技術導論 —— 原始核心文獻

本文件為 AI Agents 專題知識庫之 Layer 1 原始文獻存檔，收錄 AI Agent（人工智慧代理人）核心架構、工作循環（Loop/Graph）、工具調用（Tool Calling）、記憶機制與多代理協作之核心理論。

---

## 第一章：什麼是 AI Agent？（核心定義與本質躍遷）
1. **定義**：AI Agent（人工智慧代理人／智慧體）是指以大型語言模型（LLM）為核心認知大腦，具備「自主目標設定、環境感知、邏輯規劃、記憶存取與工具調用」能力，能夠在給定目標下自主完成複雜多步驟任務的智慧系統。
2. **與傳統 Chatbot 的本質差異**：
   - 傳統 Chatbot（如純 ChatGPT）：單純的「輸入-輸出」對話生成器，沒有工具調用權限，缺乏跨回合的主動行動力與環境互動反饋。
   - AI Agent：具備「行動實體（Agency）」，能夠主動執行搜尋、寫入檔案、調用 API、自我檢查並根據執行結果修正行動策略。
3. **Agent 四大核心組件（Weng, 2023 經典架構）**：
   - **大腦（Brain / Planning）**：LLM 負責語意理解、拆解子目標、自我反思與決策。
   - **感官（Perception / Sensors）**：接收使用者指令、環境即時反饋、工具返回數據。
   - **記憶（Memory）**：
     - 短期記憶：當前對話上下文（In-context Learning）。
     - 長期記憶：向量資料庫（RAG）或結構化外部知識庫（LLM Wiki）。
   - **雙手（Action / Tools）**：終端機執行、網路搜尋、檔案讀寫、計算器、外部 API 接口。

---

## 第二章：AI Agent 的工作循環（Loop & Graph）
1. **自主行動循環（Sense-Plan-Act-Reflect Loop）**：
   - Agent 不會一次性輸出答案，而是進入持續的自主循環：
     `感知環境 ➔ 評估現狀 ➔ 制定計畫 ➔ 選擇工具 ➔ 執行動作 ➔ 觀察結果 ➔ 反思修正`
   - 循環終止條件：達成預設目標或達到最大安全反覆次數。
2. **ReAct 框架（Reasoning + Acting, Yao et al., 2022）**：
   - 結合「思考（Thought）」與「行動（Action）」的協同模式：
     - Thought 1：分析當前已知與未知。
     - Action 1：調用工具取得缺失數據。
     - Observation 1：讀取工具輸出。
     - Thought 2：根據觀察結果推論下一步。
     - Action 2：產出最終結果或進行下一步。
3. **自我反思（Reflexion, Shinn et al., 2023）**：
   - 當行動失敗或遇到錯誤時，Agent 會閱讀錯誤訊息，在記憶中記錄「此路不通的原因」，動態切換策略重新嘗試。
4. **Graph 架構（StateGraph / LangGraph）**：
   - 將 Agent 的工作流建模為有向圖（Directed Graph）：節點（Node）代表動作或思考，邊（Edge）代表條件判斷與狀態流轉，支援複雜的分支、循環與人機協同（Human-in-the-loop）。

---

## 第三章：工具調用（Tool Calling / Function Calling）與 MCP
1. **工具調用的運作原理**：
   - LLM 本身無法聯網或修改硬碟，但能輸出特定的結構化 JSON 代碼（包含函數名稱與參數）。
   - 外部執行環境執行該代碼後，將執行結果（Observation）回傳給 LLM 繼續推論。
2. **模型上下文協議（MCP, Model Context Protocol）**：
   - Anthropic 於 2024 年提出之開源開放標準，將 LLM 與資料庫、開發工具、商業系統以標準化協議無縫串接，成為 Agent 工具生態系通用語言。

---

## 第四章：多代理人協作系統（Multi-Agent Systems & Swarms）
1. **單一 Agent 的瓶頸**：上下文膨脹、注意力分散、角色混淆。
2. **多代理人協作優勢**：
   - **角色專業化（Role Specialization）**：劃分研究員（Researcher）、工程師（Coder）、審查員（Reviewer）。
   - **監督與制衡**：由協調者（Coordinator）分配任務，並由驗證代理人交叉檢驗品質。
3. **Swarm 模式**：
   - 多個輕量化 Worker 平行分散處理大規模子任務，彙整結果給協調者，達到高通量並行處理。

---

## 第五章：AI Agents 在教育現場與日常生活之革命性應用
1. **自適應智慧家教（Adaptive Intelligent Tutor）**：不僅給出答案，更根據學生理解歷程動態提供鷹架引導。
2. **個人知識管理管家（LLM Wiki Keeper）**：主動整理零散閱讀筆記，自動抽取實體、建立概念關聯圖譜與自測題目。
3. **工作流自動化**：將繁瑣的跨系統資料查詢、統計分析與簡報排版完全自動化交付。
