#!/bin/bash
# shellcheck shell=bash
# Start the Frigate service

set -o errexit -o nounset -o pipefail

export NVIDIA_VISIBLE_DEVICES="all"
export NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"
export TOKENIZERS_PARALLELISM="true"
export TRANSFORMERS_NO_ADVISORY_WARNINGS="1"
export OPENCV_FFMPEG_LOGLEVEL="8"
export PYTHONWARNINGS="ignore:::numpy.core.getlimits"
export HAILORT_LOGGER_PATH="NONE"
export TF_CPP_MIN_LOG_LEVEL="3"
export TF_ENABLE_ONEDNN_OPTS="0"
export AUTOGRAPH_VERBOSITY="0"
export GLOG_minloglevel="3"
export GLOG_logtostderr="0"
export PATH="/usr/local/go2rtc/bin:/usr/local/tempio/bin:/usr/local/nginx/sbin:/command:/package:${PATH}"
export DEFAULT_FFMPEG_VERSION="7.0"
export INCLUDED_FFMPEG_VERSIONS="7.0:5.0"
export S6_CMD_WAIT_FOR_SERVICES_MAXTIME="0"
export S6_LOGGING_SCRIPT="T 1 n0 s10000000 T"

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
