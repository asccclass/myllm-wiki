# llm-wiki — 由 LLM 管理的知識 Wiki

供 AI 程式碼代理（Claude Code、Codex）管理 Obsidian Vault 的個人知識 Wiki 外掛。它會在匯入資料時讀取內容，整合至既有頁面，建立交叉連結並保留來源；也能在不同專案之間集中記錄值得重用的工作經驗。

## 為什麼不是 RAG

每次提問才搜尋檔案的 RAG，往往都要重新拼湊知識；本 Wiki 會在資料加入時整合既有頁面，讓概念與實體頁面逐步累積、標記矛盾，並把高品質答案寫回 Wiki。

| 工作 | 負責者 |
|---|---|
| 蒐集資料、決定方向、提問 | 人 |
| 摘要、交叉引用、分類、標記矛盾、維護紀錄 | LLM |
| 閱讀與探索（圖譜、反向連結） | Obsidian |

## 內容

| Skill | 用途 |
|---|---|
| `wiki-init` | 建立新的 Vault，或註冊既有 Vault 路徑 |
| `wiki-ingest` | 將 `raw/<領域>/` 中的資料整合至 Wiki |
| `wiki-query` | 先讀索引與相關頁面，帶來源查詢 Wiki |
| `wiki-lint` | 檢查 Wiki 健康狀態（矛盾、孤立頁面、失效連結等） |
| `wiki-log` | 將跨專案的問題、設計決策與環境陷阱記錄到共用 Vault |

SessionStart 會注入「工作前先參考 Wiki、工作後先建議記錄」的規則；PreCompact 會在內容壓縮前提醒記錄重要工作。安裝外掛並執行 `wiki-init` 後即可使用。

## 安裝

Claude Code：

```text
/plugin marketplace add DHKIM0207/llm-wiki-kit
/plugin install llm-wiki@llm-wiki-kit
```

Codex CLI：

```bash
codex plugin marketplace add DHKIM0207/llm-wiki-kit
codex plugin add llm-wiki@llm-wiki-kit
codex plugin list
```

接著開啟新工作階段並輸入「建立 LLM Wiki」。`wiki-init` 會詢問 Vault 絕對路徑、名稱與領域，建立骨架並註冊路徑。若目標資料夾已存在且非空，初始化會停止，不會覆蓋既有檔案。

Codex 使用者需在取得授權後，將替換 Vault 路徑後的 `hooks/wiki-rules.md` 內容加入 `~/.codex/AGENTS.md`；Claude Code 則由 SessionStart Hook 自動注入規則。

## Vault 結構

```text
raw/<domain>/   原始資料（由人管理，LLM 僅讀取；可不納入 git）
raw/assets/     原始資料使用的附件
wiki/sources/   每份資料的摘要與原始路徑
wiki/entities/  人、組織、設備、系統、產品
wiki/concepts/  技術、概念、方法論
wiki/syntheses/ 多份資料整合後的結論
wiki/sessions/ 代理工作紀錄
wiki/ideas/     待開發與改善項目
wiki/index.md   目錄，查詢時最先讀取
wiki/log.md     按時間排列的追加式紀錄
AGENTS.md       頁面格式與不可違反的規則
```

## 核心規則

- 一份資料通常會影響 10–15 個頁面；只放一份摘要不算完整 Wiki。
- 匯入前先讀取資料，並與使用者確認 3–5 個核心重點；只有使用者明確表示「自行處理」時才能跳過討論。
- `raw/` 由使用者管理；匯入流程不會自行移動或修改原始檔案。
- 不覆蓋矛盾；雙方標記 `status: contested`，交由人判定。
- 所有主張都必須有 `sources` 來源。
- 查詢時先讀 `wiki/index.md`，沿著頁面連結與 `sources` 深入一層；回答中的主張附上 Wiki 頁面來源。
- 高品質答案應回寫到 `syntheses/`。
- 工作記錄建立在 `wiki/sessions/YYYY-MM-DD-<標題>.md`，且必須包含「做了什麼、為什麼」「結果」「得知的事項」「後續工作」。
- 檢查報告只修正明確的機械性問題，不擅自刪除或替人判斷。

## 設定

`~/.claude/llm-wiki/vault-path` 儲存 Vault 的絕對路徑；若設定 `LLM_WIKI_VAULT` 環境變數，則以環境變數優先。若使用 `CLAUDE_CONFIG_DIR`，路徑檔案位於該設定目錄下。搬移 Vault 時修改路徑檔案，或更新環境變數即可。

建議搭配 Obsidian、`obsidian-git` 與 `dataview`。Windows 使用 Git Bash 執行 Shell 範例。
