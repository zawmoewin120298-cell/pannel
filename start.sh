#!/bin/sh
set -e

# Port ကို 8080 အဖြစ် သတ်မှတ်ပါ
export PORT="8080"

# လျှို့ဝှက်လမ်းကြောင်း ဖန်တီးပါ
export VLESS_WS_PATH="$(python3 /app/app/gen_ws_path.py)"
echo "[start] مسیر مخفی کانفیگ: $VLESS_WS_PATH"

# Nginx Config ကို ဖန်တီးပါ
echo "[start] در حال ساختن تنظیمات nginx برای پورت $PORT ..."
envsubst '${PORT} ${VLESS_WS_PATH}' < /app/nginx.conf.template > /etc/nginx/nginx.conf

# FastAPI ကို စတင်ပါ
echo "[start] در حال اجرای FastAPI (پنل + API) روی پورت داخلی 8000 ..."
uvicorn app.main:app --host 127.0.0.1 --port 8000 &

# FastAPI စတင်ပြီးသည်အထိ ၃ စက္ကန့် စောင့်ပါ
sleep 3

# Nginx ကို စတင်ပါ
echo "[start] در حال اجرای nginx روی پورت عمومی $PORT ..."
nginx -g "daemon off;"
