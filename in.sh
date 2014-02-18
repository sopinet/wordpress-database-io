#!/usr/bin/env bash

#
# Sergio Yamuza - Sopinet
# Fernando Hidalgo - Sopinet
# 18 - Febrero - 2013
# Script para Linux en Bash que desempaqueta automáticamente un database.sql
# en la base de datos de un Gestor de Contenidos WordPress
#

# USO: bash in.sh
# Con configuración dev/prod: bash in.sh dev

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

sh drop.sh $user $password $db
mysql -u $user -p$password $db < database.sql
