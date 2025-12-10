#!/bin/bash

echo "=========================================="
echo "  SCRIPT DE OPERACIONES DEL SISTEMA"
echo "=========================================="
echo ""

# Obtener variables de entorno
echo "--- 1. VARIABLES DE ENTORNO ---"
echo "Usuario actual: $USER"
echo "Directorio home: $HOME"
echo "Path: ${PATH:0:200}..."
echo ""

# Crear directorio de trabajo
echo "--- 2. CREANDO ESTRUCTURA DE DIRECTORIOS ---"
WORK_DIR="$HOME/workspace-test"
mkdir -p "$WORK_DIR/logs"
mkdir -p "$WORK_DIR/data"
mkdir -p "$WORK_DIR/temp"
echo "[OK] Directorios creados en: $WORK_DIR"
ls -la "$WORK_DIR"
echo ""

# Escribir archivos
echo "--- 3. ESCRIBIENDO ARCHIVOS ---"
echo "Timestamp: $(date)" > "$WORK_DIR/data/info.txt"
echo "Hostname: $(hostname)" >> "$WORK_DIR/data/info.txt"
echo "OS: $(uname -s)" >> "$WORK_DIR/data/info.txt"
echo "Kernel: $(uname -r)" >> "$WORK_DIR/data/info.txt"
echo "[OK] Archivo info.txt creado"

# Crear archivo de log
cat > "$WORK_DIR/logs/execution.log" << EOF
=== LOG DE EJECUCION ===
Inicio: $(date)
Usuario: $USER
Directorio: $(pwd)
Proceso ID: $$
Parent PID: $PPID
EOF
echo "[OK] Archivo execution.log creado"
echo ""

# Gestion de permisos
echo "--- 4. GESTIONANDO PERMISOS ---"
echo "Permisos originales:"
ls -l "$WORK_DIR/data/info.txt"

chmod 644 "$WORK_DIR/data/info.txt"
echo "[OK] Cambiado a 644 (rw-r--r--)"
ls -l "$WORK_DIR/data/info.txt"

chmod 600 "$WORK_DIR/logs/execution.log"
echo "[OK] Cambiado a 600 (rw-------)"
ls -l "$WORK_DIR/logs/execution.log"
echo ""

# Crear script ejecutable
echo "--- 5. CREANDO SCRIPT EJECUTABLE ---"
cat > "$WORK_DIR/temp/background-task.sh" << 'SCRIPT'
#!/bin/bash
echo "Proceso en segundo plano iniciado"
echo "PID: $$"
for i in {1..5}; do
    echo "Iteracion $i - $(date)" >> /tmp/background-output.txt
    sleep 1
done
echo "Proceso completado" >> /tmp/background-output.txt
SCRIPT

chmod +x "$WORK_DIR/temp/background-task.sh"
echo "[OK] Script ejecutable creado"
ls -l "$WORK_DIR/temp/background-task.sh"
echo ""

# Ejecutar proceso en segundo plano
echo "--- 6. EJECUTANDO PROCESO EN SEGUNDO PLANO ---"
"$WORK_DIR/temp/background-task.sh" &
BG_PID=$!
echo "[OK] Proceso iniciado con PID: $BG_PID"
echo "Estado del proceso:"
ps -p $BG_PID -o pid,ppid,cmd,stat

# Esperar a que termine
echo "Esperando a que el proceso termine..."
wait $BG_PID
EXIT_CODE=$?
echo "[OK] Proceso terminado con codigo: $EXIT_CODE"
echo ""

# Verificar salida del proceso
echo "--- 7. VERIFICANDO SALIDA DEL PROCESO ---"
if [ -f /tmp/background-output.txt ]; then
    echo "Contenido de background-output.txt:"
    cat /tmp/background-output.txt
else
    echo "[WARN] Archivo no encontrado"
fi
echo ""

# Usar secreto (simulado con variable de entorno)
echo "--- 8. USANDO VARIABLES DE ENTORNO Y SECRETOS ---"
if [ -n "$SECRET_KEY" ]; then
    echo "[OK] Secret key detectado: ${SECRET_KEY:0:4}****"
else
    echo "[WARN] No se encontro SECRET_KEY"
fi

if [ -n "$CUSTOM_VAR" ]; then
    echo "[OK] Variable personalizada: $CUSTOM_VAR"
else
    echo "[WARN] No se encontro CUSTOM_VAR"
fi
echo ""

# Generar reporte final
echo "--- 9. GENERANDO REPORTE FINAL ---"
REPORT_FILE="$WORK_DIR/system-report.txt"
cat > "$REPORT_FILE" << EOF
====================================
   REPORTE DE OPERACIONES DEL SISTEMA
====================================

Fecha: $(date)
Hostname: $(hostname)
Usuario: $USER
Directorio de trabajo: $WORK_DIR

--- INFORMACION DEL SISTEMA ---
$(uname -a)

--- MEMORIA ---
$(free -h)

--- DISCO ---
$(df -h | head -5)

--- PROCESOS ACTIVOS (TOP 10) ---
$(ps aux --sort=-%mem | head -11)

--- ARCHIVOS CREADOS ---
$(find $WORK_DIR -type f -exec ls -lh {} \;)

--- PERMISOS ---
$(ls -lR $WORK_DIR)

--- VARIABLES DE ENTORNO RELEVANTES ---
USER=$USER
HOME=$HOME
PWD=$PWD
SHELL=$SHELL

--- RESULTADO DEL PROCESO EN SEGUNDO PLANO ---
$(cat /tmp/background-output.txt 2>/dev/null || echo "No disponible")

====================================
Reporte generado exitosamente
====================================
EOF

echo "[OK] Reporte generado en: $REPORT_FILE"
echo ""

# Crear artifact para GitHub Actions
echo "--- 10. PREPARANDO ARTIFACTS ---"
mkdir -p ./artifacts
cp "$REPORT_FILE" ./artifacts/
cp "$WORK_DIR/data/info.txt" ./artifacts/ 2>/dev/null || true
cp "$WORK_DIR/logs/execution.log" ./artifacts/ 2>/dev/null || true
cp /tmp/background-output.txt ./artifacts/ 2>/dev/null || true

echo "[OK] Artifacts copiados a ./artifacts/"
ls -lh ./artifacts/
echo ""

echo "=========================================="
echo "  [COMPLETADO] SCRIPT FINALIZADO"
echo "=========================================="
exit 0
