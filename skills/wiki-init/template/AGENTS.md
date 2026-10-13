# {{VAULT_NAME}} — LLM 管理的知識庫

此儲存庫是 Obsidian Vault，也是由 LLM 管理的 Wiki。本檔案定義結構、頁面格式與不可違反的規則；流程由 `myllm-wiki` 外掛 Skill 負責。`CLAUDE.md` 只匯入本檔案。

## 分工與結構

LLM 寫入 Wiki，使用者蒐集資料、決定方向並提問。`raw/` 由使用者管理、不可修改且不提交 Git；`wiki/` 由 LLM 建立與更新；`AGENTS.md` 由雙方共同維護。

```text
raw/{{DOMAIN_DIRS}}/   原始資料
raw/assets/            圖片附件
wiki/sources/          資料摘要
wiki/entities/         人、組織、設備、系統、產品
wiki/concepts/         技術、概念、方法論
wiki/syntheses/        綜合結論
wiki/sessions/         工作記錄
wiki/ideas/            開發與改善項目
wiki/index.md          內容目錄
wiki/log.md            追加式紀錄
```

Wiki 依類型而非領域分資料夾；領域只放在 frontmatter 的 `domain`，以便跨領域連結。

## Skill 分工

`wiki-ingest` 匯入資料；`wiki-query` 查詢；`wiki-lint` 檢查健康狀態；`wiki-log` 記錄其他專案工作。

## 頁面格式

所有 Wiki 頁面都必須包含 `type`、`domain`、`created`、`updated`、`tags`、`sources` 與 `status`：

```yaml
---
type: source | entity | concept | synthesis | session | idea
domain: {{DOMAINS}}
created: 2026-01-01
updated: 2026-01-01
tags: [範例, 標籤]
sources: ["[[資料摘要]]"]
status: draft | stable | contested
---
```

`sources` 不可留空；`contested` 表示與其他頁面矛盾；每次修改都更新 `updated`。`idea` 另需 `targets`、`stage` 與 `priority`。

## 類型骨架

`source`：出處、日期、原始路徑、核心重點、Wiki 連結。

`entity`：定義、屬性、出現紀錄、相關實體。

`concept`：定義、在本情境的意義、相關概念、來源。

`synthesis`：論點、支持證據、反方證據、未解問題。

`session`：做了什麼與原因、結果、學到什麼、後續工作。

`idea`：目前狀態、問題、提案、考量。

## 不可違反的規則

1. 不修改 `raw/`。
2. 所有主張都必須能由 `sources` 追溯。
3. 發現矛盾時雙方標記 `contested` 並寫明衝突。
4. 修改 Wiki 後一定更新 `index.md` 與 `log.md`。
5. 不把推測寫成事實；不確定時明確標示。

## log.md 格式

```text
## [2026-01-01] ingest | <資料標題>
## [2026-01-01] session | <工作標題>
## [2026-01-02] lint | 整理 3 個孤立頁面
## [2026-01-02] query | <問題摘要> → syntheses/<頁面>
```
