---
name: wiki-log
description: 當任何專案的程式代理工作產生值得記住的內容時使用，例如解決反覆問題、發現環境特性、做出設計決策或長時間除錯；使用者說「記錄到 Wiki」或同意記錄建議時也使用。
---

# 工作記錄 → Wiki

## 找到 Vault

依序讀取工作階段中的 `myllm-wiki Vault:`、`~/.claude/myllm-wiki/vault-path` 第一行，或確認目前目錄有 `AGENTS.md`（或 `CLAUDE.md`）與 `wiki/index.md`。都找不到時停止並建議 `wiki-init`。所有路徑都使用絕對路徑。

## 核心原則

**不論在哪個專案工作，記錄都集中到同一個 Vault。**

## 判斷是否值得記錄

| 記錄 | 不記錄 |
|---|---|
| 解決可重現的問題 | 簡單查詢、一次性命令 |
| 發現此環境特性 | 程式碼、文件已記載的內容 |
| 做出設計決策 | Git 歷史已記錄的內容 |
| 長時間摸索或除錯 | 沒有結論的探索 |

若不確定，檢查是否有「未採用的替代方案及原因」；有的話通常值得記錄。

## 流程

### 1. 建立記錄頁面

建立 `<VAULT>/wiki/sessions/YYYY-MM-DD-<標題>.md`。標題保留原文，空格改為連字號；`domain` 依 `<VAULT>/AGENTS.md` 允許值。

```yaml
---
type: session
domain: work
project: my-service
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [git, ssh]
sources: []
status: stable
---
```

正文不可省略第三節：

```markdown
## 做了什麼、為什麼
## 結果
## 得知的事項
## 後續工作
```

「得知的事項」必須寫出重現條件與判別方法，例如「若 `git push` 輸出出現 `To https://`，表示全域 insteadOf 規則攔截了 SSH」。

### 2. 更新 index.md

在 `<VAULT>/wiki/index.md` 的 `## Sessions` 下加入：

```markdown
- [[YYYY-MM-DD-GitHub-SSH-連線]] — insteadOf 規則將 SSH 導向 HTTPS 的陷阱
```

### 3. 更新 log.md

在 `<VAULT>/wiki/log.md` 底部加入：

```markdown
## [YYYY-MM-DD] session | <工作標題>

<2–3 行摘要>
```

### 4. 連結相關頁面

若記錄中的實體或概念頁面已存在，加入 `[[連結]]`。若尚未存在但可能反覆出現，只提出建議，不要為每次工作大量建立頁面。

### 5. 提交

若 Vault 是 Git 儲存庫，執行：

```bash
cd "<VAULT>" && git add wiki/ && git commit -m "session: <工作標題>"
```

設定遠端時可再執行 `git push`；失敗時回報即可。

## 常見錯誤

| 錯誤 | 結果 |
|---|---|
| 留白「得知的事項」 | 日後閱讀沒有用途 |
| 只列出發生了什麼 | 沒有重現條件，無法重用 |
| 不記錄未採用方案 | 未來會重複評估同一方案 |
| 忘記更新 `index.md` | 查詢時找不到 |
| 連瑣碎工作也記錄 | 訊噪比下降 |
| 使用相對路徑 | 從 Vault 外呼叫時會寫錯位置 |
