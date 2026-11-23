# PRESENTACIÓN UNIVERSITARIA: ANSIBLE – AUTOMATIZACIÓN DE INFRAESTRUCTURA Y CD

**Asignatura:** Integración de Sistemas  
**Actividad:** Configuración de un pipeline de entrega continua (Herramientas CD) – 10% P1  
**Expositores:** Andrew Vilcacundo & Galindo  

---

## ESTRUCTURA DE DIAPOSITIVAS (15 DIAPOSITIVAS)

---

### DIAPOSITIVA 1: Portada
**Título:** Ansible – Automatización de Infraestructura y Entrega Continua (CD)  
**Subtítulo:** Configuración de un Pipeline CD para Aplicaciones Modernas  
**Asignatura:** Integración de Sistemas (10% P1) – Grupo del Sábado  
**Expositores:** Andrew Vilcacundo & Galindo  
**Fecha:** Noviembre 2026  

> 🗣️ **Notas para el expositor:**  
> "Buenos días profesor y compañeros. Hoy junto a mi compañero Galindo presentaremos la herramienta Ansible, analizando por qué es una de las tecnologías líderes en automatización de infraestructura y cómo se integra dentro de un pipeline moderno de Entrega Continua (CD)."

---

### DIAPOSITIVA 2: Introducción a la Problemática
**Título:** El Desafío del Despliegue Manual  
**Puntos Clave:**
- **La trampa de los despliegues manuales:** Conexiones SSH manuales, scripts bash frágiles, comandos tecleados en vivo y configuraciones no documentadas.
- **Consecuencias operativas:**
  - Síndrome "En mi máquina sí funciona".
  - Desviación de configuración (*Configuration Drift*).
  - Caídas del servicio por errores humanos durante lanzamientos.
- **La Solución DevOps:** Infraestructura como Código (IaC) y Entrega Continua automatizada.

> 🗣️ **Notas para el expositor:**  
> "El origen de Ansible responde a un problema histórico: cuando los despliegues se hacen a mano o mediante scripts de shell individuales, cualquier error tipográfico o diferencia entre servidores rompe la producción. Con Ansible buscamos que el despliegue sea un proceso predecible, repetible y seguro."

---

### DIAPOSITIVA 3: ¿Qué es Ansible?
**Título:** Definición y Filosofía de Diseño  
**Puntos Clave:**
- Herramienta de automatización de TI de código abierto, creada en 2012 y respaldada por **Red Hat**.
- **Propósitos fundamentales:**
  1. Aprovisionamiento y configuración de servidores.
  2. Despliegue continuo de aplicaciones.
  3. Orquestación de servicios en múltiples niveles.
- **Filosofía Clave:** Simplicidad radical, sintaxis amigable para humanos y cero agentes residentes.

> 🗣️ **Notas para el expositor:**  
> "Ansible no es solo un gestor de configuración; es un motor de automatización universal. Su lema es la simplicidad: permite a desarrolladores y administradores de sistemas hablar el mismo idioma técnico mediante descripciones claras de lo que debe existir en el servidor."

---

### DIAPOSITIVA 4: Arquitectura y Componentes
**Título:** Arquitectura Agentless de Ansible  
**Diagrama Visual:**
```text
[Control Node (Linux / WSL / Runner)]
         │
         │  (SSH / WinRM / Docker API)
         ├──> [Nodo Gestionado 1: Servidor Web]
         ├──> [Nodo Gestionado 2: Base de Datos]
         └──> [Nodo Gestionado 3: Contenedor Docker]
```
**Componentes Principales:**
- **Control Node:** Máquina desde donde se orquesta (requiere Python/Linux).
- **Managed Nodes:** Nodos administrados (*sin agentes instalados*).
- **Inventario (`hosts.ini`):** Directorio de máquinas y variables de entorno.
- **Módulos:** Unidades ejecutables de trabajo (ej. `apt`, `template`, `docker_container`).

> 🗣️ **Notas para el expositor:**  
> "Fíjense en el concepto de *Agentless*. Herramientas tradicionales como Puppet o Chef obligan a instalar y mantener un demonio en cada servidor. Ansible no requiere nada instalado en los nodos más allá de SSH y Python. Esto reduce la superficie de ataque y el consumo de recursos a cero cuando está en reposo."

---

### DIAPOSITIVA 5: Organización del Código: Playbooks, Roles y Galaxy
**Título:** Estructura Modular y Reutilizable  
**Puntos Clave:**
- **Playbooks:** Archivos YAML que declaran el estado deseado mediante *Plays* y *Tasks*.
- **Roles:** Estructura estandarizada de carpetas (`tasks/`, `handlers/`, `templates/`, `vars/`) para modularizar y reutilizar lógica.
- **Collections:** Paquetes integrados de módulos, plugins y roles (ej. `community.docker`).
- **Ansible Galaxy:** El repositorio público oficial de roles y colecciones comunitarias.

