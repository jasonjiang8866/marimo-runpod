#!/usr/bin/env bash
set -euo pipefail

# Mode selection
MODE_TO_RUN="${MODE_TO_RUN:-pod}"          # pod | serverless
MARIMO_MODE="${MARIMO_MODE:-edit}"         # edit | run
MARIMO_NOTEBOOK="${MARIMO_NOTEBOOK:-/workspace/notebooks/welcome.py}"
MARIMO_PORT="${MARIMO_PORT:-2718}"

# Optional auth: if MARIMO_TOKEN set -> use it; else disable token
AUTH_FLAGS="--no-token"
if [[ -n "${MARIMO_TOKEN:-}" ]]; then
  AUTH_FLAGS="--token --token-password ${MARIMO_TOKEN}"
fi

# Start nginx (helps with Runpod proxy expectations)
service nginx start || true

# Optional: configure SSH access if PUBLIC_KEY provided
if [[ -n "${PUBLIC_KEY:-}" ]]; then
  mkdir -p /root/.ssh
  echo "$PUBLIC_KEY" >> /root/.ssh/authorized_keys
  chmod 700 -R /root/.ssh
  ssh-keygen -A
  service ssh start || true
fi

echo "[start] MODE_TO_RUN=${MODE_TO_RUN}"

if [[ "${MODE_TO_RUN}" == "serverless" ]]; then
  # Serverless path: start Runpod worker
  exec python -u /app/handler.py
else
  # Pod path: launch Marimo
  mkdir -p "$(dirname "${MARIMO_NOTEBOOK}")"
  if [[ ! -f "${MARIMO_NOTEBOOK}" ]]; then
    cp /workspace/notebooks/welcome.py "${MARIMO_NOTEBOOK}"
  fi

  cd /workspace
  if [[ "${MARIMO_MODE}" == "run" ]]; then
    echo "[marimo] running read-only app at 0.0.0.0:${MARIMO_PORT}"
    exec marimo run "${MARIMO_NOTEBOOK}" --host 0.0.0.0 --port "${MARIMO_PORT}" "${AUTH_FLAGS}"
  else
    echo "[marimo] running editor at 0.0.0.0:${MARIMO_PORT}"
    exec marimo edit "${MARIMO_NOTEBOOK}" --host 0.0.0.0 --port "${MARIMO_PORT}" "${AUTH_FLAGS}"
  fi
fi
