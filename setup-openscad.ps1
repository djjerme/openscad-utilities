param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$workspaceRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$installRoot = Join-Path $workspaceRoot "tools\OpenSCAD"
$version = "2021.01"
$archiveName = "OpenSCAD-$version-x86-64.zip"
$archiveUrl = "https://files.openscad.org/$archiveName"
$checksumUrl = "$archiveUrl.sha256"
$archivePath = Join-Path $installRoot $archiveName
$checksumPath = Join-Path $installRoot "$archiveName.sha256"
$extractRoot = Join-Path $installRoot "OpenSCAD-$version-x86-64"
$appRoot = Join-Path $extractRoot "openscad-$version"
$exePath = Join-Path $appRoot "openscad.com"

if ((Test-Path $exePath) -and -not $Force) {
    Write-Host "OpenSCAD is already installed at:"
    Write-Host "  $exePath"
    Write-Host "Use -Force to redownload and reinstall."
    exit 0
}

New-Item -ItemType Directory -Force -Path $installRoot | Out-Null

Write-Host "Downloading OpenSCAD $version..."
Invoke-WebRequest -Uri $archiveUrl -OutFile $archivePath
Invoke-WebRequest -Uri $checksumUrl -OutFile $checksumPath

$expected = ((Get-Content $checksumPath | Select-Object -First 1).Split(" ")[0]).Trim().ToLower()
$actual = (Get-FileHash -Algorithm SHA256 $archivePath).Hash.Trim().ToLower()

if ($expected -ne $actual) {
    throw "SHA256 mismatch. Expected $expected but got $actual"
}

if (Test-Path $extractRoot) {
    Remove-Item -Recurse -Force $extractRoot
}

Write-Host "Extracting OpenSCAD..."
Expand-Archive -Path $archivePath -DestinationPath $extractRoot -Force

if (-not (Test-Path $exePath)) {
    throw "Install completed, but the executable was not found at $exePath"
}

Write-Host "OpenSCAD installed successfully:"
Write-Host "  $exePath"
