---
name: wiki-init
description: 當使用者要建立新的 LLM Wiki Vault、首次設定外掛或連結既有 Vault 時使用；其他 Wiki Skill 找不到 Vault 路徑時也使用。
---

# Wiki 初始化（Init）

建立 Vault 骨架，並將絕對路徑註冊至 `~/.claude/myllm-wiki/vault-path`。SessionStart Hook 會讀取它並注入規則；不要修改全域 `CLAUDE.md`。

## 流程

1. 詢問 Vault 絕對路徑、名稱與 `domain` 領域（預設 `work, personal, research`）。若已有 `wiki/index.md`，只連結既有 Vault。
2. 目標資料夾存在且非空時停止並顯示狀態；不可覆蓋既有檔案。
3. 複製 `template/`，將 `gitignore` 改名為 `.gitignore`，替換 `{{VAULT_NAME}}`、`{{TODAY}}`、`{{DOMAINS}}`、`{{DOMAIN_DIRS}}`，建立 `raw/`、領域子資料夾與 `raw/assets/`。
4. 詢問是否初始化 Git；同意時執行 `git init` 與首次提交。遠端連結與推送由使用者處理。
5. 在 `~/.claude/myllm-wiki/vault-path` 寫入一行絕對路徑。Codex 使用者須先取得授權，才能將規則加入 `~/.codex/AGENTS.md`。

## 使用

- 在 Obsidian 中以「將資料夾作為 Vault 開啟」開啟。
- 建議安裝 `obsidian-git`、`dataview`。
- 將資料放入 `raw/<領域>/`，輸入「把這個放進 Wiki」以啟動 `wiki-ingest`。
- 下一個工作階段起 Hook 自動注入規則；目前工作階段可執行 `/clear`。

## 常見失敗

| 失敗 | 結果 |
|---|---|
| 直接複製到既有資料夾 | 覆蓋使用者筆記 |
| 忘記註冊路徑 | 其他 Skill 找不到 Vault |
| 全域 `CLAUDE.md` 重複加入規則 | Hook 重複注入 |
| 忘記將 `gitignore` 改名 | `raw/` 可能被提交並洩漏原始文件 |
| 使用相對路徑 | 在其他專案中指向錯誤位置 |
