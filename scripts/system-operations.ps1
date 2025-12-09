Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  SCRIPT DE OPERACIONES DEL SISTEMA (Windows)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Variables de entorno
Write-Host ">>> 1. VARIABLES DE ENTORNO" -ForegroundColor Yellow
Write-Host "Usuario actual: $env:USERNAME"
Write-Host "Directorio home: $env:USERPROFILE"
Write-Host "Path (primeros 200 chars): $($env:PATH.Substring(0, [Math]::Min(200, $env:PATH.Length)))..."
Write-Host ""

# Crear directorios
Write-Host ">>> 2. CREANDO ESTRUCTURA DE DIRECTORIOS" -ForegroundColor Yellow
$workDir = Join-Path $env:USERPROFILE "workspace-test"
New-Item -ItemType Directory -Force -Path "$workDir\logs" | Out-Null
New-Item -ItemType Directory -Force -Path "$workDir\data" | Out-Null
New-Item -ItemType Directory -Force -Path "$workDir\temp" | Out-Null
Write-Host "✓ Directorios creados en: $workDir" -ForegroundColor Green
Get-ChildItem $workDir | Format-Table Name, LastWriteTime
Write-Host ""

# Escribir archivos
Write-Host ">>> 3. ESCRIBIENDO ARCHIVOS" -ForegroundColor Yellow
$infoFile = Join-Path $workDir "data\info.txt"
@"
Timestamp: $(Get-Date)
Hostname: $env:COMPUTERNAME
OS: $((Get-WmiObject Win32_OperatingSystem).Caption)
Version: $((Get-WmiObject Win32_OperatingSystem).Version)
"@ | Out-File -FilePath $infoFile -Encoding UTF8
Write-Host "✓ Archivo info.txt creado" -ForegroundColor Green

# Crear log
$logFile = Join-Path $workDir "logs\execution.log"
@"
=== LOG DE EJECUCIÓN ===
Inicio: $(Get-Date)
Usuario: $env:USERNAME
Directorio: $(Get-Location)
Proceso ID: $PID
"@ | Out-File -FilePath $logFile -Encoding UTF8
Write-Host "✓ Archivo execution.log creado" -ForegroundColor Green
Write-Host ""

# Gestión de permisos con icacls
Write-Host ">>> 4. GESTIONANDO PERMISOS CON ICACLS" -ForegroundColor Yellow
Write-Host "Permisos del archivo info.txt:"
icacls $infoFile

Write-Host "`n✓ Otorgando permisos de lectura/escritura al usuario actual" -ForegroundColor Green
icacls $infoFile /grant "${env:USERNAME}:(R,W)" | Out-Null

Write-Host "✓ Removiendo permisos heredados" -ForegroundColor Green
icacls $logFile /inheritance:r | Out-Null
icacls $logFile /grant "${env:USERNAME}:(F)" | Out-Null
Write-Host ""

# Crear script para segundo plano
Write-Host ">>> 5. CREANDO SCRIPT PARA PROCESO EN SEGUNDO PLANO" -ForegroundColor Yellow
$bgScript = Join-Path $workDir "temp\background-task.ps1"
@'
Write-Host "Proceso en segundo plano iniciado"
Write-Host "PID: $PID"
$outputFile = Join-Path $env:TEMP "background-output.txt"
for ($i = 1; $i -le 5; $i++) {
    "Iteración $i - $(Get-Date)" | Out-File -Append -FilePath $outputFile
    Start-Sleep -Seconds 1
}
"Proceso completado" | Out-File -Append -FilePath $outputFile
'@ | Out-File -FilePath $bgScript -Encoding UTF8
Write-Host "✓ Script de segundo plano creado" -ForegroundColor Green
Write-Host ""

# Ejecutar proceso en segundo plano
Write-Host ">>> 6. EJECUTANDO PROCESO EN SEGUNDO PLANO" -ForegroundColor Yellow
$job = Start-Job -FilePath $bgScript
Write-Host "✓ Job iniciado con ID: $($job.Id)" -ForegroundColor Green
Write-Host "Estado: $($job.State)"

