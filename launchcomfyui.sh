#!/bin/bash

echo "🚀 Launching ComfyUI..."
source venv/bin/activate
export PYTORCH_HIP_ALLOC_CONF=garbage_collection_threshold:0.6,max_split_size_mb:16000
python main.py \
  --listen 0.0.0.0 \
#  --cpu-vae \
  --lowvram
