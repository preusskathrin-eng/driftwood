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

Eine pragmatische PowerShell-Tool zum schnellen Überblick über Ordnerstrukturen – mit Tiefenlimit, Dateifiltern, Größenanzeige und optionalem Explorer-Öffnen.

---

## ✨ Features

- Schöne baumartige Ausgabe mit Ordner/Datei-Unterscheidung
- Begrenzte Rekursionstiefe (`-MaxDepth`)
- Dateifilter (`-Include *.ps1,*.md`)
- Dateigrößenanzeige (B / KB / MB)
- Automatisches Öffnen des Zielordners im Explorer
- Desktop-Shortcut mit interaktiven Prompts
- Saubere Sortierung (Ordner zuerst)

---

## ⚠️ Voraussetzungen

- **PowerShell 7.0 oder neuer** (`pwsh.exe`)
- ExecutionPolicy `RemoteSigned` (einmalig):

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

---

## 📘 Quick Start

### 1. Modul installieren

```powershell
# Modul-Ordner anlegen
New-Item -ItemType Directory -Force -Path "$HOME\Documents\PowerShell\Modules\driftwood"
```

### 2. Aktuellen Code in driftwood.psm1 einfügen

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

### 3. Desktop-Shortcut erstellen

```powershell
$ModuleDir = "$HOME\Documents\PowerShell\Modules\driftwood"

# 1. Den optimierten Launcher ohne das zerstörerische zweite "cls" definieren
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

# 2. Datei schreiben
[System.IO.File]::WriteAllLines("$ModuleDir\driftwood-launcher.ps1", $Lines)

# 3. Shortcut verknüpfen
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$HOME\Desktop\driftwood.lnk")
$Shortcut.TargetPath = "pwsh.exe"
$Shortcut.Arguments = "-NoExit -ExecutionPolicy Bypass -File `"$ModuleDir\driftwood-launcher.ps1`""
$Shortcut.IconLocation = "pwsh.exe,0"
$Shortcut.Save()

Write-Host "✅ Neuer driftwood-Shortcut wurde erstellt!" -ForegroundColor Green
Write-Host "Teste ihn jetzt per Doppelklick." -ForegroundColor Cyan
```

---

## Beispielaufrufe

```powershell
Show-Driftwood -Path "C:\Projects" -MaxDepth 3
Show-Driftwood -Path "." -MaxDepth 2 -Include "*.ps1","*.md" -OpenExplorer
```

---

## 🛠️ Alternative: Direkte Ausführung (ohne Installation)

Wenn du das Modul nicht installieren oder keinen Desktop-Shortcut willst, kannst du eine standalone `driftwood_v2.ps1` nutzen:

1. Lade die `driftwood_v2.ps1` Datei aus dem Repo herunter und lege sie in den gewünschten Ordner.
2. Öffne PowerShell **in diesem Ordner** und entsperre das Skript falls nötig:

```powershell
Unblock-File .\driftwood_v2.ps1
```

3. Starte es mit:

```powershell
.\driftwood_v2.ps1
```

---

## Alte Version (v1)

Die ursprüngliche, einfachere Version ohne Filter & Größenanzeige liegt hier:  
[`v1/README.md`](v1/README.md) oder im Commit-History.

---

## License

MIT

---

**Enjoy the uncomplicated path query** 🪵🌊
