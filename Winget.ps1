# PowerShell Script to Install Multiple Packages using winget
# This script installs the following packages:  VSCode, Chrome, Visual Studio 2026 Community, Node.js, NVIDIA App, PowerShell 7, Oh My Posh, VNC Viewer, Armory Crate, Docker, Office, and Dropbox

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run as Administrator check
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator.  Requesting elevation..." -ForegroundColor Yellow
    Start-Process powershell. exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Define packages to install
$packages = @(
    @{ Name = "Microsoft.VisualStudioCode"; DisplayName = "Visual Studio Code" },
    @{ Name = "Google.Chrome"; DisplayName = "Google Chrome" },
    @{ Name = "Microsoft.VisualStudio.2026.Community"; DisplayName = "Visual Studio 2026 Community Edition" },
    @{ Name = "OpenJS.NodeJS"; DisplayName = "Node. js" },
    @{ Name = "NVIDIA.app"; DisplayName = "NVIDIA App" },
    @{ Name = "Microsoft.PowerShell"; DisplayName = "PowerShell 7" },
    @{ Name = "JanDeDobbeleer.OhMyPosh"; DisplayName = "Oh My Posh" },
    @{ Name = "RealVNC.VNCViewer"; DisplayName = "VNC Viewer" },
    @{ Name = "ASUS.ArmoryCreate"; DisplayName = "Armory Crate" },
    @{ Name = "Docker.DockerDesktop"; DisplayName = "Docker Desktop" },
    @{ Name = "Microsoft.Office"; DisplayName = "Microsoft Office" },
    @{ Name = "Dropbox.Dropbox"; DisplayName = "Dropbox" }
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Package Installation Script" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Check if winget is available
try {
    $wingetPath = Get-Command winget -ErrorAction Stop
    Write-Host "✓ winget found at: $($wingetPath. Source)" -ForegroundColor Green
}
catch {
    Write-Host "✗ winget is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install winget first from: https://apps.microsoft.com/detail/9NBLGGH4NNS1" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Starting installation of $($packages.Count) packages..." -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$failureCount = 0
$failedPackages = @()

# Install each package
foreach ($package in $packages) {
    Write-Host "Installing:  $($package.DisplayName)..." -ForegroundColor Yellow
    
    try {
        winget install --id $package.Name --accept-source-agreements --accept-package-agreements -e
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Successfully installed: $($package.DisplayName)" -ForegroundColor Green
            $successCount++
        }
        else {
            Write-Host "✗ Failed to install:  $($package.DisplayName)" -ForegroundColor Red
            $failureCount++
            $failedPackages += $package.DisplayName
        }
    }
    catch {
        Write-Host "✗ Error installing $($package.DisplayName): $_" -ForegroundColor Red
        $failureCount++
        $failedPackages += $package.DisplayName
    }
    
    Write-Host ""
}

# Summary
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Installation Summary" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Successfully installed: $successCount" -ForegroundColor Green
Write-Host "Failed installations: $failureCount" -ForegroundColor $(if ($failureCount -gt 0) { "Red" } else { "Green" })

if ($failedPackages.Count -gt 0) {
    Write-Host ""
    Write-Host "Failed packages:" -ForegroundColor Red
    foreach ($failedPkg in $failedPackages) {
        Write-Host "  - $failedPkg" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Tip: You can try installing these manually or check the winget package IDs." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Installation process completed!" -ForegroundColor Cyan
Read-Host "Press Enter to exit"
