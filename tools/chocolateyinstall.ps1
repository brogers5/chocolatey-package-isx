$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$archiveFileName = 'ISx-v0.3.10.7z'
$archiveFilePath = Join-Path -Path $toolsDir -ChildPath $archiveFileName

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileFullPath  = $archiveFilePath
}
Get-ChocolateyUnzip @packageArgs

$isxAmd64BinaryFilePath = Join-Path -Path $toolsDir -ChildPath 'ISx.exe'
$isxX86BinaryFilePath = Join-Path -Path $toolsDir -ChildPath 'ISx-x86.exe'
$pp = Get-PackageParameters
if ((Get-OSArchitectureWidth -Compare 64) -and ($env:chocolateyForceX86 -ne $true)) {
  if ($pp.ShimWithPlatform) {
    Install-BinFile -Name 'ISx-amd64' -Path $isxAmd64BinaryFilePath
  }
  if ($pp.SkipLegacyShim) {
    Write-Warning 'Legacy x86 shim is not applicable for 64-bit environments, ignoring SkipLegacyShim switch'
  }
}
else {
  if ($pp.ShimAllBinaries) {
    if ((Get-OSArchitectureWidth -Compare 32)) {
      Write-Warning 'amd64 binary is incompatible with current environment, ignoring ShimAllBinaries switch'
    }
    elseif ($env:chocolateyForceX86 -eq $true) {
      Write-Warning 'amd64 binary is not supported with forced x86 package behavior, ignoring ShimAllBinaries switch'
    }
  }

  if (!$pp.SkipLegacyShim) {
    Install-BinFile -Name 'ISx' -Path $isxX86BinaryFilePath
  }
  else {
    if (!$pp.ShimWithPlatform) {
      Write-Warning 'Forcing ShimWithPlatform switch behavior, as legacy shim creation is being skipped'
      $pp.ShimWithPlatform = $true
    }
  }

  if (!$pp.ShimWithPlatform) {
    Set-Content -Path "$isxX86BinaryFilePath.ignore" -Value $null -ErrorAction SilentlyContinue
  }
}

#Clean up unnecessary files to prevent disk bloat
Remove-Item -Path $archiveFilePath -Force -ErrorAction SilentlyContinue
if ((Get-OSArchitectureWidth -Compare 64) -and ($env:chocolateyForceX86 -ne $true)) {
  if (!$pp.ShimAllBinaries) {
    Remove-Item -Path $isxX86BinaryFilePath -Force -ErrorAction SilentlyContinue
  }
}
elseif ((Get-OSArchitectureWidth -Compare 32) -or ($env:chocolateyForceX86 -eq $true)) {
  Remove-Item -Path $isxAmd64BinaryFilePath -Force -ErrorAction SilentlyContinue
}
