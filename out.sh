#!/usr/bin/env bash

#
# Sergio Yamuza - Sopinet
# Fernando Hidalgo - Sopinet
# 18 - Febrero - 2013
# Script para Linux en Bash que empaqueta automáticamente una base de datos
# desde el Gestor de Contenidos WordPress en el fichero database.sql
#

# USO: bash in.sh
# Con configuración dev/prod: bash out.sh dev

config_file="wp-config.php";
if [[ "$1" == "dev" ]] 
then
	config_file="wp-config_dev.php";
fi

if [[ "$1" == "prod" ]]
then
  config_file="wp-config_prod.php";
fi

while read linea
do
	if [[ "$linea" == *"define('DB_HOST'"* ]]
	then
		IFS="'" read -a array <<< "$linea"
		host=${array[3]}
	fi

	if [[ "$linea" == *"define('DB_USER'"* ]]
	then
		IFS="'" read -a array <<< "$linea"
		user=${array[3]}
	fi

	if [[ "$linea" == *"define('DB_PASSWORD'"* ]]
	then
		IFS="'" read -a array <<< "$linea"
		password=${array[3]}
	fi

	if [[ "$linea" == *"define('DB_NAME'"* ]]
	then
		IFS="'" read -a array <<< "$linea"
		db=${array[3]}
	fi
done < $config_file

echo "Host: $host";
echo "Usuario: $user";
#echo "Contraseña: $password";
echo "Base de datos: $db";

mysqldump -u $user -p$password $db > database.sql