Write-Host "Esperando a que el job termine..."
$job | Wait-Job | Out-Null
Write-Host "✓ Job completado con estado: $($job.State)" -ForegroundColor Green
$job | Remove-Job
Write-Host ""

# Verificar salida
Write-Host ">>> 7. VERIFICANDO SALIDA DEL PROCESO" -ForegroundColor Yellow
$bgOutput = Join-Path $env:TEMP "background-output.txt"
if (Test-Path $bgOutput) {
    Write-Host "Contenido de background-output.txt:"
    Get-Content $bgOutput
} else {
    Write-Host "⚠ Archivo no encontrado" -ForegroundColor Yellow
}
Write-Host ""

# Variables de entorno y secretos
Write-Host ">>> 8. USANDO VARIABLES DE ENTORNO Y SECRETOS" -ForegroundColor Yellow
if ($env:SECRET_KEY) {
    $masked = $env:SECRET_KEY.Substring(0, [Math]::Min(4, $env:SECRET_KEY.Length)) + "****"
    Write-Host "✓ Secret key detectado: $masked" -ForegroundColor Green
} else {
    Write-Host "⚠ No se encontró SECRET_KEY" -ForegroundColor Yellow
}

if ($env:CUSTOM_VAR) {
    Write-Host "✓ Variable personalizada: $env:CUSTOM_VAR" -ForegroundColor Green
} else {
    Write-Host "⚠ No se encontró CUSTOM_VAR" -ForegroundColor Yellow
}
Write-Host ""

# Generar reporte
Write-Host ">>> 9. GENERANDO REPORTE FINAL" -ForegroundColor Yellow
$reportFile = Join-Path $workDir "system-report.txt"
@"
====================================
   REPORTE DE OPERACIONES DEL SISTEMA
====================================

Fecha: $(Get-Date)
Hostname: $env:COMPUTERNAME
Usuario: $env:USERNAME
Directorio de trabajo: $workDir

--- INFORMACIÓN DEL SISTEMA ---
$((Get-WmiObject Win32_OperatingSystem).Caption)
Versión: $((Get-WmiObject Win32_OperatingSystem).Version)
Arquitectura: $env:PROCESSOR_ARCHITECTURE

--- MEMORIA ---
Total: $([math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory/1GB, 2)) GB

--- DISCO ---
$(Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{N="Used(GB)";E={[math]::Round($_.Used/1GB,2)}}, @{N="Free(GB)";E={[math]::Round($_.Free/1GB,2)}} | Format-Table | Out-String)

--- PROCESOS ACTIVOS (TOP 10) ---
$(Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 Name, Id, @{N="Memory(MB)";E={[math]::Round($_.WorkingSet/1MB,2)}} | Format-Table | Out-String)

--- ARCHIVOS CREADOS ---
$(Get-ChildItem $workDir -Recurse -File | Format-Table FullName, Length, LastWriteTime | Out-String)

--- RESULTADO DEL PROCESO EN SEGUNDO PLANO ---
$(if (Test-Path $bgOutput) { Get-Content $bgOutput } else { "No disponible" })

====================================
Reporte generado exitosamente
====================================
"@ | Out-File -FilePath $reportFile -Encoding UTF8

Write-Host "✓ Reporte generado en: $reportFile" -ForegroundColor Green
Write-Host ""

# Preparar artifacts
Write-Host ">>> 10. PREPARANDO ARTIFACTS" -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path ".\artifacts" | Out-Null
Copy-Item $reportFile ".\artifacts\" -ErrorAction SilentlyContinue
Copy-Item $infoFile ".\artifacts\" -ErrorAction SilentlyContinue
Copy-Item $logFile ".\artifacts\" -ErrorAction SilentlyContinue
Copy-Item $bgOutput ".\artifacts\" -ErrorAction
Copy-Item $bgOutput ".\artifacts\" -ErrorAction SilentlyContinue

Write-Host "✓ Artifacts copiados a .\artifacts\" -ForegroundColor Green
Get-ChildItem ".\artifacts\" | Format-Table Name, Length
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  ✅ SCRIPT COMPLETADO EXITOSAMENTE" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
exit 0
