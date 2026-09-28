<# install.ps1
   用途：在 Windows 上引导安装 WSL2（若未安装），并在用户主目录创建 assistant 目录，把后续脚本放进去。
   以管理员权限运行：右键 PowerShell -> Run as Administrator
#>

# 检查 WSL
Write-Host "检查 WSL..."
wsl.exe --status 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "WSL 未安装或未启用。正在启用 WSL 功能（需要重启）..."
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /All /NoRestart
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /All /NoRestart
    Write-Host "请重启电脑后再次运行本脚本（或者手动安装 WSL2）。"
    exit 1
} else {
    Write-Host "WSL 已安装。"
}

# 创建 assistant 目录（Windows侧）
$assistDir = "D:\assistant"
if (!(Test-Path $assistDir)) {
    New-Item -ItemType Directory -Path $assistDir | Out-Null
    Write-Host "已创建 $assistDir"
} else {
    Write-Host "$assistDir 已存在"
}

Write-Host "请确保已把 wsl_setup.sh, assistant.py, transcribe.py 等文件放到 D:\assistant（本脚本通常与这些文件一起），然后在 WSL 中运行："
Write-Host "`tcd /mnt/d/assistant && bash setup_wsl.sh"
