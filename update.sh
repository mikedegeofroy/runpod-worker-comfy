#!/usr/bin/env bash

cd /comfyui/custom_nodes
git pull
git checkout 22d1241a503461c9ca4f3ad48ddec5ce6e5ee491

apt update
apt install build-essential -y
apt install libpython3.10-dev -y

pip install --upgrade opencv-python-headless
pip install --upgrade albucore

pip install insightface==0.7.3
pip install spandrel

python3 -m pip install gitpython

git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git
git clone https://github.com/ltdrdata/ComfyUI-Impact-Subpack ComfyUI-Impact-Pack/impact_subpack
python3 ComfyUI-Impact-Pack/install.py

pip install rembg[gpu]

git clone https://github.com/Fannovel16/comfyui_controlnet_aux/
pip install -r comfyui_controlnet_aux/requirements.txt

git clone https://github.com/WASasquatch/was-node-suite-comfyui/
pip install -r was-node-suite-comfyui/requirements.txt