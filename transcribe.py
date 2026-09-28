#!/usr/bin/env python3
import subprocess
from pathlib import Path
import argparse

ROOT = Path("D:/assistant")
BIN = ROOT / "bin"
MODELS = ROOT / "models"

def to_wav(input_path, out_wav):
    # 依赖 ffmpeg 可用
    subprocess.run(["ffmpeg", "-y", "-i", str(input_path), "-ac", "1", "-ar", "16000", str(out_wav)], check=True)

def transcribe(input_audio):
    input_audio = Path(input_audio)
    wav = input_audio.with_suffix(".16k.wav")
    to_wav(input_audio, wav)
    whisper = BIN / "whisper"
    model = MODELS / "ggml-base.bin"
    subprocess.run([str(whisper), "-m", str(model), "-f", str(wav), "-l", "zh", "-otxt"])

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("audio")
    args = parser.parse_args()
    transcribe(args.audio)
