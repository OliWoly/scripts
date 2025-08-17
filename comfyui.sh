#!/bin/bash

set -e

# === CONFIGURATION ===
COMFY_DIR="$HOME/ComfyUI-0.3.33"
PYTHON_VERSION="3.10.13"

echo "🔧 Starting setup for ComfyUI with AMD ROCm on Arch Linux..."

# === 1. Update system and install dependencies ===
echo "📦 Updating system and installing base packages..."
if ! pacman -Q git base-devel wget make curl gperftools &>/dev/null; then
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm git base-devel wget make curl gperftools
else
  echo "✅ Base packages already installed."
fi

# === 2. Install PyEnv (if not already installed) ===
if ! command -v pyenv &>/dev/null; then
  echo "📥 Installing pyenv..."
  curl https://pyenv.run | bash

  # Add pyenv init to bashrc if not already added
  if ! grep -q 'pyenv init' ~/.bashrc; then
    echo -e '\n# PyEnv Setup' >> ~/.bashrc
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
  fi

  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
else
  echo "✅ PyEnv already installed."
fi

# === 3. Install Python ===
if ! pyenv versions | grep -q "$PYTHON_VERSION"; then
  echo "🐍 Installing Python $PYTHON_VERSION..."
  pyenv install $PYTHON_VERSION
else
  echo "✅ Python $PYTHON_VERSION already installed."
fi

pyenv global $PYTHON_VERSION
export PATH="$HOME/.pyenv/shims:$PATH"
echo "🔢 Using Python version: $(python --version)"

# === 4. Install ROCm ===
installed=true

for pkg in rocm-hip-sdk rocm-opencl-sdk; do
  if ! pacman -Q $pkg &>/dev/null; then
    installed=false
    break
  fi
done

if ! $installed; then
  echo "⚙️ Installing ROCm (HIP + OpenCL SDK)..."
  yay -S --noconfirm rocm-hip-sdk rocm-opencl-sdk
else
  echo "✅ ROCm already installed."
fi


# Add user to groups if not already added
if ! groups "$USER" | grep -q '\brender\b'; then
  sudo gpasswd -a "$USER" render
fi
if ! groups "$USER" | grep -q '\bvideo\b'; then
  sudo gpasswd -a "$USER" video
fi

# Set environment variables if not already set
if ! grep -q 'ROCM_PATH' ~/.bashrc; then
  echo -e '\n# ROCm config for AMD GPU' >> ~/.bashrc
  echo 'export ROCM_PATH=/opt/rocm' >> ~/.bashrc
  echo 'export HSA_OVERRIDE_GFX_VERSION=11.0.0' >> ~/.bashrc
fi
export ROCM_PATH=/opt/rocm
export HSA_OVERRIDE_GFX_VERSION=11.0.0

# === 5. Clone ComfyUI ===
if [ ! -d "$COMFY_DIR" ]; then
  echo "📁 Cloning ComfyUI..."
  git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFY_DIR"
else
  echo "✅ ComfyUI already exists."
fi

cd "$COMFY_DIR"

# === 6. Setup virtual environment ===
if [ ! -d "venv" ]; then
  echo "🧪 Setting up Python virtual environment..."
  python -m venv venv
fi
source venv/bin/activate
pip install --upgrade pip

# === 7. Install PyTorch for ROCm ===
echo "💥 Checking for ROCm-compatible PyTorch..."
INSTALLED_TORCH=$(python -c "import torch; print(torch.__version__)" 2>/dev/null || echo "none")
TORCH_BACKEND=$(python -c "import torch; print(torch.version.hip)" 2>/dev/null || echo "none")

if [[ "$INSTALLED_TORCH" != "none" && "$TORCH_BACKEND" != "None" ]]; then
  echo "✅ ROCm-compatible PyTorch already installed (version: $INSTALLED_TORCH)"
  echo "✅ ROCm-compatible PyTorch backend already installed (version: $TORCH_BACKEND)"
else
  echo "💥 Installing ROCm-compatible PyTorch..."
  pip uninstall -y torch torchvision torchaudio || true
  pip install torch torchvision torchaudio  --index-url https://download.pytorch.org/whl/nightly/rocm6.4
fi


# === 8. Install ComfyUI dependencies ===
echo "📦 Installing ComfyUI dependencies..."
pip install -r requirements.txt

# === 9. Launch ComfyUI ===
echo "🚀 Launching ComfyUI..."
source venv/bin/activate
export PYTORCH_HIP_ALLOC_CONF=garbage_collection_threshold:0.6,max_split_size_mb:16000
python main.py \
  --listen 0.0.0.0 \
  --cpu-vae \
  --lowvram
