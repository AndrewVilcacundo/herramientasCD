# Pipeline CI/CD simulado: Despliegue con Ansible en Windows usando Contenedor Runner
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   EJECUTANDO PIPELINE CD CON ANSIBLE (WINDOWS / DOCKER)   " -ForegroundColor Cyan
Write-Host "   Expositores: Andrew Vilcacundo & Galindo                " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
# Convertir ruta Windows a formato compatible con Docker (slashes)
$DockerMountPath = $ScriptDir.Replace('\', '/')

Write-Host "[1/3] Montando proyecto desde: $DockerMountPath" -ForegroundColor Yellow
Write-Host "      Iniciando Ansible Control Node..." -ForegroundColor Yellow

# Ejecutar el contenedor de Ansible montando el socket de Docker y la carpeta del proyecto
docker run --rm `
  -v /var/run/docker.sock:/var/run/docker.sock `
  -e ANSIBLE_ROLES_PATH=/ansible/roles `
  -v "${DockerMountPath}:/ansible" `
  -w /ansible `
  ansible-control-node `
  ansible-playbook -i inventory/hosts.ini playbooks/deploy.yml

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n[2/3] Verificando contenedor desplegado en Docker Desktop..." -ForegroundColor Green
    docker ps --filter "name=demo-webapp-ansible"
    
    Write-Host "`n[3/3] Probando respuesta HTTP local en http://localhost:8080 ..." -ForegroundColor Green
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:8080" -Method Get -TimeoutSec 5
        Write-Host ">>> ÉXITO: La aplicación web responde correctamente con código HTTP 200 OK!" -ForegroundColor Green
        Write-Host ">>> Abre tu navegador en: http://localhost:8080" -ForegroundColor Cyan
    } catch {
        Write-Host ">>> Verifique localhost:8080 en el navegador." -ForegroundColor Yellow
    }
} else {
    Write-Host "`n[ERROR] El playbook de Ansible reportó fallas en la ejecución." -ForegroundColor Red
}