> 🗣️ **Notas para el expositor:**  
> "Para no crear archivos YAML gigantescos, Ansible utiliza 'Roles'. En nuestra práctica creamos un rol llamado `webapp`, aislando las tareas, las plantillas HTML y los manejadores de eventos. Además, mediante Ansible Galaxy podemos descargar colecciones mantenidas por la comunidad o fabricantes como Docker, AWS o Cisco."

---

### DIAPOSITIVA 6: Flujo de Trabajo e Idempotencia
**Título:** ¿Cómo Opera Ansible y Qué es la Idempotencia?  
**Puntos Clave:**
- **Paso 1:** Lectura de inventario y Playbook.
- **Paso 2: Fact Gathering:** Ansible inspecciona el estado actual del hardware y SO del nodo gestionado.
- **Paso 3: Evaluación y Convergencia:** Aplica solo las tareas que difieren del estado deseado.
- **Idempotencia:**
  $$\text{Ejecución}(1) = \text{Ejecución}(N)$$
  Si el servicio ya está corriendo y el archivo no cambió, Ansible marca la tarea como `ok` y **no ejecuta acciones redundantes ni destructivas**.

> 🗣️ **Notas para el expositor:**  
> "La idempotencia es la característica estrella de Ansible. Si corres un script de bash dos veces, probablemente te de un error de 'puerto ocupado' o inserte dos veces la misma línea de texto. Ansible en cambio inspecciona el estado real: si el contenedor ya existe y tiene la configuración solicitada, no lo toca. Eso da una tranquilidad enorme en producción."

---

### DIAPOSITIVA 7: Ventajas y Desventajas
**Título:** Evaluación Técnica de Ansible  
**Ventajas:**
- 🟢 **Sin Agentes (*Agentless*):** Seguridad simplificada y sin huella de memoria en reposo.
- 🟢 **Curva de Aprendizaje Rápida:** YAML legible frente a lenguajes complejos (DSL de Ruby).
- 🟢 **Ecosistema Masivo:** Miles de módulos oficiales y comunitarios disponibles.
**Desventajas / Retos:**
- 🔴 **Control Node Unix-Only:** Requiere WSL2 o Docker para ejecutarse en entornos Windows.
- 🔴 **Velocidad en Escalas Masivas:** Con miles de nodos, la negociación SSH puede ser más lenta que soluciones con bus de mensajes permanente.

> 🗣️ **Notas para el expositor:**  
> "Como futuros ingenieros de software, debemos ser críticos. Ansible brilla por su sencillez y por ser agentless, pero también tiene desafíos: no corre de forma nativa en el kernel de Windows como nodo de control, y en infraestructuras de 50.000 servidores la latencia de SSH requiere ajustes avanzados como pipelining y forks paralelos."

---

### DIAPOSITIVA 8: Comparativa de Herramientas
**Título:** Ansible vs. Terraform vs. Puppet vs. Chef  
**Tabla Resumen:**
- **Terraform:** Especialista en *aprovisionar infraestructura* en la nube (crear la máquina virtual, la VPC y los discos).
- **Ansible:** Especialista en *configurar los servidores* y *desplegar aplicaciones* (*Continuous Delivery*).
- **Puppet / Chef:** Gestores de configuración basados en agentes residentes, con mayor sobrecarga operativa.

> 🗣️ **Notas para el expositor:**  
> "Una pregunta clásica del profesor suele ser: ¿Por qué usar Ansible si ya existe Terraform? La respuesta técnica es que son complementarias: con Terraform 'creamos el terreno y las paredes' (instancias EC2, redes) y con Ansible 'amueblamos e instalamos los electrodomésticos' (instalamos Docker, clonamos la app y la ponemos a funcionar)."

---

### DIAPOSITIVA 9: Integración Tecnológica: Git, Docker y Kubernetes
**Título:** Ecosistema Cloud-Native  
**Puntos Clave:**
- **Git / GitHub:** Infraestructura como Código (IaC). Cambios validados mediante Pull Requests.
- **Docker (`community.docker`):**
  - Módulos `docker_image`, `docker_container` y `docker_volume`.
  - Orquestación declarativa del ciclo de vida de los contenedores.
- **Kubernetes (`kubernetes.core`):**
  - Gestión de manifiestos K8s dinámicos.
  - Desarrollo de *Kubernetes Operators* mediante el Ansible Operator SDK.

> 🗣️ **Notas para el expositor:**  
> "Ansible no compite con Docker ni con Kubernetes; los potencia. Mediante colecciones dedicadas, Ansible se conecta a la API de Docker para descargar imágenes, mapear volúmenes y levantar contenedores de manera reproducible, como demostraremos hoy."

---

### DIAPOSITIVA 10: Ansible dentro de un Pipeline CI/CD
**Título:** El Rol Protagónico en la Entrega Continua (CD)  
**Etapas del Pipeline:**
1. **Developer:** Hace `git push` de una nueva característica.
2. **CI Server (GitHub Actions / Jenkins):** Compila el código, corre tests unitarios y construye la imagen Docker.
3. **CD Stage (Ansible):**
   - Conexión segura a servidores de producción.
   - Despliegue con *Zero Downtime* (Rolling Update).
   - Inyección segura de variables y secretos.
   - Healthcheck HTTP automatizado para confirmar el éxito del despliegue.

