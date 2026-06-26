```text
      _      _  __ _                           _ 
     | |    (_)/ _| |                         | |
   __| |_ __ _| |_| |___      _____   ___   __| |
  / _` | '__| |  _| __\ \ /\ / / _ \ / _ \ / _` |
 | (_| | |  | | | | |_ \ V  V / (_) | (_) | (_| |
  \__,_|_|  |_|_|  \__| \_/\_/ \___/ \___/ \__,_|
                                                 

     [ SHELLS -> TREES // FOLDERS -> PATHS ]
```

# driftwood

> A **POWERful** way from **SHELL**s to **TREE**s.

<br>

## Info
A pragmatic PowerShell script to tame unwieldy folder structures, limit path depths, and make the chaos readable.

---

## 📘 Quick Start: set up driftwood 

### Step 1: Create directory for the driftwood module

Open PowerShell, copy this block, and paste it completely. It creates the appropriate module folder and writes the code directly to the correct file:

```powershell

New-Item -ItemType Directory -Force -Path "$HOME\Documents\PowerShell\Modules\driftwood"

```

---

### Step 2: define code

```powershell
$Code = @'
function Show-Driftwood {
    param (
        [string]$Path = ".",
        [int]$MaxDepth = 2,
        [int]$CurrentDepth = 0
    )
    if ($CurrentDepth -eq 0) { 
        $Resolved = Resolve-Path $Path
        Write-Host "📂 Target: $Resolved" -ForegroundColor Cyan 
    }
    if ($CurrentDepth -ge $MaxDepth) { return }
    try {
        $Items = Get-ChildItem -Path $Path -ErrorAction SilentlyContinue
        $Count = $Items.Count
        $i = 0
        foreach ($Item in $Items) {
            $i++
            $Indent = "  " * $CurrentDepth
            $Branch = if ($i -eq $Count) { "└── " } else { "├── " }
            if ($Item.PSIsContainer) {
                Write-Host "${Indent}${Branch}📁 $($Item.Name)" -ForegroundColor Yellow
                Show-Driftwood -Path $Item.FullName -MaxDepth $MaxDepth -CurrentDepth ($CurrentDepth + 1)
            } else {
                Write-Host "${Indent}${Branch}📄 $($Item.Name)" -ForegroundColor Gray
            }
        }
    } catch {}
}
Export-ModuleMember -Function Show-Driftwood
'@
```

---

### Step 3: Write file as psm1 (module)

```powershell
Set-Content -Path "$HOME\Documents\PowerShell\Modules\driftwood\driftwood.psm1" -Value $Code -Encoding utf8
```

---

### Step 4: Activate the rights once

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

```

---

### Step 5: Create the clickable link with the actual logo

```powershell
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$HOME\Desktop\driftwood.lnk")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-NoExit -ExecutionPolicy Bypass -Command `"Import-Module '$HOME\Documents\PowerShell\Modules\driftwood\driftwood.psm1' -Force; cls; Write-Host '  _     _  __ _                     _ ' -ForegroundColor Cyan; Write-Host ' | |   (_)/ _| |___ __ __ ___   ___| |' -ForegroundColor Cyan; Write-Host ' | |__ ||| |_ | __|\ \ / // _ \ / _` |' -ForegroundColor Cyan; Write-Host ' | ' + [charpwd]39 + '_ \|||  _|| |_  \ V /| (_) | (_| |' -ForegroundColor Cyan; Write-Host ' |_.__/|||_|   \__|  \_/  \___/ \__,_|' -ForegroundColor Cyan; Write-Host '                                      ' -ForegroundColor Cyan; Write-Host '   [ SHELLS -> TREES // FOLDERS -> PATHS ]`n' -ForegroundColor DarkGray; `$p = Read-Host 'Target path? (Default: .)'; if([string]::IsNullOrEmpty(`$p)){`$p='.'}; `$t = Read-Host 'Max depth? (Default: 2)'; if([string]::IsNullOrEmpty(`$t)){`$t=2}; cls; Show-Driftwood -Path `$p -MaxDepth `$t`""
$Shortcut.IconLocation = "imageres.dll,67"
$Shortcut.Save()

```

<br>

---

<br>

## 🛠️ Alternative: Direct Execution (Without Installation)

If you don't want to install the module or create a desktop shortcut, you can run the standalone `driftwood.ps1` directly from this repository.

1. Download the `driftwood.ps1` file to your target folder.
2. Open PowerShell in that directory and unblock the script if necessary:
```powershell
Unblock-File .\driftwood.ps1
```
<br>

---
<br>

## Enjoy the uncomplicated path query 🪵🌊

<br>
