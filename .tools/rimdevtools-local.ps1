# Runs RimDevTools for a project directory and passes its JSON output through.
param([string]$ProjectPath, [Parameter(ValueFromRemainingArguments = $true)][string[]]$ToolArgs)
. (Join-Path $PSScriptRoot 'use-local-env.ps1')
Push-Location -LiteralPath $ProjectPath
try { & (Join-Path $PSScriptRoot 'RimDevTools.exe') @ToolArgs; exit $LASTEXITCODE }
finally { Pop-Location }
