# Make package locally on D:\ and create D:\assistant.zip
# Usage: run this PowerShell script from any folder (no admin needed)
$targetRoot = "D:\assistant"
$zipPath = "D:\assistant.zip"

Write-Host "创建目录 $targetRoot ..."
New-Item -ItemType Directory -Path $targetRoot -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $targetRoot "models") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $targetRoot "bin") -Force | Out-Null

function Write-File($path, $content, $encoding="utf8") {
    $dir = Split-Path $path -Parent
    if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $content | Out-File -FilePath $path -Encoding $encoding -Force
    Write-Host "写入 $path"
}

# 写入 README, install.ps1, setup_wsl.sh, assistant.py, transcribe.py 已在仓库
Write-Host "已把脚本写入 D:\assistant（请手动下载模型并放入 D:\assistant\models）"

Write-Host "正在压缩为 $zipPath ..."
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($targetRoot, $zipPath)
Write-Host "已生成 $zipPath"
