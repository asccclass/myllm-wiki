---
name: wiki-init
description: 當使用者想要建立新的 LLM Wiki Vault（保管庫）、首次設定 llm-wiki 外掛程式，或連結現有 Vault 時使用 — 例如「幫我建立 Wiki」、「啟動 LLM Wiki」、「初始化 Vault」、「設定 Wiki 路徑」。當其他 Wiki Skill 找不到 Vault 路徑時也可使用。
---

# Wiki 初始化 (Init)

## 核心原則

**建立 Vault 骨架，並將 Vault 路徑註冊到單一檔案中。**
路徑檔案：`~/.claude/llm-wiki/vault-path`（若使用 `CLAUDE_CONFIG_DIR`，則位於其下方）。內容為一行絕對路徑。

外掛程式的 SessionStart Hook 在每個工作階段（Session）都會讀取此檔案，將 Vault 路徑與「優先參考／優先建議記錄」規則（`hooks/wiki-rules.md`）載入至 Context 中。**請勿動到全域的 CLAUDE.md。**

範本位於此 Skill 目錄下的 `template/`（以載入 Skill 時顯示的 base directory 為準）。
規則原文位於外掛程式根目錄的 `hooks/wiki-rules.md` — 即 base directory 中的 `../../hooks/wiki-rules.md`。

## 執行流程

### 1. 詢問三項資訊（一次性詢問）

- **Vault 位置** — 絕對路徑。例如：`C:\Users\<me>\Documents\my-wiki`、`~/my-wiki`
- **Vault 名稱** — 預設為資料夾名稱
- **領域 (Domain)** — 用於 Frontmatter 中 `domain` 欄位的值。預設值為 `work, personal, research`。
  因人而異（例如新增 `rnd`）。日後可在 `AGENTS.md` 中修改。

如果只是要連結現有的 Vault（已有 `wiki/index.md`），請跳過步驟 2~3，直接進行步驟 4。

### 2. 確認目標 — 切勿覆蓋

若目標資料夾已存在且非空白，**請停止並向使用者顯示狀態。**
若是將 Wiki 疊加在現有的 Obsidian Vault 上，僅需向使用者確認有衝突的檔案（`AGENTS.md`、`CLAUDE.md`、`wiki/`）。
切勿直接覆蓋任何檔案。

### 3. 複製範本

將 `template/` 完整複製到目標位置，並執行以下操作：

- 將 `gitignore` 重命名為 `.gitignore`（為避免外掛程式內的 Git 規則生效，原本以無點號方式儲存）
- 替換變數：`{{VAULT_NAME}}`、`{{TODAY}}` (YYYY-MM-DD)、`{{DOMAINS}}`（格式如 `work | personal | research`）、`{{DOMAIN_DIRS}}`（格式如 `{work,personal,research}`）
- 建立 `raw/` 及其各領域子資料夾，以及 `raw/assets/`

詢問是否使用 Git，若同意則執行 `git init` 並完成首次 Commit。**遠端連結與 Push 需由使用者自行操作。**

### 4. 註冊路徑

在 `~/.claude/llm-wiki/vault-path` 中寫入一行 Vault 的絕對路徑（若資料夾不存在請建立）。
若檔案已存在，則顯示現有路徑並詢問是否變更。

- 此檔案是規則注入的開關。若不存在，Hook 僅會顯示「Vault 未設定」提示，且優先參考／優先建議功能將無法運作。
- 若全域 CLAUDE.md 中已有 `## LLM Wiki` 章節或類似的 Wiki 規則，請告知使用者**這會與 Hook 重複**，由使用者決定是否刪除。
- 若使用者為 Codex 使用者，外掛程式 Hook 可能無法在 Codex 中執行 — 請在**取得授權後**，將替換完 `{{VAULT_PATH}}` 的 `hooks/wiki-rules.md` 內容加入至 `~/.codex/AGENTS.md` 中。

### 5. 使用說明

- 在 Obsidian 中開啟 Vault 資料夾（「將資料夾作為儲存庫開啟」）
- 建議外掛程式：`obsidian-git`、`dataview`
- 首次使用：將資料放入 `raw/<領域>/` 中，並輸入「幫我把這個放到 Wiki」→ `wiki-ingest`
- **自下一個工作階段起** Hook 將自動注入規則（當前工作階段執行 `/clear` 即可）

## 常見失敗情境

| 失敗原因 | 結果 |
|---|---|
| 直接複製到現有資料夾 | 覆蓋使用者的筆記 |
| 漏掉註冊路徑檔案 | 其他 Skill 找不到 Vault，且無法觸發優先建議與參考 |
| 在全域 CLAUDE.md 重複新增規則 | 與 Hook 產生重複注入 |
| 未重命名 `gitignore` | `raw/` 被提交至 Git，導致原始文件外洩 |
| 使用相對路徑註冊 | 在其他專案中會指向錯誤的位置 |