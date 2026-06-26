<#
      _      _  __ _                           _ 
     | |    (_)/ _| |                         | |
   __| |_ __ _| |_| |___      _____   ___   __| |
  / _` | '__| |  _| __\ \ /\ / / _ \ / _ \ / _` |
 | (_| | |  | | | | |_ \ V  V / (_) | (_) | (_| |
  \__,_|_|  |_|_|  \__| \_/\_/ \___/ \___/ \__,_|
                                                 
                                                 
   [ SHELLS -> TREES // FOLDERS -> PATHS ]
#>


function Show-Driftwood {
    param (
        [string]$Path = ".",
        [int]$MaxDepth = 2,
        [int]$CurrentDepth = 0
    )

    # Header beim ersten Aufruf anzeigen
    if ($CurrentDepth -eq 0) { 
        $Resolved = Resolve-Path $Path
        Write-Host "📂 Target: $Resolved" -ForegroundColor Cyan 
    }

    # Abbruchbedingung für die Tiefe
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
                # Rekursiver Aufruf für Unterordner
                Show-Driftwood -Path $Item.FullName -MaxDepth $MaxDepth -CurrentDepth ($CurrentDepth + 1)
            } else {
                Write-Host "${Indent}${Branch}📄 $($Item.Name)" -ForegroundColor Gray
            }
        }
    } catch {}
}

# --- AUTOMATIC EXECUTION ON RUN ---
# Executes the function immediately in the current directory when the script is called.
Show-Driftwood -Path "." -MaxDepth 2
