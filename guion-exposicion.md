# GUION DE EXPOSICIÓN Y BANCO DE PREGUNTAS (DEFENSA ORAL)

**Asignatura:** Integración de Sistemas  
**Actividad:** Configuración de un pipeline de entrega continua (Herramientas CD) – 10% P1  
**Tiempo estimado:** 10 a 15 minutos  
**Expositores:** Andrew Vilcacundo & Galindo  

---

## 1. GUION DE EXPOSICIÓN MINUTO A MINUTO

### Minuto 0:00 - 1:30 | Introducción y Planteamiento del Problema
- **Andrew Vilcacundo:**  
  "Buenos días profesor y compañeros. Hoy junto a mi compañero Galindo vamos a presentar la herramienta **Ansible**, analizando su papel en la automatización de infraestructura y su importancia en la Entrega Continua (CD).
  Para entender por qué Ansible es tan relevante hoy en día, pensemos en cómo se desplegaba software tradicionalmente: un ingeniero se conectaba por SSH al servidor, copiaba archivos manualmente, ejecutaba comandos por consola y modificaba archivos de configuración en caliente.
  Esto generaba tres problemas críticos: errores humanos por comandos mal escritos, el famoso *'en mi máquina sí funciona'* y la llamada *'deriva de configuración'* (cuando dos servidores en producción dejan de ser idénticos)."

### Minuto 1:30 - 3:30 | ¿Qué es Ansible y su Arquitectura?
- **Galindo / Andrew:**  
  "Ansible es un motor de automatización creado por Michael DeHaan en 2012 y respaldado por Red Hat. Su gran ventaja competitiva es que es **Agentless (sin agente)**.
  A diferencia de herramientas como Puppet o Chef, que obligan a instalar un demonio que consume memoria y CPU en cada servidor, Ansible solo necesita dos cosas: una conexión SSH (o WinRM en Windows) y un intérprete de Python.
  El sistema se divide en dos:
  1. El **Control Node**: la máquina donde reside Ansible y desde donde orquestamos.
  2. Los **Managed Nodes**: los servidores que reciben las instrucciones.
  Y todo se describe en archivos de texto legibles por humanos utilizando formato **YAML**."

### Minuto 3:30 - 6:00 | Componentes Clave e Idempotencia
- **Andrew Vilcacundo:**  
  "Dentro de Ansible encontramos cinco componentes clave que implementamos en nuestro proyecto:
  - El **Inventario (`hosts.ini`)**, que lista a qué servidores nos conectamos y qué variables tienen.
  - Los **Playbooks**, que son los guiones en YAML donde definimos qué queremos lograr.
  - Los **Módulos**, que son programas especializados. Por ejemplo, en nuestra demo usamos la colección oficial `community.docker` para interactuar con el motor de Docker.
  - Los **Roles**, que nos permiten organizar el código en módulos limpios y reutilizables.
  Pero la propiedad más importante que deben recordar de Ansible es la **Idempotencia**.
  ¿Qué significa? Que si ejecutamos un Playbook una vez, realiza los cambios necesarios para llegar al estado deseado. Pero si lo ejecutamos diez veces más sobre el mismo servidor, Ansible detecta que el estado ya es correcto y **no realiza ninguna acción innecesaria ni destructiva**."

### Minuto 6:00 - 8:30 | Ansible en el Pipeline CI/CD y Comparativa
- **Galindo / Andrew:**  
  "¿Cómo encaja Ansible en la Entrega Continua (CD)?
  En la integración continua (CI), herramientas como GitHub Actions compilan el código, corren pruebas y generan una imagen de Docker. Pero cuando pasamos a la fase de **CD**, Ansible toma el control: se conecta a los servidores de producción, descarga la nueva imagen, actualiza los contenedores sin caída de servicio (*zero-downtime*) y ejecuta un *Healthcheck* para confirmar que la aplicación responda HTTP 200 OK.
  Frente a **Terraform**, la diferencia es clara: Terraform se encarga del *aprovisionamiento de infraestructura* (crea la red, las instancias virtuales en AWS o Azure), mientras que Ansible se encarga de la *configuración interna y el despliegue del software*. Ambas herramientas son complementarias."

