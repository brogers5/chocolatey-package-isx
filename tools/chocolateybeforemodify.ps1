$ErrorActionPreference = 'Stop'

$processName = 'ISx*'
$softwareName = 'ISx'
$processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
if ($processes) {
    Write-Warning "$softwareName is currently running, stopping it to prevent upgrade/uninstall from failing..."

    foreach ($process in $processes) {
        Stop-Process -InputObject $process -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 3
    }

    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Warning "$softwareName is still running despite stop request, force stopping it..."
        $processes | Stop-Process -Force -ErrorAction SilentlyContinue
    }

    Write-Warning "If upgrading, $softwareName may need to be manually restarted upon completion"
}
else {
    Write-Debug "No running $softwareName process instances were found"
}
