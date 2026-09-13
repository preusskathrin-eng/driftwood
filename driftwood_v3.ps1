# Driftwood v3 - original UX + repeat queries
# PowerShell 7.x

function Show-Driftwood {
    param (
        [string]$Path = ".",
        [int]$MaxDepth = 2,
        [int]$CurrentDepth = 0,
        [string[]]$Include = @("*"),
        [switch]$OpenExplorer
    )

    if ($CurrentDepth -eq 0) {
        $Resolved = Resolve-Path -LiteralPath $Path
        Write-Host "📂 Target: $Resolved" -ForegroundColor Cyan
        if ($OpenExplorer) { explorer $Resolved }
    }

    if ($CurrentDepth -ge $MaxDepth) { return }

    try {
        $Items = Get-ChildItem -Path $Path -Include $Include -ErrorAction SilentlyContinue |
                 Sort-Object -Property @{Expression={$_.PSIsContainer}; Descending=$true}, Name

        $Count = @($Items).Count
        $i = 0

        foreach ($Item in $Items) {
            $i++
            $Indent = "  " * $CurrentDepth
            $Branch = if ($i -eq $Count) { "└── " } else { "├── " }

            if ($Item.PSIsContainer) {
                Write-Host "${Indent}${Branch}📁 $($Item.Name)" -ForegroundColor Yellow
                Show-Driftwood -Path $Item.FullName -MaxDepth $MaxDepth -CurrentDepth ($CurrentDepth + 1) -Include $Include
            }
            else {
                $Size = if ($Item.Length -gt 1MB) {
                    "{0:N1} MB" -f ($Item.Length / 1MB)
                }
                elseif ($Item.Length -gt 1KB) {
                    "{0:N1} KB" -f ($Item.Length / 1KB)
                }
                else {
                    "$($Item.Length) B"
                }

                Write-Host "${Indent}${Branch}📄 $($Item.Name) " -ForegroundColor Gray -NoNewline
                Write-Host "[$Size]" -ForegroundColor DarkGray
            }
        }
    }
    catch {
        Write-Host "Could not read target: $Path" -ForegroundColor Red
    }
}

function Show-DriftwoodHeader {
    Clear-Host

    try {
        $Host.UI.RawUI.WindowTitle = "driftwood"
    } catch {}

    Write-Host @"
      _      _  __ _                           _
     | |    (_)/ _| |                         | |
   __| |_ __ _| |_| |___      _____   ___   __| |
  / _`` | '__| |  _| __\ \ /\ / / _ \ / _ \ / _`` |
 | (_| | |  | | | | |_ \ V  V / (_) | (_) | (_| |
  \__,_|_|  |_|_|  \__| \_/\_/ \___/ \___/ \__,_|

"@ -ForegroundColor Cyan

    Write-Host "   [ SHELLS -> TREES // FOLDERS -> PATHS ]" -ForegroundColor DarkGray
    Write-Host ""
}

function Start-Driftwood {
    $LastPath = "."
    $LastDepth = 2
    $LastFilter = "*"
    $LastOpenExplorer = $false

    Show-DriftwoodHeader

    while ($true) {
        $PathInput = Read-Host "Target path? (Default: $LastPath)"
        if ([string]::IsNullOrWhiteSpace($PathInput)) {
            $PathToUse = $LastPath
        } else {
            $PathToUse = $PathInput.Trim()
        }

        if (-not (Test-Path -LiteralPath $PathToUse)) {
            Write-Host "Target path not found: $PathToUse" -ForegroundColor Red
            Write-Host ""
            continue
        }

        $DepthInput = Read-Host "Max depth? (Default: $LastDepth)"
        if ([string]::IsNullOrWhiteSpace($DepthInput)) {
            $DepthToUse = $LastDepth
        } else {
            $ParsedDepth = 0
            if ([int]::TryParse($DepthInput, [ref]$ParsedDepth) -and $ParsedDepth -ge 1) {
                $DepthToUse = $ParsedDepth
            } else {
                Write-Host "Invalid depth. Using default: $LastDepth" -ForegroundColor DarkYellow
                $DepthToUse = $LastDepth
            }
        }

        $FilterInput = Read-Host "Filter (Default: $LastFilter e.g. *.ps1,*.md)"
        if ([string]::IsNullOrWhiteSpace($FilterInput)) {
            $FilterText = $LastFilter
        } else {
            $FilterText = $FilterInput.Trim()
        }

        $Include = @(
            $FilterText -split "," |
            ForEach-Object { $_.Trim() } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
        )
        if ($Include.Count -eq 0) { $Include = @("*") }

        $ExplorerDefault = if ($LastOpenExplorer) { "Y/n" } else { "y/N" }
        $ExplorerInput = Read-Host "Open Explorer? ($ExplorerDefault)"
        if ([string]::IsNullOrWhiteSpace($ExplorerInput)) {
            $OpenExplorer = $LastOpenExplorer
        } else {
            $OpenExplorer = $ExplorerInput.Trim().ToLower() -in @("y", "yes", "j", "ja")
        }

        $LastPath = (Resolve-Path -LiteralPath $PathToUse).Path
        $LastDepth = $DepthToUse
        $LastFilter = $FilterText
        $LastOpenExplorer = $OpenExplorer

        Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
        Show-Driftwood -Path $LastPath -MaxDepth $LastDepth -Include $Include -OpenExplorer:$OpenExplorer
        Write-Host ""

        $Again = Read-Host "Run another query? (Y/n)"
        if (-not [string]::IsNullOrWhiteSpace($Again)) {
            $Choice = $Again.Trim().ToLower()
            if ($Choice -in @("n", "no", "nein", "q", "quit", "exit")) {
                break
            }
        }

        Write-Host ""
        # Continue with the same four familiar prompts.
        # Previous values are offered as defaults.
    }
}

Start-Driftwood
