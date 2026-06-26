```text
      _      _  __ _                           _ 
     | |    (_)/ _| |                         | |
   __| |_ __ _| |_| |___      _____   ___   __| |
  / _` | '__| |  _| __\ \ /\ / / _ \ / _ \ / _` |
 | (_| | |  | | | | |_ \ V  V / (_) | (_) | (_| |
  \__,_|_|  |_|_|  \__| \_/\_/ \___/ \___/ \__,_|
                                                  
   [ SHELLS -> TREES // FOLDERS -> PATHS ]
```

# driftwood v2

> A **POWERful** way from **SHELL**s to **TREE**s.

A pragmatic PowerShell tool for a quick overview of folder structures – with depth limit, file filters, size display and optional Explorer opening.

---

## ✨ Features

- Attractive tree-like output with folder/file differentiation
- Limited recursion depth (`-MaxDepth`)
- File filter (`-Include *.ps1,*.md`)
- File size display (B / KB / MB)
- Automatic opening of the target folder in Explorer
- Desktop shortcut with interactive prompts
- Clean sorting (folders first)

---

## ⚠️ Requirements

- **PowerShell 7.0 or later** (`pwsh.exe`)

- ExecutionPolicy `RemoteSigned` (one-time requirement):

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

---

## 📘 Quick Start

### 1. Install module

```powershell
# Create module folder
New-Item -ItemType Directory -Force -Path "$HOME\Documents\PowerShell\Modules\driftwood"
```

### 2. Insert current code into driftwood.psm1

```powershell
$Code = @'
function Show-Driftwood {
    param (
        [string]$Path = ".",
        [int]$MaxDepth = 2,
        [int]$CurrentDepth = 0,
        [string[]]$Include = @("*"),   # z.B. "*.ps1","*.md"
        [switch]$OpenExplorer
    )

    if ($CurrentDepth -eq 0) { 
        $Resolved = Resolve-Path $Path
        Write-Host "📂 Target: $Resolved" -ForegroundColor Cyan 
        if ($OpenExplorer) { explorer $Resolved }
    }

    if ($CurrentDepth -ge $MaxDepth) { return }

    try {
        $Items = Get-ChildItem -Path $Path -Include $Include -ErrorAction SilentlyContinue |
                 Sort-Object -Property @{Expression={$_.PSIsContainer}; Descending=$true}, Name

        $Count = $Items.Count
        $i = 0

        foreach ($Item in $Items) {
            $i++
            $Indent = "  " * $CurrentDepth
            $Branch = if ($i -eq $Count) { "└── " } else { "├── " }

            if ($Item.PSIsContainer) {
                Write-Host "${Indent}${Branch}📁 $($Item.Name)" -ForegroundColor Yellow
                Show-Driftwood -Path $Item.FullName -MaxDepth $MaxDepth -CurrentDepth ($CurrentDepth + 1) -Include $Include
            } else {
                $Size = if ($Item.Length -gt 1MB) { 
                            "{0:N1} MB" -f ($Item.Length / 1MB) 
                        } elseif ($Item.Length -gt 1KB) { 
                            "{0:N1} KB" -f ($Item.Length / 1KB) 
                        } else { 
                            "$($Item.Length) B" 
                        }
                Write-Host "${Indent}${Branch}📄 $($Item.Name) " -ForegroundColor Gray -NoNewline
                Write-Host "[$Size]" -ForegroundColor DarkGray
            }
        }
    } catch {}
}

Export-ModuleMember -Function Show-Driftwood
'@
```

### 3. Create a desktop shortcut

```powershell
$ModuleDir = "$HOME\Documents\PowerShell\Modules\driftwood"

# 1. Define the optimized launcher without the destructive second "cls"
$Lines = @(
    "Import-Module '$HOME\Documents\PowerShell\Modules\driftwood\driftwood.psm1' -Force",
    "cls",
    "Write-Host '     _      _  __ _                           _ ' -ForegroundColor Cyan",
    "Write-Host '    | |    (_)/ _| |                         | |' -ForegroundColor Cyan",
    "Write-Host '  __| |_ __ _| |_| |___      _____   ___   __| |' -ForegroundColor Cyan",
    "Write-Host ' / _  | ___| |  _| __\ \ /\ / / _ \ / _ \ / _  |' -ForegroundColor Cyan",
    "Write-Host '| (_| | |  | | | | |_ \ V  V / (_) | (_) | (_| |' -ForegroundColor Cyan",
    "Write-Host ' \__,_|_|  |_|_|  \__| \_/\_/ \___/ \___/ \__,_|' -ForegroundColor Cyan",
    "Write-Host '                                                ' -ForegroundColor Cyan",
    "Write-Host '   [ SHELLS -> TREES // FOLDERS -> PATHS ]' -ForegroundColor DarkGray",
    "Write-Host ''",
    "`$p = Read-Host 'Target path? (Default: .)'",
    "if([string]::IsNullOrEmpty(`$p)){`$p='.'}",
    "`$t = Read-Host 'Max depth? (Default: 2)'",
    "if([string]::IsNullOrEmpty(`$t)){`$t=2}",
    "`$f = Read-Host 'Filter (Default: * e.g. *.ps1,*.md)'",
    "if([string]::IsNullOrEmpty(`$f)){`$f='*'}",
    "`$e = Read-Host 'Open Explorer? (y/N)'",
    "Write-Host '------------------------------------------------' -ForegroundColor DarkGray",
    "if(`$e -eq 'y'){ Show-Driftwood -Path `$p -MaxDepth `$t -Include `$f -OpenExplorer } else { Show-Driftwood -Path `$p -MaxDepth `$t -Include `$f }"
)

# 2. Write file
[System.IO.File]::WriteAllLines("$ModuleDir\driftwood-launcher.ps1", $Lines)

# 3. Link Shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$HOME\Desktop\driftwood.lnk")
$Shortcut.TargetPath = "pwsh.exe"
$Shortcut.Arguments = "-NoExit -ExecutionPolicy Bypass -File `"$ModuleDir\driftwood-launcher.ps1`""
$Shortcut.IconLocation = "pwsh.exe,0"
$Shortcut.Save()

Write-Host "✅ driftwood v2 shortcut created!" -ForegroundColor Green
```

---

## Example calls

```powershell
Show-Driftwood -Path "C:\Projects" -MaxDepth 3
Show-Driftwood -Path "." -MaxDepth 2 -Include "*.ps1","*.md" -OpenExplorer
```

---

## 🛠️ Alternative: Direct Execution (Without Installation)

If you don't want to install the module or create a desktop shortcut, you can use a standalone `driftwood_v2.ps1`:

1. Download the `driftwood_v2.ps1` file from the repository and place it in the desired folder.

2. Open PowerShell **in this folder** and unlock the script if necessary:

```powershell
Unblock-File .\driftwood_v2.ps1
```

3. Run with:

```powershell
.\driftwood_v2.ps1
```

---
## Old Version (v1)

The original, simpler version without filters and size display is located here:

[`v1/README.md`](v1/README.md) or in the commit history.

---

## License

MIT

---

**Enjoy the uncomplicated path query** 🪵🌊
