#!/usr/bin/env bash

set -Eeuo pipefail

# 簡易ビルド用スクリプト
# Docker Composeを使用して、mp4-repairとphp-webのコンテナをビルド・起動します。
# 元々のコンテナは自動で削除するため、注意してください。
# (Linux用)

MP4_REPAIR_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
ORCHESTRATOR_DIR="${MP4_REPAIR_DIR}/orchestrator"

compose() {
  if docker compose version >/dev/null 2>&1; then
    docker compose "$@"
  elif command -v docker-compose >/dev/null 2>&1; then
    docker-compose "$@"
  else
    echo "docker compose (or docker-compose) is not available" >&2
    exit 1
  fi
}

NAMES=(mp4-repair php-web)
for name in "${NAMES[@]}"; do
  ids="$(docker ps -aq -f "name=^/${name}$" || true)"
  if [[ -n "${ids}" ]]; then
    while IFS= read -r id; do
      [[ -n "${id}" ]] && docker rm -f "${id}" >/dev/null 2>&1 || true
    done <<< "${ids}"
  fi
done

(
  cd "${MP4_REPAIR_DIR}"
  compose down -v --remove-orphans
)

echo "[1/3] Build orchestrator image..."
(
  cd "${ORCHESTRATOR_DIR}"
  docker build -t mp4-repair-orchestrator .
)

echo "[2/3] Bring down again (double ensure)..."
(
  cd "${MP4_REPAIR_DIR}"
  compose down -v --remove-orphans
)

echo "[3/3] Start compose stack..."
(
  cd "${MP4_REPAIR_DIR}"
  compose up -d --build --force-recreate --remove-orphans
)

echo "Done."

# いじるときは改行コードをLFにしてください！
