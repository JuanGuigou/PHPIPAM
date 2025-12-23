# PHPIPAM
Automatismo Instalación en Debian IPAM

# 1. Descarga el archivo
git clone https://github.com/JuanGuigou/PHPIPAM.git
# 2. Dale permisos de ejecución
chmod +x phpipam-installer.sh

# 3. Ejecútalo con sudo
sudo ./phpipam-installer.sh

# 4. Entrar a SQL
mysql -u root -p

# 5. Cambiar usuario root
ALTER USER 'root'@'localhost' IDENTIFIED BY 'NuevaPasswordSegura123';
FLUSH PRIVILEGES;
EXIT;
