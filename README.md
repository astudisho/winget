# Winget Package Installer

A PowerShell script that automates the installation of multiple applications using Windows Package Manager (winget).

## Description

This script installs a curated collection of development tools and applications commonly used for software development and productivity. It uses Microsoft's winget package manager to download and install packages with minimal user interaction.

## Packages Installed

The script installs the following 14 packages:

1. **Visual Studio Code** - Code editor
2. **Google Chrome** - Web browser
3. **Visual Studio 2026 Community Edition** - IDE
4. **Node.js** - JavaScript runtime
5. **NVIDIA App** - NVIDIA graphics management
6. **PowerShell 7** - Modern PowerShell version
7. **Oh My Posh** - Terminal prompt theme engine
8. **VNC Viewer** - Remote desktop viewer
9. **Armory Crate** - ASUS system management
10. **Docker Desktop** - Container platform
11. **Microsoft Office** - Productivity suite
12. **Dropbox** - Cloud storage
13. **PowerToys** - Microsoft power user utilities
14. **Git** - Version control system

## Prerequisites

- **Windows 10 (version 1809 or later)** or **Windows 11**
- **winget** (Windows Package Manager) must be installed
  - Usually pre-installed on Windows 11
  - For Windows 10, install from the [Microsoft Store](https://apps.microsoft.com/detail/9NBLGGH4NNS1)
- **Administrator privileges** - The script will prompt for elevation if not run as admin

## Usage

### Option 1: Right-click and Run as Administrator

1. Download or clone this repository
2. Right-click on `Winget.ps1`
3. Select "Run with PowerShell" (if you have admin rights)
4. Or select "Run as Administrator" from the context menu

### Option 2: Run from PowerShell

```powershell
# Navigate to the script directory
cd path\to\winget

# Run the script
.\Winget.ps1
```

If you don't have administrator privileges, the script will automatically request elevation.

### Option 3: Run with Execution Policy Bypass

If you encounter execution policy restrictions:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\Winget.ps1
```

## How It Works

1. **Administrator Check**: The script verifies it's running with administrator privileges. If not, it automatically relaunches itself with elevated permissions.

2. **Winget Verification**: Checks if winget is installed and available in the system PATH. If not found, the script exits with instructions to install it.

3. **Package Installation**: Iterates through the package list and installs each one using:
   ```powershell
   winget install --id <PackageID> --accept-source-agreements --accept-package-agreements -e
   ```
   - `--id`: Specifies the exact package ID
   - `--accept-source-agreements`: Auto-accepts source agreements
   - `--accept-package-agreements`: Auto-accepts package agreements
   - `-e`: Exact match for package ID

4. **Progress Tracking**: Displays real-time installation status for each package with color-coded output (green for success, red for failures).

5. **Summary Report**: After all installations complete, displays:
   - Total number of successful installations
   - Total number of failed installations
   - List of failed packages (if any)

6. **Pause for Review**: Waits for user input before closing, allowing you to review the results.

## Customization

To add or remove packages, edit the `$packages` array in the script:

```powershell
$packages = @(
    @{ Name = "Publisher.PackageName"; DisplayName = "Friendly Name" },
    # Add more packages here
)
```

To find package IDs, use:
```powershell
winget search <application-name>
```

## Troubleshooting

### Winget Not Found
- Install winget from the Microsoft Store
- Ensure App Installer is up to date

### Package Installation Fails
- Check if the package ID is correct using `winget search`
- Some packages may require additional dependencies
- Check your internet connection
- Some packages may not be available in your region

### Script Won't Run
- Ensure you're running PowerShell (not Command Prompt)
- Check execution policy: `Get-ExecutionPolicy`
- Run with bypass: `powershell -ExecutionPolicy Bypass -File .\Winget.ps1`

## Notes

- Installation time varies depending on package sizes and internet speed
- Some packages may require system restart after installation
- You can safely run the script multiple times - winget will skip already installed packages
- The script automatically accepts all agreements for unattended installation

## License

This script is provided as-is for personal and educational use.
