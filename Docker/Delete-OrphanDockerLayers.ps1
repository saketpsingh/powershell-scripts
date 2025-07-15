$folders = Get-ChildItem "C:\ProgramData\docker\windowsfilter" -Directory | Where-Object { $_.Name -like "*-removing" }

foreach ($folder in $folders) {
    Write-Host "Fixing permissions and deleting: $($folder.FullName)"
    takeown /f $folder.FullName /r /d y | Out-Null
    icacls $folder.FullName /grant Administrators:F /t /c | Out-Null
    try {
        Remove-Item $folder.FullName -Recurse -Force -ErrorAction Stop
    } catch {
        Write-Warning "Failed to delete $($folder.FullName): $_"
    }
}
