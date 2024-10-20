#!/usr/bin/env bash

set -e 

# Quit script if snapshot file doesn't exist

if [ ! -f /snapshot.json ]; then
    echo "runpod-worker-comfy: No snapshot file found. Exiting..."
    exit 0
fi

cd /comfyui/

# Install ComfyUI-Manager
git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager

cd custom_nodes/ComfyUI-Manager

git checkout 61efd606816342cb6b818042b543c518f48e94a2

pip install -r requirements.txt

mkdir startup-scripts
mv /snapshot.json startup-scripts/restore-snapshot.json

cd ../..

# Trigger restoring of the snapshot by performing a quick test run
# Note: We need to use `yes` as some custom nodes may try to install dependencies with pip
/usr/bin/yes | python3 main.py --cpu --quick-test-for-ci