#!/bin/bash
# 一鍵設定自動上線：首次執行一次即可。
# 事前準備：先安裝 GitHub Desktop 並登入（才有推送權限），並在 GitHub 建立一個 public repo。
cd "$(dirname "$0")" || exit 1
echo "=============================================="
echo "  自動上線設定"
echo "=============================================="
echo ""
echo "請貼上你的 GitHub repo 網址，然後按 Enter"
echo "（例如：https://github.com/你的帳號/my-notes.git）"
read -r REPO
if [ -z "$REPO" ]; then echo "沒有輸入網址，結束。"; exit 1; fi

git init -q
git branch -M main 2>/dev/null
git remote remove origin 2>/dev/null
git remote add origin "$REPO"

# 忽略記錄檔
printf ".sync.log\n.sync.err.log\n.DS_Store\n" > .gitignore

git add -A
git commit -q -m "首次發布" 2>/dev/null
echo ""
echo "→ 正在推送到 GitHub..."
if git push -u origin main; then
  echo "✓ 推送成功"
else
  echo "✗ 推送失敗：請確認已安裝並登入 GitHub Desktop、且 repo 網址正確。"
  exit 1
fi

# 安裝背景自動同步
cp com.owen.sitesync.plist "$HOME/Library/LaunchAgents/com.owen.sitesync.plist"
launchctl unload "$HOME/Library/LaunchAgents/com.owen.sitesync.plist" 2>/dev/null
launchctl load "$HOME/Library/LaunchAgents/com.owen.sitesync.plist"

echo ""
echo "=============================================="
echo "  完成！之後這個資料夾的檔案一有變動，"
echo "  約 1 分鐘內就會自動上傳，網站自動更新。"
echo "=============================================="
echo "別忘了到 GitHub repo 的 Settings → Pages 開啟 GitHub Pages。"
