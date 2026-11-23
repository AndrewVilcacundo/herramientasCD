# Demo Práctica: Pipeline de Entrega Continua (CD) con Ansible y Docker

**Asignatura:** Integración de Sistemas  
**Actividad:** Configuración de un pipeline de entrega continua (Herramientas CD) – 10% P1  
**Estudiantes:** Andrew Vilcacundo & Galindo  
**Fecha:** Noviembre 2026  

---

## 1. Descripción del Proyecto

Este repositorio contiene la demostración práctica y el material de investigación técnica sobre **Ansible** aplicado al despliegue y entrega continua (Continuous Delivery - CD).

El proyecto demuestra de manera 100% funcional y verificada cómo Ansible automatiza el aprovisionamiento, renderizado dinámico y despliegue idempotente de una aplicación web contenerizada utilizando Docker, gestionando el ciclo de vida sin intervención manual.

---

## 2. Estructura de Directorios

```text
ansible-cd-demo/
├── ansible.cfg                # Configuración global del motor Ansible
├── requirements.yml           # Colecciones Ansible Galaxy requeridas (community.docker)
├── run-playbook.ps1           # Script PowerShell de ejecución con 1 clic (Windows / Docker)
├── run-wsl.sh                 # Script bash para ejecución nativa en WSL2 Ubuntu
├── Dockerfile                 # Definición del Control Node Runner
├── docker-runner/             # Archivos fuente del contenedor Control Node
│   └── Dockerfile
├── inventory/
│   └── hosts.ini              # Inventario de servidores y variables del pipeline
├── playbooks/
│   └── deploy.yml             # Playbook orquestador de Entrega Continua
├── roles/
│   └── webapp/                # Rol modular reutilizable de Ansible
│       ├── tasks/main.yml     # Tareas de aprovisionamiento, despliegue y healthcheck
│       ├── templates/index.html.j2 # Plantilla Jinja2 de la aplicación web
│       └── handlers/main.yml  # Handlers de reinicio reactivo
├── www/                       # Artefactos renderizados para el servidor web
├── presentation/              # Presentación de diapositivas interactiva (HTML/CSS)
│   └── index.html
├── informe.md                 # Informe técnico de investigación académica completo
├── guion-exposicion.md        # Guion de defensa oral (10-15 min) y banco de preguntas
├── dinamica-clase.md          # Dinámica interactiva para puntos extra
└── README.md                  # Este documento
```

---

## 3. Requisitos Previos y Entorno Probado

- **Sistema Operativo:** Windows 11 (Laptop ASUS TUF A16, AMD Ryzen 7).
- **Herramientas Instaladas:** Docker Desktop con backend WSL2 activo, PowerShell 7/5.1 o VS Code Terminal.
- **Imagen de Ansible Runner:** Construida localmente como `ansible-control-node` (incluye Python 3.11, `ansible-core 2.19.15`, `community.docker` y Docker CLI).

---

## 4. Instrucciones de Ejecución

### Opción A: Ejecución Directa en PowerShell (Recomendada en Windows)

1. Abre una terminal de **PowerShell** en la carpeta raíz del proyecto `ansible-cd-demo/`.
2. Asegúrate de que Docker Desktop esté encendido.
3. Ejecuta el script:
   ```powershell
   .\run-playbook.ps1
   ```
4. Observa la salida del Playbook y abre en tu navegador:
   **[http://localhost:8080](http://localhost:8080)**

### Opción B: Ejecución en WSL2 (Ubuntu)

Si cuentas con una distribución Ubuntu en WSL2 con Docker integrado:
```bash
chmod +x run-wsl.sh
./run-wsl.sh
```

---

## 5. Explicación de los Componentes Principales

1. **`inventory/hosts.ini`:** Define el host de destino (`localhost` con conexión local) y las variables clave del despliegue: nombre de la aplicación (`demo-webapp-ansible`), puerto publicado (`8080`), versión (`v1.0.0`) y metadatos.
2. **`playbooks/deploy.yml`:** Coordina la ejecución. Define las fases de pre-tareas informativas, la invocación del rol `webapp` y el resumen final del pipeline CD.
3. **`roles/webapp/tasks/main.yml`:**
   - Verifica la comunicación con la API del daemon de Docker (`docker_host_info`).
   - Renderiza la plantilla web con variables dinámicas usando Jinja2 (`template`).
   - Descarga la imagen base oficial `nginx:alpine` (`docker_image`).
   - Despliega el contenedor asegurando la configuración de red y puertos (`docker_container`).
   - Realiza un **Healthcheck HTTP** automatizado para validar que el servicio responde con código 200 OK antes de dar por exitoso el pipeline.
4. **Idempotencia Comprobada:** Al ejecutar el script por segunda vez, Ansible detecta que el contenedor ya existe y no requiere cambios (`ok=12, changed=0`), garantizando estabilidad operativa.
