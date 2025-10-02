$vid = "VID_2833"
$lastState = $null
Write-Host  ------------------------------------------------------------------------------------------
#Write-Host "  1. Connect or disconnect the cable from the PC to the headset."
#Write-Host "  2. Watch the messages in this window, they should indicate the connection or disconnection of the cable."
#Write-Host "  3. If there are no messages, change the cable or USB port."
#Write-Host ""
#Write-Host "     When you decide to finish, press 'q' or 'Esc' to quit..."
#Write-Host ------------------------------------------------------------------------------------------------------------
$ErrorActionPreference = "SilentlyContinue"

while ($true) {
    # Check devices by VID
    $dev = Get-PnpDevice | Where-Object { $_.InstanceId -like "*$vid*" -and $_.Status -eq "OK" }
    $currentState = if ($dev) { "connected" } else { "disconnected" }

    if ($currentState -ne $lastState) {
        $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Write-Output "$time USB $vid $currentState"
        $lastState = $currentState
    }

    # Quit by Q or Esc
    if ([Console]::KeyAvailable) {
        $key = [Console]::ReadKey($true)
        if ($key.Key -eq "Q" -or $key.Key -eq "Escape") { break }
    }
}
