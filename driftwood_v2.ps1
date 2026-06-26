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
