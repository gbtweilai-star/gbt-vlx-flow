#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_vlx_flow info
PYTHONPATH=src python -m gbt_vlx_flow check --payload '{}'
PYTHONPATH=src python -m gbt_vlx_flow run   --payload '{}'
