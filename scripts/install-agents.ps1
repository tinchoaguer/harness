# Install harness agent definitions into a Cursor agents directory.
#
# Usage:
#   .\install-agents.ps1 -Source <harness-agents-dir> -Destination <cursor-agents-dir> [-Mode copy|symlink]
#
# Example:
#   .\install-agents.ps1 -Source ..\agents -Destination $env:USERPROFILE\.cursor\agents

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Source,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Destination,

    [ValidateSet("copy", "symlink")]
    [string]$Mode = "copy"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $Source -PathType Container)) {
    throw "Source directory does not exist: $Source"
}

$agentFiles = Get-ChildItem -LiteralPath $Source -Filter "*.md" -File
if ($agentFiles.Count -eq 0) {
    throw "No agent files (*.md) found in: $Source"
}

$resolvedSource = (Resolve-Path -LiteralPath $Source).Path

if (-not (Test-Path -LiteralPath $Destination)) {
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
}

$resolvedDestination = (Resolve-Path -LiteralPath $Destination).Path

foreach ($agentFile in $agentFiles) {
    $targetPath = Join-Path $resolvedDestination $agentFile.Name

    if (Test-Path -LiteralPath $targetPath) {
        Remove-Item -LiteralPath $targetPath -Force
    }

    if ($Mode -eq "symlink") {
        $sourcePath = Join-Path $resolvedSource $agentFile.Name
        New-Item -ItemType SymbolicLink -Path $targetPath -Target $sourcePath | Out-Null
        Write-Host "Linked $($agentFile.Name)"
    }
    else {
        Copy-Item -LiteralPath $agentFile.FullName -Destination $targetPath
        Write-Host "Copied $($agentFile.Name)"
    }
}

Write-Host "Installed $($agentFiles.Count) agent(s) from $resolvedSource to $resolvedDestination ($Mode)."
