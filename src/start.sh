#!/usr/bin/env bash

# Use libtcmalloc for better memory management
TCMALLOC="$(ldconfig -p | grep -Po "libtcmalloc.so.\d" | head -n 1)"
export LD_PRELOAD="${TCMALLOC}"

# Check if /workspace/ComfyUI/models/insightface is mounted
if mount | grep "/workspace/ComfyUI/models/insightface" > /dev/null; then
    echo "/workspace/ComfyUI/models/insightface is mounted."

    # Create a soft link to /comfyui/models/insightface if it doesn't already exist
    if [ ! -L "/comfyui/models/insightface" ]; then
        ln -s /workspace/ComfyUI/models/insightface /comfyui/models/insightface
        echo "Created a soft link to /comfyui/models/insightface."
    else
        echo "Soft link already exists."
    fi
else
    echo "/workspace/ComfyUI/models/insightface is not mounted."
fi

# Serve the API and don't shutdown the container
if [ "$SERVE_API_LOCALLY" == "true" ]; then
    echo "runpod-worker-comfy: Starting ComfyUI"
    python3 /comfyui/main.py --disable-auto-launch --disable-metadata --listen &

    echo "runpod-worker-comfy: Starting RunPod Handler"
    python3 -u /rp_handler.py --rp_serve_api --rp_api_host=0.0.0.0
else
    echo "runpod-worker-comfy: Starting ComfyUI"
    python3 /comfyui/main.py --disable-auto-launch --disable-metadata &

    echo "runpod-worker-comfy: Starting RunPod Handler"
    python3 -u /rp_handler.py
fi