#!/bin/sh
set -eu
mkdir -p /data/in /data/out /data/logs /work
chmod -R 0777 /data || true
chmod -R 0777 /work || true
echo "[orchestrator] perms:"; ls -ld /data /data/in /data/out /data/logs /work || true
id || true
exec "$@"
