混合一键助手（Windows + WSL2 优先）
----------------------------------
目标：在你的 Windows 笔记本上快速搭好本地能力：写作（本地LLM/云按需）、语音转文字、数据分析、自动生成 PPT、代码生成与打包、按需图像（云API）。

概览与优先流程：
1. 在 Windows 以管理员权限运行 install.ps1（会检测/引导安装 WSL2 与必要工具）。
2. 打开 WSL (Ubuntu) 终端，进入 /mnt/d/assistant 并执行：bash setup_wsl.sh
   - 该脚本会安装编译工具、Python 环境、编译 whisper.cpp 与 llama.cpp。
3. 手动下载模型并放到 D:\assistant\models：
   - whisper.cpp ggml 模型（推荐 ggml-base.bin 或 ggml-small.bin，或 ggml-tiny.bin 作为测试）
     下载页：请在 https://github.com/ggerganov/whisper.cpp/releases 找 Windows release & 模型链接
   - LLM 模型（7B q4/gguf），例如 Code Llama / Llama2 量化版本（需在 Hugging Face 按许可下载）
4. 运行示例：
   - 语音转写（WSL 中）：
     ./whisper.cpp/main -m /mnt/d/assistant/models/ggml-base.bin -f input.wav -l zh -otxt
   - 本地写作（WSL 中）：
     ./llama.cpp/main -m /mnt/d/assistant/models/ggml-7b-q4.bin -p "写一段请柬，主题是……"
5. 在 Windows 中，你可以运行 assistant.py（在 WSL 的 Python venv 中也可以）：
   - python assistant.py --help 查看 CLI（transcribe / write /analyze / genppt / codepack）
6. 可选云：导出 OPENAI_API_KEY、REPLICATE_API_TOKEN 或 HF_TOKEN 到环境变量，以启用高质量写作或图像生成。

重要提醒：
- 模型文件通常很大（数百 MB 到几十 GB），请确认 SSD 空间与许可。
- 在这台电脑上，优先使用小/量化模型（ggml-base / q4 7B）。不要尝试 medium/large 或无量化大型模型。
- 若你不愿意安装 WSL2，可在 Windows 上手动安装二进制（release），但有时编译/依赖更麻烦。

在 WSL 中的路径说明：
- Windows 路径 D:\assistant 会映射为 /mnt/d/assistant
- 所有脚本均可在 /mnt/d/assistant 下找到并执行
