#!/bin/sh
set -e

export PORT="8080"
export VLESS_WS_PATH="$(python3 /app/app/gen_ws_path.py)"
echo "[start] مسیر مخفی کانفیگ: $VLESS_WS_PATH"

echo "[start] در حال ساختن تنظیمات nginx برای پورت $PORT ..."
envsubst '${PORT} ${VLESS_WS_PATH}' < /app/nginx.conf.template > /etc/nginx/nginx.conf

# FastAPI ကို အရင်စတင်ပါ
echo "[start] در حال اجرای FastAPI (پنل + API) روی پورت داخلی 8000 ..."
uvicorn app.main:app --host 127.0.0.1 --port 8000 &

# FastAPI စတင်ပြီးတဲ့အထိ ခဏစောင့်ပါ
sleep 3

echo "[start] در حال اجرای nginx روی پورت عمومی $PORT ..."
nginx -g "daemon off;"
