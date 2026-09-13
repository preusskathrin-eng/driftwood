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

A pragmatic PowerShell tool for a quick overview of folder structures – with depth limit, file filters, size display, optional Explorer opening, and repeated queries without restarting the script.

---

## ✨ Features

- Attractive tree-like output with folder/file differentiation
- Limited recursion depth (`-MaxDepth`)
- File filter (`-Include *.ps1,*.md`)
- File size display (B / KB / MB)
- Automatic opening of the target folder in Explorer
- Desktop shortcut with interactive prompts
- Clean sorting (folders first)
- **New in v3:** run multiple queries in one session
- Previous path, depth, filter and Explorer preference are offered as defaults for the next query

---

## ⚠️ Requirements

- **PowerShell 7.0 or later** (`pwsh.exe`)

- ExecutionPolicy `RemoteSigned` (one-time requirement):

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

---

## 🚀 Quick Start

### Direct execution

Download `driftwood_v3.ps1`, then run:

```powershell
pwsh.exe -NoExit -ExecutionPolicy Bypass -File ".\driftwood_v3.ps1"
```

The interactive prompts are:

```text
Target path? (Default: .)
Max depth? (Default: 2)
Filter (Default: * e.g. *.ps1,*.md)
Open Explorer? (y/N)
```

After each result:

```text
Run another query? (Y/n)
```

Press Enter or `y` to continue. The previous values become the defaults for the next query. Use `n` or `q` to exit.

---

## 🖥️ Desktop shortcut

Create a shortcut with this target:

```text
pwsh.exe -NoExit -ExecutionPolicy Bypass -File "C:\path\to\driftwood\driftwood_v3.ps1"
```

Example:

```text
pwsh.exe -NoExit -ExecutionPolicy Bypass -File "C:\Users\YourName\Documents\driftwood\driftwood_v3.ps1"
```

---

## Example calls

The script is designed primarily for interactive use, but the core function still supports direct calls:

```powershell
Show-Driftwood -Path "C:\Projects" -MaxDepth 3
Show-Driftwood -Path "." -MaxDepth 2 -Include "*.ps1","*.md" -OpenExplorer
```

---

## Previous versions

- `driftwood_v2.ps1` — single interactive query
- `v1/` — original simpler version without filters and size display

---

## License

MIT

---

**Enjoy the uncomplicated path query** 🪵🌊
