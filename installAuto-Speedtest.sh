#!/usr/bin/env bash
# Installation script for auto-speedtest
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Installing auto-speedtest ==="

# 1. Check Python 3
if ! command -v python3 &>/dev/null; then
    echo "Error: python3 is not installed. Please install Python 3 first." >&2
    exit 1
fi
echo "✓ Python 3 is installed."

# 2. Check/Download speedtest-cli
if ! command -v speedtest-cli &>/dev/null && [ ! -f "${script_dir}/speedtest-cli" ]; then
    echo "speedtest-cli not found in PATH or script directory."
    echo "Downloading speedtest-cli from GitHub..."
    if ! wget -q -O "${script_dir}/speedtest-cli" https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py; then
        echo "Warning: failed to download speedtest-cli via wget. Trying curl..." >&2
        if ! curl -s -o "${script_dir}/speedtest-cli" https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py; then
            echo "Error: failed to download speedtest-cli. Please install it manually or place speedtest.py as speedtest-cli in ${script_dir}." >&2
            exit 1
        fi
    fi
    chmod +x "${script_dir}/speedtest-cli"
    echo "✓ speedtest-cli downloaded and made executable."
else
    echo "✓ speedtest-cli is already available."
fi

# 3. Make all scripts executable
echo "Setting executable permissions..."
chmod +x "${script_dir}/speedtest.sh"
chmod +x "${script_dir}/backup.sh"
chmod +x "${script_dir}/generator.sh"
chmod +x "${script_dir}/Graph-Builder/enterDate2Files.sh"
chmod +x "${script_dir}/Graph-Builder/graph-builder.py"
echo "✓ Permissions updated."

echo
echo "=== Installation Completed ==="
echo "To automate speed tests, add the following cron job (run 'crontab -e'):"
echo "*/5 * * * * ${script_dir}/speedtest.sh >/dev/null 2>&1"
echo "================================="
