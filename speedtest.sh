#!/usr/bin/env bash
set -euo pipefail

# Preserve the caller's working directory while running relative assets.
initial_dir="$(pwd)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
trap 'cd "${initial_dir}"' EXIT
cd "${script_dir}"

DATE="$(date +"%Y-%m-%d")"
TIME="$(date +"%H:%M:%S")"

no_connection_ping="999.0"
no_connection_download="0.0"
no_connection_upload="0.0"

ping="${no_connection_ping}"
download="${no_connection_download}"
upload="${no_connection_upload}"

if speedtest_json="$(speedtest-cli --secure --json 2>/dev/null)"; then
	if read -r parsed_ping parsed_download parsed_upload < <(
		python3 - "${speedtest_json}" <<'PY'
import json
import sys

if len(sys.argv) < 2:
    sys.exit(1)

try:
    payload = json.loads(sys.argv[1])
    ping = float(payload.get("ping", 0.0))
    download = float(payload.get("download", 0.0)) / 1_000_000
    upload = float(payload.get("upload", 0.0)) / 1_000_000
except (TypeError, ValueError, json.JSONDecodeError):
    sys.exit(1)

print(f"{ping:.3f} {download:.3f} {upload:.3f}")
PY
	); then
		ping="${parsed_ping}"
		download="${parsed_download}"
		upload="${parsed_upload}"
	fi
fi

sheet="$(hostname -s)-${DATE}.csv"
printf '%s;%s;%s;%s;%s\n' "${DATE}" "${TIME}" "${ping}" "${download}" "${upload}" >> "${script_dir}/${sheet}"

if ! python3 "${script_dir}/Graph-Builder/graph-builder.py" "${sheet}"; then
	echo "Warning: failed to update graphs for ${sheet}" >&2
fi

#DisplayOutput
#python3 display.py "${DATE} ${TIME} ${ping} ${download} ${upload}"
