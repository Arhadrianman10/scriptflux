#!/bin/bash

echo "=== Iniciando la configuración del contenedor ==="

# Paso 1: Detectar si el sistema está intentando usar una versión obsoleta
UBUNTU_VERSION=$(lsb_release -cs)
echo "Versión de Ubuntu detectada: $UBUNTU_VERSION"

# Paso 2: Actualizar el sources.list si la versión está obsoleta
if [[ "$UBUNTU_VERSION" == "lunar" ]]; then
    echo "La versión de Ubuntu es obsoleta. Actualizando repositorios a 'old-releases'..."
    sed -i 's|http://archive.ubuntu.com/ubuntu|http://old-releases.ubuntu.com/ubuntu|g' /etc/apt/sources.list
    sed -i 's|http://security.ubuntu.com/ubuntu|http://old-releases.ubuntu.com/ubuntu|g' /etc/apt/sources.list
fi

# Paso 3: Actualizar los paquetes del sistema
echo "Actualizando lista de paquetes..."
apt-get update -y

if [ $? -ne 0 ]; then
    echo "Error durante la actualización de los paquetes."
    exit 1
fi

echo "Actualizando paquetes del sistema..."
apt-get upgrade -y

echo "=== Configuración completa ==="
