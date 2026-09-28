#!/usr/bin/env bash
# 用途：在 Ubuntu WSL 中安装依赖、构建 whisper.cpp 与 llama.cpp、创建 Python venv
set -e

echo "更新 apt 并安装基础工具……"
sudo apt update
sudo apt install -y build-essential git cmake python3 python3-venv python3-pip ffmpeg wget unzip

# 创建项目结构
WORKDIR="/mnt/d/assistant"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Python venv
if [ ! -d venv ]; then
  python3 -m venv venv
fi
source venv/bin/activate
pip install --upgrade pip

# Python 依赖（轻量）
pip install numpy pandas jupyterlab python-pptx opencc-python-reimplemented pypinyin rapidfuzz pyinstaller fastapi uvicorn

# clone & build whisper.cpp
if [ ! -d whisper.cpp ]; then
  git clone https://github.com/ggerganov/whisper.cpp.git
  cd whisper.cpp
  make
  # 把可执行文件复制到 assistant/bin
  mkdir -p "$WORKDIR/bin"
  cp main "$WORKDIR/bin/whisper"
  cd "$WORKDIR"
else
  echo "whisper.cpp 已存在，跳过 clone"
fi

# clone & build llama.cpp
if [ ! -d llama.cpp ]; then
  git clone https://github.com/ggerganov/llama.cpp.git
  cd llama.cpp
  make
  cp main "$WORKDIR/bin/llama"
  cd "$WORKDIR"
else
  echo "llama.cpp 已存在，跳过 clone"
fi

echo "创建 models 目录（请将模型文件放到 $WORKDIR/models)"
mkdir -p "$WORKDIR/models"

echo "安装完成。请手动下载所需模型并放到 $WORKDIR/models："
echo " - whisper.cpp 量化模型（ggml-base.bin 或 ggml-small.bin 等)"
echo "   Releases: https://github.com/ggerganov/whisper.cpp/releases"
echo " - LLM 量化 7B 模型（ggml/q4/gguf），例如 Llama2/CodeLlama 的量化版本（需在 Hugging Face 按许可下载）"
echo
echo "示例：在 WSL 中转写一个音频："
echo " $WORKDIR/bin/whisper -m $WORKDIR/models/ggml-base.bin -f input.wav -l zh -otxt"
echo
echo "示例：本地 LLM 交互："
echo " $WORKDIR/bin/llama -m $WORKDIR/models/ggml-7b-q4.bin -p \"写一封简短的邮件，主题是……\""
echo
echo "现在你可以把音频/模型放到 $WORKDIR，或运行 assistant.py（在同一 venv 中）来调用各模块。"
