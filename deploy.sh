#!/bin/bash
set -e

IMAGE_NAME=${1:-"mdahebar/devops-app:latest"}
NGINX_CONF="/etc/nginx/sites-available/default"

echo "=== [1/5] Checking Active Environment ==="
ACTIVE_PORT=$(grep -oE '8081|8082' "$NGINX_CONF" | head -1)

if [ "$ACTIVE_PORT" == "8081" ]; then
    CURRENT="blue"
    TARGET="green"
    TARGET_PORT="8082"
else
    CURRENT="green"
    ACTIVE_PORT="8082"
    TARGET="blue"
    TARGET_PORT="8081"
fi

echo "Active: $CURRENT (Port $ACTIVE_PORT)"
echo "Target: $TARGET (Port $TARGET_PORT)"

echo "=== [2/5] Deploying New Container ($TARGET) ==="
sudo docker rm -f app-$TARGET 2>/dev/null || true
sudo docker run -d -p ${TARGET_PORT}:80 --name app-$TARGET "$IMAGE_NAME"

echo "=== [3/5] Running Smoke Health Check ==="
sleep 3
if curl -s -f "http://localhost:${TARGET_PORT}" | grep -q "DevOps CI/CD Pipeline"; then
    echo "Health check PASSED on port $TARGET_PORT"
else
    echo "Health check FAILED! Cleaning up $TARGET..."
    sudo docker rm -f app-$TARGET
    echo "Deployment aborted. Production remains safely on $CURRENT."
    exit 1
fi

echo "=== [4/5] Switching Nginx Traffic ==="
sudo sed -i "s/${ACTIVE_PORT}/${TARGET_PORT}/g" "$NGINX_CONF"
sudo nginx -t
sudo nginx -s reload

echo "=== [5/5] Success! ==="
echo "Traffic switched to $TARGET (Port $TARGET_PORT). Zero downtime achieved."
