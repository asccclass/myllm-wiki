---
name: wiki-query
description: 在開始可能涉及既有 Wiki 知識的實質工作前使用；使用者要求查詢、比較、整理、分析 Wiki，或詢問開發改善項目時也使用。
---

# Wiki 查詢（Query）

## 核心原則

先讀索引，再深入頁面，帶著引用回答；好的答案應建議回寫 Wiki。不要用模型記憶填補 Wiki 中不存在的內容。

## 流程

1. 讀取 `<VAULT>/wiki/index.md`，挑出相關頁面；找不到時才搜尋 `wiki/` 全部內容，並補回索引遺漏。
2. 閱讀挑出的頁面，沿著 `[[連結]]` 與 `sources` 深入一層。
3. 所有主張附上來源頁面連結；引用 `status: contested` 時明確說明矛盾狀態。
4. 若答案整合多份資料、建立比較表、發現新關係或可能再次使用，建議寫入 `wiki/syntheses/`；獲准後更新 `index.md` 與 `log.md`。

```bash
grep -i "關鍵字1\|關鍵字2" "<VAULT>/wiki/index.md"
```

## 開發與改善項目

檢查 `wiki/ideas/`，依 `targets` 篩選，預設排除 `stage: 完成` 與 `stage: 保留`，依 `priority` 排序，並說明「目前狀態」的確認時間。舊確認時間可能已過時，應提醒使用者。

```bash
cd "<VAULT>"
grep -l "目標系統" wiki/ideas/*.md
grep -rn "^stage:" wiki/ideas/ | grep -v 完成
```

## 常見失敗

| 失敗 | 結果 |
|---|---|
| 不讀索引就搜尋全部 | 緩慢且遺漏索引問題 |
| 沒有來源就回答 | 無法驗證 |
| 用模型知識填補 Wiki | 污染 Wiki 內容 |
| 把 contested 當成確定事實 | 可能依過時資訊決策 |
| 對無關工作也查 Wiki | 噪音與 token 浪費 |
| 好的綜合只留在對話 | 知識無法累積 |
