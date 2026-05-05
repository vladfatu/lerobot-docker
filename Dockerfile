# ─────────────────────────────────────────────────────────────
# LeRobot training image
# Base: CUDA 12.6.3 + cuDNN + Ubuntu 24.04
# Python: 3.12  |  PyTorch: CUDA 12.6 wheels  |  LeRobot: PyPI
# Target GPUs: RTX 4090, A100, H100
# ─────────────────────────────────────────────────────────────
FROM nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1

# ── System dependencies ────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-dev \
    python3-venv \
    python3-pip \
    python-is-python3 \
    git \
    wget \
    curl \
    cmake \
    build-essential \
    pkg-config \
    ffmpeg \
    libavformat-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavutil-dev \
    libswscale-dev \
    libswresample-dev \
    libavfilter-dev \
    && rm -rf /var/lib/apt/lists/*

# ── LeRobot[training] + PyTorch CUDA wheels in one solve ──────
# --extra-index-url adds the CUDA index alongside PyPI so pip
# picks up CUDA-enabled torch/torchvision/torchaudio in the same
# resolution pass — no overwrite/reinstall of torch later.
# lerobot[training] includes: accelerate, wandb, datasets,
# pyarrow, torchcodec, av (everything needed for training runs).
RUN pip install packaging setuptools wheel

RUN pip install "torch>=2.7,<2.11.0" torchvision torchaudio \
    --extra-index-url https://download.pytorch.org/whl/cu126

RUN pip install "lerobot[training,diffusion,wallx,pi,smolvla,multi_task_dit,groot,sarm,xvla,hilserl]==0.5.1" \
    --extra-index-url https://download.pytorch.org/whl/cu126

WORKDIR /workspace

CMD ["sleep", "infinity"]
