# https://www.windowscentral.com/how-create-and-run-your-first-powershell-script-file-windows-10
# gcloud components install alpha
# gcloud components update
# https://cloud.google.com/compute/docs/connect/create-ssh-keys#windows-10-or-later
# https://www.simplified.guide/putty/convert-ssh-key-to-ppk
$ssh_config_file = "C:\Users\$env:USERNAME\.ssh\config"
Write-Output $ssh_config_file
$sshconf_ip = bin\search-ssh-config.exe "C:\Users\$env:USERNAME\.ssh\config" google-cloud-shell | Select-String -Pattern 'HostName'|ForEach-Object{($_ -split "\s+")[2]}
Write-Output "sshconf_ip: '$sshconf_ip'"
if ( $sshconf_ip -eq $null ) {
    Write-Output "ERROR: cannot determing sshconf_ip!"
    Exit
}
$current_cloud_ip = gcloud alpha cloud-shell ssh --dry-run | Select-String -Pattern 'google_compute_engine.ppk' |ForEach-Object{($_ -split "@")[1]} |ForEach-Object{($_ -split "\s+")[0]}
Write-Output "Current IP: $current_cloud_ip, SSH Config IP: $sshconf_ip"
if ( $current_cloud_ip -eq $sshconf_ip ) {
    Write-Output "IP is up to date"
} else {
    Write-Output "Updating IP in ssh config"
    $epoch = Get-Date -UFormat %s
    $ssh_config_backup = "$ssh_config_file.$epoch"
    Copy-Item -Path $ssh_config_file $ssh_config_backup
    $new_ssh_config = Get-Content $ssh_config_backup
    $new_ssh_config = $new_ssh_config -replace "$sshconf_ip","$current_cloud_ip" | Out-File -FilePath $ssh_config_file -Encoding ascii
    # Write-Output $new_ssh_config
}