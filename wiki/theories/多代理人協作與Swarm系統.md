---
title: 多代理人協作與Swarm系統
category: theories
subject: AI Agents
tags: [AI Agents, 多代理人, Multi-Agent, Swarm, 協同工作流, 必考]
aliases: [Multi-Agent Systems, Swarm, 蜂群模式, 角色分工, 子代理人, Coordinator]
last_updated: 2026-11-23
---

# 多代理人協作與 Swarm 系統

## 一句話定位
> 當任務規模超越單一 Agent 的注意力極限時，「多代理人協作（Multi-Agent Systems, MAS）」與「Swarm 蜂群系統」透過專業分工、同儕審查與平行運算，實現超越個別 Agent 總和的群體智慧。

---

## 一、 為什麼需要多代理人（Multi-Agent）？

1. **對抗「上下文膨脹（Context Bloat）」**：
   單一 Agent 面對數萬行代碼或數百頁講義時，長文本會導致模型「迷失在中間（Lost in the middle）」，遺忘早期細節。
2. **避免「認知負荷過載（Cognitive Overload）」**：
   讓同一個 Agent 同時擔任「寫作者」、「編譯員」與「最苛刻的評審員」，模型往往產生嚴重的自信偏見，無法客觀抓錯。
3. **專業角色化（Role Specialization）**：
   賦予不同 Agent 專屬的 System Prompt，各自專注於特定微觀領域，發揮最大專業深度。

---

## 二、 經典多代理人拓撲結構（Topologies）

| 架構模式 | 結構特徵與運作機制 | 典型應用場景 | 優缺點評估 |
| :--- | :--- | :--- | :--- |
| **階層主從模式**<br>(Hierarchical / Router) | 一位「協調者（Coordinator）」負責拆解任務，分派給多個具備專屬能力的子代理人（Subagents），並彙整最終成果。 | 複雜專案開發、深度資料調研、大型知識庫建構。 | **優點**：邏輯條理極度清晰，容錯率高。<br>**缺點**：協調者決策若有偏差容易形成瓶頸。 |
| **管道流水線模式**<br>(Pipeline / Sequential) | 代理人 A 的輸出直接作為代理人 B 的輸入，如同工廠裝配線逐層加工。 | 文本生成 ➔ 格式審查 ➔ 代碼執行 ➔ 自動發布。 | **優點**：流程高度確定，易於監控。<br>**缺點**：前置節點出錯會骨牌式傳遞至後續節點。 |
| **同儕辯論模式**<br>(Peer Debate) | 兩個或多個觀點互斥的代理人針對問題展開多輪質詢與辯論，由裁判代理人給出最終定案。 | 爭議性概念辨析、代碼安全審查、邏輯漏洞抓漏。 | **優點**：能大幅降低幻覺率。<br>**缺點**：Token 消耗量倍增，延遲較高。 |
| **Swarm 蜂群並行模式**<br>(Worker Swarms) | 協調者一口氣派出數十個輕量同質的 Worker，平行處理不同分片資料（Shards），再快速彙總。 | 批次處理 100 份學生作業、多模組獨立單元測試。 | **優點**：執行速度極快，大幅縮短端到端等待時間。 |

---

## 三、 國小現場教育隱喻：合作學習模式

多代理人架構在教育學上的完美對應就是**「合作學習（Cooperative Learning）」**：
- **異質分組**：研究型 Agent（蒐集文獻）+ 統整型 Agent（整理重點）+ 視覺型 Agent（排版簡報）。
- **正面互賴（Positive Interdependence）**：各代理人各司其職，缺一不可。
- **個人績效責任**：每個子代理人必須對其輸出的真實性負責，接受同儕驗證。

---

## 四、 相關概念與延伸連結
- 核心架構：[[AI_Agents核心定義與架構]]
- 工作閉環：[[AI_Agent思考循環與決策Loop]]
- 實踐案例：[[AI_Agents在教學與日常實務應用]]

---

## 出處與參考來源
- 來源文獻：Wu et al. (2023) *AutoGen: Enabling Next-Gen LLM Applications via Multi-Agent Conversation*
- 來源文獻：Hong et al. (2023) *MetaGPT: Meta Programming for A Multi-Agent Collaborative Framework*
