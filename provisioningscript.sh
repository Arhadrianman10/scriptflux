#!/bin/bash

LOG_FILE="/tmp/provisioning.log"

# Función para registrar logs
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

log "=== Iniciando la configuración del contenedor ==="

# Detectar versión de Ubuntu
UBUNTU_VERSION=$(lsb_release -cs)
log "Versión de Ubuntu detectada: $UBUNTU_VERSION"

# Actualizar repositorios si es necesario
if [[ "$UBUNTU_VERSION" == "lunar" ]]; then
    log "La versión de Ubuntu es obsoleta. Actualizando repositorios a 'old-releases'..."
    sed -i 's|http://archive.ubuntu.com/ubuntu|http://old-releases.ubuntu.com/ubuntu|g' /etc/apt/sources.list
    sed -i 's|http://security.ubuntu.com/ubuntu|http://old-releases.ubuntu.com/ubuntu|g' /etc/apt/sources.list
else
    log "No se requiere cambiar los repositorios para la versión $UBUNTU_VERSION."
fi

# Actualizar lista de paquetes
log "Actualizando lista de paquetes..."
if apt-get update -y >> $LOG_FILE 2>&1; then
    log "Actualización de paquetes completada correctamente."
else
    log "Error al actualizar la lista de paquetes."
    exit 1
fi

# Actualizar paquetes del sistema
log "Actualizando paquetes del sistema..."
if apt-get upgrade -y >> $LOG_FILE 2>&1; then
    log "Actualización de paquetes completada correctamente."
else
    log "Error al actualizar los paquetes del sistema."
    exit 1
fi

log "=== Configuración completa ==="
