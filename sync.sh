#!/bin/bash
# 自動同步：偵測到檔案變動就 commit + push 到 GitHub，網站隨後自動更新。
# 由 launchd 每 60 秒呼叫一次。
cd "$(dirname "$0")" || exit 1

# 必須是 git repo 且已設定遠端，否則不動作
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
git remote get-url origin >/dev/null 2>&1 || exit 0

# 有變動才處理
if [ -n "$(git status --porcelain)" ]; then
  git add -A
  git commit -m "自動更新 $(date '+%Y-%m-%d %H:%M:%S')" >/dev/null 2>&1
  git push >> "$(dirname "$0")/.sync.log" 2>&1
  echo "$(date '+%F %T') pushed" >> "$(dirname "$0")/.sync.log"
fi
