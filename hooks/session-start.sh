#!/usr/bin/env bash
# SessionStart：將 Wiki 規則（「先參考、先建議記錄」）與 Vault 路徑注入工作階段內容。
# Vault 路徑 = $LLM_WIKI_VAULT；若未設定，則使用 <config>/llm-wiki/vault-path 的第一行。此檔案由 wiki-init 寫入。

set -u

HOOK_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
PATH_FILE="$CONFIG_DIR/llm-wiki/vault-path"

vault="${LLM_WIKI_VAULT:-}"
if [ -z "$vault" ] && [ -f "$PATH_FILE" ]; then
  IFS= read -r vault < "$PATH_FILE" || true
fi
vault="${vault%$'\r'}"

if [ -n "$vault" ]; then
  # 逐行替換——bash 5.2 會將 ${s//pat/rep} 中的 & 解讀為特殊字元，因此不使用。
  context=""
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%$'\r'}"
    case "$line" in
      *'{{VAULT_PATH}}'*) line="${line%%\{\{VAULT_PATH\}\}*}${vault}${line#*\{\{VAULT_PATH\}\}}" ;;
    esac
    context+="$line"$'\n'
  done < "$HOOK_DIR/wiki-rules.md"
else
  context="llm-wiki 外掛已安裝，但尚未設定 Vault。使用者提到 Wiki 時，請引導其使用 wiki-init Skill 建立 Vault 或註冊路徑；其他情況不要提及此事。"
fi

escape_for_json() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  printf '%s' "$s"
}

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$(escape_for_json "$context")"
