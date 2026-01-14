#!/bin/bash
# shellcheck shell=bash
# Start the Frigate service

set -o errexit -o nounset -o pipefail

{% for item in envs %}
export {{ item.name }}="{{ item.value }}"
{% endfor %}

# opt out of openvino telemetry
if [ -e /usr/local/bin/opt_in_out ]; then
  /usr/local/bin/opt_in_out --opt_out > /dev/null 2>&1
fi

function set_libva_version() {
    local ffmpeg_path
    ffmpeg_path=$(/usr/bin/python3 /usr/local/ffmpeg/get_ffmpeg_path.py)
    /usr/bin/cp /etc/default/pre-frigate /etc/default/frigate
    echo "LIBAVFORMAT_VERSION_MAJOR=$("$ffmpeg_path" -version | /usr/bin/grep -Po "libavformat\W+\K\d+")" |
      /usr/bin/tee -a /etc/default/frigate
}

echo "[INFO] Preparing Frigate..."
set_libva_version

echo "[INFO] Starting Frigate..."

cd /opt/frigate || echo "[ERROR] Failed to change working directory to /opt/frigate"
