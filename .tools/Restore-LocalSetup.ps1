# Rebuilds the local-only parts of this toolchain after a fresh clone:
# net472 reference assemblies (from NuGet), the CLI, the tool-mod data and the game DLLs the tool mods compile against.
param([string]$RimWorldDir = 'D:\steam\steamapps\common\RimWorld')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot
. (Join-Path $PSScriptRoot 'use-local-env.ps1')
$ref = Join-Path $PSScriptRoot 'ReferenceAssemblies\v4.7.2'
if (-not (Test-Path (Join-Path $ref 'mscorlib.dll'))) {
    $tmp = Join-Path ([IO.Path]::GetTempPath()) ('rimdev-ref-' + [Guid]::NewGuid())
    New-Item -ItemType Directory $tmp | Out-Null
    Set-Content (Join-Path $tmp 'ref.csproj') '<Project Sdk="Microsoft.NET.Sdk"><PropertyGroup><TargetFramework>net472</TargetFramework></PropertyGroup><ItemGroup><PackageReference Include="Microsoft.NETFramework.ReferenceAssemblies.net472" Version="1.0.3" /></ItemGroup></Project>'
    dotnet restore (Join-Path $tmp 'ref.csproj') --packages (Join-Path $tmp 'pkgs') | Out-Null
    $src = Get-ChildItem (Join-Path $tmp 'pkgs') -Recurse -Directory -Filter 'v4.7.2' | Select-Object -First 1
    New-Item -ItemType Directory -Force $ref | Out-Null
    Copy-Item (Join-Path $src.FullName '*') $ref -Recurse -Force
    Copy-Item (Join-Path $ref 'Facades\netstandard.dll') $ref -Force
}
$gamedll = Join-Path $root '参考文档\gamedll'
New-Item -ItemType Directory -Force $gamedll | Out-Null
Copy-Item (Join-Path $RimWorldDir 'RimWorldWin64_Data\Managed\*.dll') $gamedll -Force
$harmony = Get-ChildItem (Join-Path $RimWorldDir '..\..\workshop\content\294100\2009463077\Current\Assemblies\0Harmony.dll') -ErrorAction SilentlyContinue
if ($harmony) { Copy-Item $harmony.FullName $gamedll -Force }
# The package script fails at the ILSpy step when .tools\ilspy is absent; the CLI and tool-mod data are produced before that.
& pwsh -NoProfile -File (Join-Path $PSScriptRoot 'publish-rimdevtools.ps1')
$pkg = Join-Path $root 'artifacts\RimDevTools-Package\.tools'
Copy-Item (Join-Path $pkg 'RimDevTools.exe') $PSScriptRoot -Force
Copy-Item (Join-Path $pkg 'Data') $PSScriptRoot -Recurse -Force
