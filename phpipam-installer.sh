#!/bin/bash

# --- CONFIGURACIÓN DE VARIABLES ---
DB_NAME="phpipam"
DB_USER="phpipam"
DB_PASS="TuPasswordSeguro123" # CAMBIA ESTO
PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;' 2>/dev/null || echo "8.1")

echo "=========================================="
echo " Instalador Automático de phpIPAM"
echo "=========================================="

# 1. Instalación de dependencias
echo "[+] Instalando dependencias (Apache, MariaDB, PHP)..."
apt update
apt install -y apache2 mariadb-server git \
php php-mysql php-gmp php-gd php-ldap php-curl php-pear php-snmp php-mbstring php-common php-xml php-zip

# 2. Configuración de Base de Datos
echo "[+] Configurando MariaDB..."
mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# 3. Descarga de phpIPAM
echo "[+] Descargando phpIPAM desde GitHub..."
cd /var/www/html
rm -rf index.html # Elimina el default de Apache
git clone https://github.com/phpipam/phpipam.git .
git checkout $(git describe --tags $(git rev-list --tags --max-count=1))

# 4. Configuración del archivo config.php
echo "[+] Configurando archivo config.php..."
cp config.dist.php config.php
sed -i "s/\$db\['user'\] = 'phpipam';/\$db\['user'\] = '$DB_USER';/" config.php
sed -i "s/\$db\['pass'\] = 'phpipamadmin';/\$db\['pass'\] = '$DB_PASS';/" config.php
sed -i "s/\$db\['name'\] = 'phpipam';/\$db\['name'\] = '$DB_NAME';/" config.php

# 5. Permisos y Apache
echo "[+] Ajustando permisos y mod_rewrite..."
chown -R www-data:www-data /var/www/html
a2enmod rewrite

# Crear archivo .htaccess si no existe para asegurar el funcionamiento de las URLs
if [ ! -f /var/www/html/.htaccess ]; then
    cp /var/www/html/php.ini.dist /var/www/html/.htaccess 2>/dev/null || true
fi

# 6. Reinicio de servicios
systemctl restart apache2

echo "=========================================="
echo " INSTALACIÓN COMPLETADA "
echo "=========================================="
echo "1. Accede a: http://$(hostname -I | awk '{print $1}')"
echo "2. Elige: 'New phpipam installation'"
echo "3. Selecciona: 'Automatic database installation'"
echo "4. Usa los siguientes datos:"
echo "   - MySQL User: $DB_USER"
echo "   - MySQL Pass: $DB_PASS"
echo "   - MySQL DB: $DB_NAME"
echo "=========================================="