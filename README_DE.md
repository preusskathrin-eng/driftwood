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

*(kopiere die Funktion `Show-Driftwood` aus dem Repo in die Datei)*

### 3. Desktop-Shortcut erstellen

*(nutze den aktuellen Creator-Block aus dem Repo oder den Wrapper)*

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
