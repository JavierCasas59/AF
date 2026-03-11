@echo off
setlocal enabledelayedexpansion
cls
set "EV=%cd%\evidencias"
mkdir "%EV%" 2>nul
set "SW=%cd%\software"

:: 1-5. Procesos, Servicios, Usuarios, Red, Estado
tasklist /v > "%EV%\01_Procesos.txt"
sc query > "%EV%\02_Servicios.txt"
query user > "%EV%\03_Usuarios.txt"
ipconfig /all > "%EV%\04_05_Red_Estado.txt"

:: 6-8. NetBIOS, Conexiones, Puertos
nbtstat -S > "%EV%\06_NetBIOS.txt"
net session > "%EV%\07_Ficheros_NetBIOS.txt"
netstat -anob > "%EV%\08_Puertos_Conexiones.txt"

:: 9-11. DNS, ARP, Trafico (Trafico requiere herramienta externa, se usa netsh como base)
ipconfig /displaydns > "%EV%\09_DNS.txt"
arp -a > "%EV%\10_ARP.txt"
netsh trace start capture=yes persistent=no > "%EV%\11_Trafico.txt" 2>nul

:: 12-14. Registro, USB, WIFI
reg export HKLM "%EV%\12_Registro_HKLM.reg" /y 2>nul
if exist "%SW%\USBDeview.exe" "%SW%\USBDeview.exe" /shtml "%EV%\13_USB.html"
netsh wlan show profiles > "%EV%\14_WIFI.txt"

:: 15-17. Security Center, Firewall, Inicio
netsh advfirewall show allprofiles > "%EV%\16_Firewall.txt"
reg export "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" "%EV%\17_Inicio.reg" /y

:: 18-24. Asociaciones, BHO, MUICache, MRU, Ficheros recientes
reg export "HKLM\Software\Classes" "%EV%\18_Asociaciones.reg" /y
reg export "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects" "%EV%\20_BHO.reg" /y
reg export "HKCU\Software\Classes\LocalSettings\Software\Microsoft\Windows\Shell\MuiCache" "%EV%\21_MUICache.reg" /y
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs" "%EV%\24_Recientes.reg" /y

:: 25-27. Software, Contraseñas (Nota: requiere software especializado), Cache Navegador
reg export "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" "%EV%\25_Software.reg" /y
dir /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" > "%EV%\27_CacheNavegador.txt" 2>nul

:: 28-34. Arbol directorios, Historial, Capturas (requiere nircmd), Cookies
dir /s C:\ > "%EV%\28_ArbolDirectorios.txt" 2>nul
copy "%USERPROFILE%\AppData\Local\Microsoft\Windows\History" "%EV%\32_Historial" 2>nul
dir /s "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cookies" > "%EV%\34_Cookies.txt" 2>nul

:: 35-38. Cifrado, Unidades mapeadas, Compartidas, Impresiones
manage-bde -status > "%EV%\35_Cifrado.txt" 2>nul
net use > "%EV%\36_UnidadesMapeadas.txt"
net share > "%EV%\37_Compartidas.txt"
powershell "Get-PrintJob | Format-List" > "%EV%\38_Impresiones.txt" 2>nul

:: 39-40. Extras solicitados (1: Variables de entorno, 2: Auditoría de ejecutables)
set > "%EV%\39_VariablesEntorno.txt"
dir C:\Windows\System32\*.exe /od > "%EV%\40_AuditoriaEjecutables.txt"

echo [FINALIZADO] Evidencias en %EV%
pause