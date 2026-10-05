# Local environment for RimDevTools: .NET SDK on PATH and net472 reference assemblies for mod builds.
$env:DOTNET_ROOT = 'C:\Users\33775\Desktop\RimAgent观战\tools\dotnet'
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
if (-not ($env:PATH -split ';' -contains 'C:\Users\33775\Desktop\RimAgent观战\tools\dotnet')) { $env:PATH = 'C:\Users\33775\Desktop\RimAgent观战\tools\dotnet;' + $env:PATH }
$env:FrameworkPathOverride = Join-Path $PSScriptRoot 'ReferenceAssemblies\v4.7.2'
# FrameworkPathOverride skips the automatic netstandard facade that Unity assemblies need.
$env:AdditionalExplicitAssemblyReferences = 'System.Core;netstandard'
