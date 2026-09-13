```text
      _      _  __ _                           _ 
     | |    (_)/ _| |                         | |
   __| |_ __ _| |_| |___      _____   ___   __| |
  / _` | '__| |  _| __\ \ /\ / / _ \ / _ \ / _` |
 | (_| | |  | | | | |_ \ V  V / (_) | (_) | (_| |
  \__,_|_|  |_|_|  \__| \_/\_/ \___/ \___/ \__,_|
                                                  
   [ SHELLS -> TREES // FOLDERS -> PATHS ]
```

# driftwood v3

> A **POWERful** way from **SHELL**s to **TREE**s.

Ein pragmatisches PowerShell-Tool für den schnellen Überblick über Ordnerstrukturen – mit Tiefenlimit, Dateifiltern, Größenanzeige, optionalem Explorer-Öffnen und mehreren Abfragen ohne Neustart des Skripts.

---

## ✨ Features

- Schöne baumartige Ausgabe mit Ordner/Datei-Unterscheidung
- Begrenzte Rekursionstiefe (`-MaxDepth`)
- Dateifilter (`-Include *.ps1,*.md`)
- Dateigrößenanzeige (B / KB / MB)
- Automatisches Öffnen des Zielordners im Explorer
- Desktop-Shortcut mit interaktiven Prompts
- Saubere Sortierung (Ordner zuerst)
- **Neu in v3:** mehrere Abfragen in derselben Sitzung
- Letzter Pfad, Tiefe, Filter und Explorer-Einstellung werden als neue Defaults angeboten

---

## ⚠️ Voraussetzungen

- **PowerShell 7.0 oder neuer** (`pwsh.exe`)

- ExecutionPolicy `RemoteSigned` (einmalig):

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

---

## 🚀 Quick Start

### Direkte Ausführung

`driftwood_v3.ps1` herunterladen und starten mit:

```powershell
pwsh.exe -NoExit -ExecutionPolicy Bypass -File ".\driftwood_v3.ps1"
```

Die interaktiven Abfragen bleiben wie in v2:

```text
Target path? (Default: .)
Max depth? (Default: 2)
Filter (Default: * e.g. *.ps1,*.md)
Open Explorer? (y/N)
```

Nach jeder Ausgabe folgt neu:

```text
Run another query? (Y/n)
```

Enter oder `y` startet die nächste Abfrage. Die letzten Werte werden dabei als Defaults übernommen. Mit `n` oder `q` wird beendet.

---

## 🖥️ Desktop-Verknüpfung

Als Ziel der Verknüpfung:

```text
pwsh.exe -NoExit -ExecutionPolicy Bypass -File "C:\Pfad\zu\driftwood\driftwood_v3.ps1"
```

Beispiel:

```text
pwsh.exe -NoExit -ExecutionPolicy Bypass -File "C:\Users\DeinName\Documents\driftwood\driftwood_v3.ps1"
```

---

## Beispielaufrufe

Das Skript ist primär für die interaktive Nutzung gedacht. Die Kernfunktion lässt sich weiterhin direkt aufrufen:

```powershell
Show-Driftwood -Path "C:\Projects" -MaxDepth 3
Show-Driftwood -Path "." -MaxDepth 2 -Include "*.ps1","*.md" -OpenExplorer
```

---

## Frühere Versionen

- `driftwood_v2.ps1` — eine einzelne interaktive Abfrage
- `v1/` — ursprüngliche einfachere Version ohne Filter und Größenanzeige

---

## License

MIT

---

**Enjoy the uncomplicated path query** 🪵🌊
