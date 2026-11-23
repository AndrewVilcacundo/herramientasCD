#!/bin/bash
# Script para ejecutar Ansible directamente en WSL2 (Ubuntu)
set -e

echo "=========================================================="
echo "   EJECUTANDO ANSIBLE NATIVO EN WSL2 (UBUNTU)             "
echo "   Expositores: Andrew Vilcacundo & Galindo               "
echo "=========================================================="

# 1. Asegurar dependencias si no están instaladas
if ! command -v ansible &> /dev/null; then
    echo "Instalando Ansible en Ubuntu WSL..."
    sudo apt update && sudo apt install -y python3-pip python3-venv git
    python3 -m pip install --break-system-packages ansible docker requests
    ansible-galaxy collection install community.docker
fi

# 2. Ejecutar Playbook
echo "Ejecutando Playbook de Despliegue..."
ansible-playbook -i inventory/hosts.ini playbooks/deploy.yml

echo ""
echo "Verificando respuesta local..."
curl -I http://localhost:8080 || true
