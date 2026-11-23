FROM python:3.11-slim

# Instalar dependencias del sistema y cliente Docker CLI
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    sshpass \
    openssh-client \
    ca-certificates \
    gnupg \
    && mkdir -m 0755 -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y --no-install-recommends docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Instalar Ansible y dependencias de Python para Docker
RUN pip install --no-cache-dir ansible-core ansible requests docker

# Instalar colección de Ansible para Docker
RUN ansible-galaxy collection install community.docker

WORKDIR /ansible
CMD ["ansible-playbook", "--version"]
