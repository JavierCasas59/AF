#!/bin/bash

# Crear directorio de evidencias con marca de tiempo
FECHA=$(date +"%Y%m%d_%H%M%S")
DESTINO="evidencias_forenses_$FECHA"
mkdir -p "$DESTINO"

echo "--- Iniciando Recolección de Evidencias Forenses ---"

# 1. Procesos en ejecución [cite: 119, 141]
ps aux > "$DESTINO/01_procesos.txt"
# 2. Servicios en ejecución
systemctl list-units --type=service --state=running > "$DESTINO/02_servicios.txt"
# 3. Usuarios iniciados y cuentas [cite: 125, 126]
who > "$DESTINO/03_usuarios_activos.txt"
cat /etc/passwd > "$DESTINO/03_lista_usuarios.txt"
# 4 & 5. Información y estado de red [cite: 121, 131, 142]
ifconfig -a > "$DESTINO/04_interfaces.txt"
netstat -tuln > "$DESTINO/04_puertos_abiertos.txt"
# 6 & 7. NetBIOS (En Linux vía Samba/nmblookup si aplica)
nmblookup -A 127.0.0.1 > "$DESTINO/06_netbios.txt" 2>/dev/null
# 8. Conexiones activas y puertos 
netstat -antp > "$DESTINO/08_conexiones_activas.txt"
# 9. Caché DNS (Requiere systemd-resolved)
resolvectl statistics > "$DESTINO/09_cache_dns.txt" 2>/dev/null
# 10. ARP Caché
arp -n > "$DESTINO/10_arp_cache.txt"
# 11. Tráfico de red (Muestra activa 10 segundos)
timeout 10s tcpdump -i any -c 100 -w "$DESTINO/11_trafico.pcap" 2>/dev/null
# 12. Registro de Linux (Logs) [cite: 128, 129]
dmesg > "$DESTINO/12_dmesg.txt"
journalctl -xe > "$DESTINO/12_journalctl.txt"
# 13. Dispositivos USB conectados
lsusb > "$DESTINO/13_usb_devices.txt"
# 14. Redes WIFI conectadas
nmcli connection show > "$DESTINO/14_redes_wifi.txt"
# 15. Conexiones establecidas por procesos [cite: 132]
lsof -i > "$DESTINO/15_lsof_procesos.txt"
# 16. Configuración del Firewall
iptables -L -n -v > "$DESTINO/16_firewall.txt"
# 17. Programas al inicio
ls -la /etc/init.d/ > "$DESTINO/17_inicio_sistema.txt"
# 18 & 19. Extensiones y Asociaciones (Mime-types)
gvfs-mime --list > "$DESTINO/18_asociaciones.txt" 2>/dev/null
# 20. Tabla de rutas
route -n > "$DESTINO/20_rutas.txt"
# 21. Archivos eliminados (intentar recuperar de descriptores)
lsof +L1 > "$DESTINO/21_archivos_borrados_abiertos.txt"
# 22. Inicio de sesión SSH
last | grep "pts" > "$DESTINO/22_logins_ssh.txt"
# 23. Buscar archivos ocultos
find /home -maxdepth 2 -name ".*" > "$DESTINO/23_archivos_ocultos.txt"
# 24. Ficheros abiertos recientemente
lsof -u $USER > "$DESTINO/24_ficheros_recientes.txt"
# 25. Software instalado [cite: 124, 143]
dpkg -l > "$DESTINO/25_software_instalado.txt"
# 26. Contraseñas (Verificación de Shadow - Hash)
cat /etc/shadow > "$DESTINO/26_shadow_hashes.txt"
# 27. Info cacheada navegadores (rutas comunes)
ls -R ~/.cache/google-chrome/ > "$DESTINO/27_cache_chrome.txt" 2>/dev/null
# 28. Árbol de directorios
ls -R / > "$DESTINO/28_arbol_directorios.txt" 2>/dev/null
# 29. Histórico de comandos [cite: 94]
cat ~/.bash_history > "$DESTINO/29_history.txt"
# 30. Captura de pantalla (Requiere scrot)
scrot "$DESTINO/30_screenshot.png" 2>/dev/null
# 31. Información portapapeles (Requiere xclip)
xclip -o > "$DESTINO/31_clipboard.txt" 2>/dev/null
# 32, 33, 34. Historial/Cookies (Firefox ejemplo)
find /home/ -name "places.sqlite" -o -name "cookies.sqlite" > "$DESTINO/32_db_navegador.txt"
# 35. Volúmenes cifrados
dmsetup ls > "$DESTINO/35_volumenes_cifrados.txt"
# 36 & 37. Unidades mapeadas y compartidas
mount > "$DESTINO/36_montajes.txt"
# 38. Grabaciones pendientes (Print Queue)
lpstat -p > "$DESTINO/38_impresiones.txt"

# 39 & 40 (Extras sugeridos [cite: 106]): 
# Info del Sistema (Kernel)  y Memoria libre
uname -a > "$DESTINO/39_kernel_info.txt"
free -m > "$DESTINO/40_memoria.txt"

echo "--- Recolección finalizada. ---"
