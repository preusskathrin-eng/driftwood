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
$ModulePath = "$HOME\Documents\PowerShell\Modules\driftwood\driftwood.psm1"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$HOME\Desktop\driftwood.lnk")
$Shortcut.TargetPath = "pwsh.exe"
$Shortcut.Arguments = "-NoExit -ExecutionPolicy Bypass -Command `"Import-Module '$ModulePath' -Force; cls; Write-Host 'DRIFTWOOD loaded ✓' -ForegroundColor Green; `$p = Read-Host 'Target path? (Default: .)'; if([string]::IsNullOrEmpty(`$p)){`$p='.'}; `$t = Read-Host 'Max depth? (Default: 2)'; if([string]::IsNullOrEmpty(`$t)){`$t=2}; `$f = Read-Host 'Filter (Default: *  e.g. *.ps1,*.md)'; if([string]::IsNullOrEmpty(`$f)){`$f='*'}; Show-Driftwood -Path `$p -MaxDepth `$t -Include `$f -OpenExplorer`""
$Shortcut.IconLocation = "imageres.dll,67"
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

## Alte Version (v1)

Die ursprüngliche, einfachere Version ohne Filter & Größenanzeige liegt hier:  
[`v1/README.md`](v1/README.md) oder im Commit-History.

---

## License

MIT

---

**Enjoy the uncomplicated path query** 🪵🌊
```
