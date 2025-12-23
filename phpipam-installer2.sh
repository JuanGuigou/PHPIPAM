#!/bin/bash

echo "=========================================="
echo " Preparando entorno para phpIPAM (Wizard)"
echo "=========================================="

# 1. Instalación de dependencias
echo "[+] Instalando Apache, MariaDB y módulos PHP..."
sudo apt update
sudo apt install -y apache2 mariadb-server git \
php php-mysql php-gmp php-gd php-ldap php-curl php-pear php-snmp php-mbstring php-common php-xml php-zip

# 2. Descarga de phpIPAM
echo "[+] Descargando código fuente..."
cd /var/www/html
sudo rm -f index.html
sudo git clone https://github.com/phpipam/phpipam.git .
sudo git checkout $(git describe --tags $(git rev-list --tags --max-count=1))

# 3. Preparar el archivo de configuración (Solo copia el ejemplo)
echo "[+] Creando archivo de configuración inicial..."
sudo cp config.dist.php config.php

# 4. Ajuste de permisos (CRUCIAL para que el Wizard pueda escribir)
echo "[+] Ajustando permisos de carpetas..."
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

# 5. Configurar Apache
echo "[+] Habilitando mod_rewrite y reiniciando..."
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "=========================================="
echo " LISTO PARA EL WIZARD "
echo "=========================================="
echo "Accede a: http://$(hostname -I | awk '{print $1}')"
echo "------------------------------------------"
echo "En el Wizard, elige: 'New phpipam installation'"
echo "Luego elige: 'Automatic database installation'"
echo "El Wizard te pedirá el usuario ROOT de MySQL para crear todo."
echo "=========================================="