### Minuto 8:30 - 12:00 | Demostración Práctica en Vivo
- **Andrew Vilcacundo:**  
  "Ahora pasemos a la demostración práctica que preparamos para esta sesión.
  En mi computadora (Windows 11) nos encontramos con una limitación real del sistema: Windows no puede actuar como Nodo de Control nativo de Ansible.
  Para solucionar esto con estándares profesionales, implementamos una arquitectura desacoplada: creamos un contenedor *Runner* de Ansible con Python 3.11 y la colección `community.docker`, que se conecta mediante el socket de Docker a la máquina anfitriona.
  *(Andrew ejecuta en la terminal)*:
  `.\run-playbook.ps1`
  Fíjense en la salida de la consola:
  1. Ansible inicia el Playbook y recopila los datos del sistema (*Fact Gathering*).
  2. Se conecta a Docker Engine v29.5.2.
  3. Renderiza una plantilla dinámica con el motor Jinja2 inyectando nuestros nombres.
  4. Descarga la imagen `nginx:alpine` y levanta el contenedor `demo-webapp-ansible` en el puerto `8080`.
  5. Ejecuta una prueba automática de disponibilidad HTTP y valida que recibimos un código 200 OK.
  *(Abre el navegador en http://localhost:8080)*:
  Aquí pueden ver la aplicación web respondiendo en vivo.
  Y si volvemos a ejecutar el script inmediatamente:
  Observen el resumen final: `ok=12, changed=0`. Esto demuestra empíricamente la **idempotencia**: no hubo necesidad de reiniciar el servicio porque el estado ya era el óptimo."

### Minuto 12:00 - 14:00 | Licenciamiento y Conclusiones
- **Galindo / Andrew:**  
  "Finalmente, a nivel de licenciamiento, existe **Ansible Community**, que es 100% de código abierto bajo licencia GPLv3 y funciona por línea de comandos; y **Red Hat Ansible Automation Platform (AAP)**, que es la versión comercial con soporte 24/7, auditoría empresarial y una consola web llamada Automation Controller para grandes corporaciones.
  Como conclusión, dominar Ansible permite a los equipos de ingeniería de software pasar de despliegues manuales lentos y riesgosos a un proceso de entrega continua automatizado, seguro y auditable.
  Quedamos atentos a cualquier pregunta del profesor o los compañeros. Muchas gracias."

---

## 2. BANCO DE PREGUNTAS Y RESPUESTAS TÉCNICAS (PARA EL PROFESOR)

### P1: ¿Por qué Ansible se considera una herramienta de configuración y entrega continua, y cuál es la diferencia exacta con Terraform?
**Respuesta Técnica:**  
"Terraform es una herramienta de aprovisionamiento de infraestructura (Infrastructure Provisioning) enfocada en el ciclo de vida de los recursos en la nube mediante un archivo de estado (`.tfstate`). Terraform responde a la pregunta *'¿dónde se ejecuta mi sistema?'* (crea VPCs, clusters EKS, instancias EC2).  
Ansible, por su parte, es un motor de gestión de configuraciones y orquestación (Configuration Management & CD). Responde a la pregunta *'¿qué corre dentro de mis servidores?'*. Ansible no requiere almacenar un archivo de estado local porque inspecciona el estado real del nodo en vivo mediante SSH o APIs, lo que lo hace idóneo para actualizar paquetes, desplegar artefactos y verificar que los servicios estén activos dentro de un pipeline de entrega continua."

### P2: ¿Qué significa exactamente que Ansible sea 'Agentless' y qué implicaciones de seguridad tiene?
**Respuesta Técnica:**  
"Agentless significa que no es necesario instalar ni mantener un servicio demonio propietario de Ansible en los servidores administrados. Las herramientas tradicionales (como Puppet o Chef) requieren un agente que consume memoria constantemente y necesita puertos TCP específicos abiertos.  
En Ansible, toda la comunicación se realiza a través de los canales estándar del sistema operativo: OpenSSH con criptografía de clave pública en Linux o WinRM sobre HTTPS en Windows. Esto minimiza la superficie de ataque, no consume recursos cuando no se ejecutan tareas y simplifica radicalmente la auditoría de seguridad."

### P3: ¿Cómo garantiza Ansible la idempotencia? ¿Todo módulo en Ansible es idempotente por defecto?
**Respuesta Técnica:**  
"La idempotencia se garantiza porque cada módulo de Ansible está programado para verificar el estado actual antes de actuar. Por ejemplo, el módulo `docker_container` primero consulta la API de Docker para verificar si ya existe un contenedor con ese nombre, imagen y puertos; si coincide exactamente, no hace nada y devuelve `changed=false`.  
Sin embargo, módulos genéricos como `command` o `shell` no son idempotentes por defecto porque ejecutan cualquier comando ciegamente. En esos casos, el ingeniero debe proveer directivas como `creates`, `removes` o condiciones `when` para garantizar la idempotencia."

### P4: En su demostración en Windows 11, ¿por qué no pudieron ejecutar Ansible directamente en PowerShell y qué alternativas existen?
**Respuesta Técnica:**  
"El núcleo de Ansible (`ansible-core`) depende de llamadas al sistema POSIX como `fork()`, control de señales Unix y pseudo-terminales que no existen de forma nativa en la API Win32 de Windows. Por esta razón, Windows solo puede ser un **nodo gestionado**, no un **nodo de control** nativo.  
Las dos alternativas recomendadas por la documentación oficial son:
1. Utilizar **WSL2 (Windows Subsystem for Linux)** con una distribución Ubuntu.
2. Utilizar un **contenedor Docker Runner**, que fue la alternativa que implementamos para la demostración. Esta solución encapsula el entorno Linux dentro de un contenedor y monta el socket de Docker, siendo una réplica exacta de cómo ejecutan Ansible los *runners* de GitHub Actions o GitLab CI."

### P5: ¿Qué diferencia existe entre un Play, un Task, un Role y una Collection?
**Respuesta Técnica:**  
- **Task:** La unidad atómica de ejecución que invoca un módulo con parámetros (ej. levantar un contenedor).
- **Play:** La asignación entre un grupo de hosts del inventario y una serie de tareas o roles.
- **Playbook:** El archivo YAML global que contiene uno o más Plays.
- **Role:** Una estructura de directorios estandarizada (`tasks`, `templates`, `handlers`, `vars`) que empaqueta tareas reutilizables.
- **Collection:** El formato de distribución moderno de Ansible que agrupa múltiples roles, módulos y plugins bajo un espacio de nombres común (por ejemplo, `community.docker` o `kubernetes.core`)."

### P6: ¿Cuál es la diferencia entre Ansible Community y Red Hat Ansible Automation Platform (AAP)?
**Respuesta Técnica:**  
"Ansible Community es el proyecto de software libre bajo licencia GPLv3 que incluye el ejecutable de consola (`ansible-playbook`) y los módulos abiertos, mantenido por la comunidad.  
Red Hat AAP es el producto comercial de pago para empresas. Incluye soporte oficial 24/7 con SLAs, el *Automation Controller* (la versión empresarial de AWX que proporciona una interfaz web completa, gestión centralizada de inventarios y control de acceso basado en roles RBAC), el *Private Automation Hub* para gestionar colecciones internas firmadas digitalmente y *Event-Driven Ansible* para automatización reactiva a alertas."
