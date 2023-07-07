$ErrorActionPreference = 'Stop'

$processName = 'ISx'
$processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
if ($processes) {
    Write-Warning "$processName is currently running, stopping it to prevent upgrade/uninstall from failing..."

    foreach ($process in $processes) {
        Stop-Process -InputObject $process -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 3
    }

    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Warning "$processName is still running despite stop request, force stopping it..."
        $processes | Stop-Process -Force -ErrorAction SilentlyContinue
    }

    Write-Warning "If upgrading, $processName may need to be manually restarted upon completion"
}
else {
    Write-Debug "No running $processName processes instances were found"
}
