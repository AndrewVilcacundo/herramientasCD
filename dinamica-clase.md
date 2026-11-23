# DINÁMICA INTERACTIVA PARA LA CLASE: "DESPLIEGUE MANUAL VS. AUTOMATIZADO CON ANSIBLE"

**Objetivo:** Demostrar de forma lúdica y participativa la diferencia abrumadora en **tiempo**, **repetibilidad** y **tasa de error humano** entre un despliegue manual y uno orquestado con Ansible.  
**Tiempo total:** 3 a 5 minutos.  
**Materiales necesarios:** La laptop del expositor, cronómetro (celular de un compañero voluntario) y un voluntario de la clase.

---

## 1. PREPARACIÓN Y ROLES

1. **Voluntario A (Compañero de clase):** Representa al *"SysAdmin Tradicional"*. Se le entregará una lista de 4 comandos en papel o en un bloc de notas que debe tipear manualmente en una terminal abierta de PowerShell.
2. **Voluntario B (Compañero con cronómetro):** Toma el tiempo exacto en segundos que tarda cada método y cuenta cuántos errores de tipeo o dudas surgen.
3. **Andrew Vilcacundo / Galindo:** Ejecuta el despliegue automatizado con el script de Ansible (`.\run-playbook.ps1`).

---

## 2. DESARROLLO DE LA DINÁMICA EN VIVO

### Fase 1: El Despliegue Manual (El Voluntario)
El expositor le dice al compañero voluntario:
> *"Imagina que son las 2:00 AM y producción está caída. Tienes que levantar un nuevo contenedor web con Nginx, mapear el puerto 8080, inyectar el HTML y verificar que responda."*

Se le pide al voluntario ejecutar manualmente estos pasos (el cronómetro arranca):
1. `docker run -d --name manual-web -p 8081:80 nginx:alpine`
2. `docker cp ./www/index.html manual-web:/usr/share/nginx/html/index.html`
3. `curl http://localhost:8081`
4. Si se le pide repetir el despliegue para actualizarlo: `docker stop manual-web`, `docker rm manual-web` y volver a escribir todo.

⏱️ **Tiempo promedio observado:** 60 a 90 segundos (con dudas sobre nombres de carpetas, mayúsculas, comillas o puertos ocupados).

---

### Fase 2: El Despliegue Automatizado con Ansible
El expositor Andrew ejecuta:
```powershell
.\run-playbook.ps1
```
⏱️ **Tiempo promedio observado:** **2 a 4 segundos** (con verificación de Docker, renderizado de Jinja2, verificación de puertos, levantamiento del contenedor y comprobación HTTP 200 OK automática).

---

## 3. COMPARATIVA Y DISCUSIÓN CON EL CURSO

El expositor proyecta o anota en la pizarra el cuadro comparativo:

| Criterio | Despliegue Manual (Tradicional) | Despliegue con Ansible (CD) |
| :--- | :--- | :--- |
| **Tiempo de Ejecución** | 60 - 90 segundos por servidor | **Menos de 5 segundos** para N servidores |
| **Riesgo de Error Humano** | Muy alto (typos, flags olvidados, permisos) | **Cero** (código validado y versionado) |
| **Escalabilidad** | Tienes que repetir el proceso en cada máquina | Se ejecuta en 1 o en 1,000 servidores a la vez |
| **Repetibilidad (Idempotencia)** | Si te equivocas dejas estados inconsistentes | Garantizada: si ya está correcto, no hace nada |
| **Documentación** | En la memoria del ingeniero o notas sueltas | El Playbook YAML **es** la documentación viva |

---

## 4. FRASE DE CIERRE DE LA DINÁMICA
> *"Como acabamos de comprobar junto a nuestro compañero, la automatización con Ansible no solo ahorra tiempo: elimina el estrés del equipo de desarrollo, previene caídas nocturnas de servidores y convierte la entrega continua en un proceso predecible y profesional."*
