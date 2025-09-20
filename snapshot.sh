#!/usr/bin/env bash
set -e

# === Config ===
IMAGE_BASE="ghcr.io/rcook0/dev-stack"
DATE_TAG=$(date +%Y%m%d)
SNAPSHOT_TAG="snapshot-$DATE_TAG"
LOG_FILE="$(pwd)/snapshot.log"

echo "=== Snapshot started $(date -u +%Y-%m-%dT%H:%M:%SZ) ===" | tee -a "$LOG_FILE"

# 1. Find running dev-stack container
CID=$(docker ps --filter "ancestor=$IMAGE_BASE:latest" --format "{{.ID}}" | head -n1)
if [ -z "$CID" ]; then
  echo "❌ No running container found from $IMAGE_BASE:latest" | tee -a "$LOG_FILE"
  exit 1
fi
echo "🔍 Found container $CID running from $IMAGE_BASE:latest" | tee -a "$LOG_FILE"

# 2. Commit container to a new image
SNAPSHOT_IMG="$IMAGE_BASE:$SNAPSHOT_TAG"
docker commit "$CID" "$SNAPSHOT_IMG" >/dev/null
echo "📦 Created snapshot image $SNAPSHOT_IMG" | tee -a "$LOG_FILE"

# 3. Push to GHCR
echo "⬆️  Pushing $SNAPSHOT_IMG to GHCR..." | tee -a "$LOG_FILE"
docker push "$SNAPSHOT_IMG" | tee -a "$LOG_FILE"

# 4. Package diff vs base
echo "🔎 Collecting package list diff..." | tee -a "$LOG_FILE"
docker run --rm "$IMAGE_BASE:latest" dpkg --get-selections | grep -v deinstall > base-packages.txt
docker exec "$CID" dpkg --get-selections | grep -v deinstall > snapshot-packages.txt
diff -u base-packages.txt snapshot-packages.txt > package-diff.txt || true

if [ -s package-diff.txt ]; then
  echo "📑 Package differences saved to package-diff.txt" | tee -a "$LOG_FILE"
else
  echo "✅ No package differences found (same as base)" | tee -a "$LOG_FILE"
fi

echo "=== Snapshot finished $(date -u +%Y-%m-%dT%H:%M:%SZ) ===" | tee -a "$LOG_FILE"
