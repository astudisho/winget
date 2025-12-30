# PowerShell Script to Install Multiple Packages using winget
# Run as Administrator check
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator. Requesting elevation..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Fix for the Certificate Error 0x8a15005e
Write-Host "Configuring winget settings..." -ForegroundColor Cyan
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $settingsPath) {
    $settings = Get-Content $settingsPath | ConvertFrom-Json
    if (-not $settings.PSObject.Properties['installBehavior']) {
        $settings | Add-Member -NotePropertyName 'installBehavior' -NotePropertyValue @{bypassCertificatePinningForMicrosoftStore = $true} -Force
    } else {
        $settings.installBehavior.bypassCertificatePinningForMicrosoftStore = $true
    }
    $settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath
}

# Define packages to install
$packages = @(
    @{ Name = "Microsoft.VisualStudioCode"; DisplayName = "Visual Studio Code" },
    @{ Name = "Google.Chrome"; DisplayName = "Google Chrome" },
    @{ Name = "Microsoft.VisualStudio.Community"; DisplayName = "Visual Studio 2026 Community" },
    @{ Name = "OpenJS.NodeJS"; DisplayName = "Node.js" },
    @{ Name = "NVIDIA.app"; DisplayName = "NVIDIA App" },
    @{ Name = "Nvidia.GeForceNow"; DisplayName = "NVIDIA GeForce Now" },
    @{ Name = "Microsoft.PowerShell"; DisplayName = "PowerShell 7" },
    @{ Name = "JanDeDobbeleer.OhMyPosh"; DisplayName = "Oh My Posh" },
    @{ Name = "RealVNC.VNCViewer"; DisplayName = "VNC Viewer" },
    @{ Name = "ASUS.ArmouryCrate"; DisplayName = "Armory Crate" },
    @{ Name = "Docker.DockerDesktop"; DisplayName = "Docker Desktop" },
    @{ Name = "Microsoft.Office"; DisplayName = "Microsoft Office" },
    @{ Name = "Dropbox.Dropbox"; DisplayName = "Dropbox" },
    @{ Name = "WhatsApp.WhatsApp"; DisplayName = "WhatsApp" },
    @{ Name = "Git.Git"; DisplayName = "Git" },
    @{ Name = "Valve.Steam"; DisplayName = "Steam" },
    @{ Name = "Spotify.Spotify"; DisplayName = "Spotify" },
    @{ Name = "Insecure.Nmap"; DisplayName = "Nmap" },
    @{ Name = "Logitech.LGHUB"; DisplayName = "Logitech G HUB" }
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Package Installation Script" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# Check if winget is available
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host " winget is not installed. Please update 'App Installer' from MS Store." -ForegroundColor Red
    exit 1
}

$successCount = 0
$failedPackages = @()

foreach ($package in $packages) 
{
    Write-Host "Installing: $($package.DisplayName)..." -ForegroundColor Yellow
    
    # Try/Catch for the execution
    try 
    {
        winget install --id $package.Name --accept-source-agreements --accept-package-agreements -e --silent
        
        if ($LASTEXITCODE -eq 0) 
        {
            Write-Host " Successfully installed: $($package.DisplayName)" -ForegroundColor Green
            $successCount++
        } else 
        {
            Write-Host " Failed (Exit Code: $LASTEXITCODE) for: $($package.DisplayName)" -ForegroundColor Red
            $failedPackages += $package.DisplayName
        }
    } catch 
    {
        Write-Host " Exception installing $($package.DisplayName): $($_.Exception.Message)" -ForegroundColor Red
        $failedPackages += $package.DisplayName
    }
    Write-Host ""
}

# Summary
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Summary: $successCount / $($packages.Count) installed successfully." -ForegroundColor Cyan
if ($failedPackages.Count -gt 0) {
    Write-Host "Failed: $($failedPackages -join ', ')" -ForegroundColor Red
}
Write-Host "============================================" -ForegroundColor Cyan
Read-Host "Press Enter to exit"