> 🗣️ **Notas para el expositor:**  
> "En la integración de sistemas, CI se encarga de empaquetar y validar el software, pero la Entrega Continua (CD) necesita ponerlo en producción sin interrumpir a los usuarios. Aquí es donde Ansible ejecuta el playbook de despliegue, valida que la app responda HTTP 200 y, si algo falla, puede ejecutar un rollback inmediato."

---

### DIAPOSITIVA 11: Demostración Práctica – Escenario Real
**Título:** Caso de Estudio: Despliegue Automatizado en Windows 11  
**Arquitectura de la Demo:**
- **Equipo del Alumno:** ASUS TUF A16, AMD Ryzen 7, Windows 11.
- **Reto Resuelto:** Uso de un contenedor `ansible-control-node` comunicándose con Docker Desktop mediante el socket compartido `/var/run/docker.sock`.
- **Estructura:**
  - `inventory/hosts.ini` &rarr; Parámetros del entorno.
  - `roles/webapp/` &rarr; Plantilla Jinja2 (`index.html.j2`) y tareas automatizadas.
  - `playbooks/deploy.yml` &rarr; Orquestación general.
  - `run-playbook.ps1` &rarr; Automatización en 1 solo comando.

> 🗣️ **Notas para el expositor:**  
> "Para nuestra demostración práctica, nos enfrentamos a un reto real: Windows no permite correr Ansible nativamente. En lugar de limitarnos, implementamos una solución estándar de la industria: creamos un contenedor ligero como Control Node que monta el socket de Docker de la máquina y ejecuta el playbook directamente."

---

### DIAPOSITIVA 12: Resultados de la Demostración
**Título:** Validación Empírica y Métricas del Despliegue  
**Log Real Obtenido:**
- ✅ Conectado exitosamente al daemon de Docker v29.5.2.
- ✅ Descarga y verificación de imagen oficial `nginx:alpine`.
- ✅ Renderizado dinámico de plantilla web con variables del estudiante.
- ✅ Despliegue del contenedor `demo-webapp-ansible` en el puerto `8080`.
- ✅ **Healthcheck HTTP exitoso (Código 200 OK).**
- ✅ **Prueba de Idempotencia comprobada:** En la segunda ejecución: `ok=12, changed=0`.

> 🗣️ **Notas para el expositor:**  
> "Como pueden ver en pantalla, el playbook corrió todas sus tareas satisfactoriamente. Al verificar la idempotencia en una segunda ejecución, observamos cero cambios, demostrando que Ansible no alteró el sistema innecesariamente."

---

### DIAPOSITIVA 13: Tipos de Licenciamiento
**Título:** Ansible Community vs. Red Hat Ansible Automation Platform  
**Comparación:**
- **Ansible Community:**
  - Código abierto (GPLv3), gratuito, manejado por CLI.
  - Ideal para equipos técnicos, startups y proyectos de ingeniería.
- **Red Hat AAP (Empresarial):**
  - Plataforma comercial con soporte oficial 24/7.
  - Incluye *Automation Controller* (interfaz web/UI), control de acceso basado en roles (RBAC) y métricas empresariales (*Automation Insights*).

> 🗣️ **Notas para el expositor:**  
> "En proyectos universitarios y desarrollo ágil usamos Ansible Community, que es 100% open source. Sin embargo, en grandes corporaciones como bancos o telecomunicaciones se utiliza Red Hat AAP, porque necesitan una consola gráfica con login institucional, permisos granulares por equipos y soporte de nivel empresarial."

---

### DIAPOSITIVA 14: Conclusiones
**Título:** Lecciones Aprendidas y Conclusiones  
**Puntos Clave:**
1. **Reducción Drástica de Errores:** La automatización declarativa elimina fallos humanos en los despliegues.
2. **Estandarización y GitOps:** La infraestructura y el despliegue quedan documentados y versionados en el repositorio de código.
3. **Complementariedad Cloud-Native:** Ansible y Docker conforman un tándem robusto para Entrega Continua en arquitecturas modernas de microservicios.

> 🗣️ **Notas para el expositor:**  
> "En conclusión, Ansible no es solo una herramienta más de automatización: es el pegamento que permite conectar el código del desarrollador con los servidores de producción de forma segura, rápida y medible."

---

### DIAPOSITIVA 15: Referencias Bibliográficas
**Título:** Referencias y Fuentes Oficiales  
- Red Hat Ansible Documentation (2025): *User Guide & Best Practices*.
- Geerling, Jeff (2020): *Ansible for DevOps*, Midwestern Mac.
- Docker Inc. (2025): *Docker Engine Documentation*.
- IEEE Software: *Infrastructure as Code: Principles and Practices*.

---

¡Muchas gracias por su atención!  
¿Preguntas o comentarios?
