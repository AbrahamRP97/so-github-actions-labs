#!/bin/bash

echo "=== MONITOREO DE RECURSOS DEL CONTENEDOR ==="
echo ""

# CONTAINER ID
CONTAINER_ID=$(docker ps -q --filter "ancestor=app-so-avanzado:latest")

if [ -z "$CONTAINER_ID" ]; then
    echo "❌ No se encontró contenedor en ejecución"
    exit 1
fi

echo "📦 Container ID: $CONTAINER_ID"
echo ""

# Container Information
echo "--- Información del Contenedor ---"
docker inspect --format='Nombre: {{.Name}}' $CONTAINER_ID
docker inspect --format='Estado: {{.State.Status}}' $CONTAINER_ID
docker inspect --format='Iniciado: {{.State.StartedAt}}' $CONTAINER_ID
echo ""

# 10 second monitoring
echo "--- Monitoreo de Recursos (10 segundos) ---"
for i in {1..5}; do
    echo "Medición #$i:"
    docker stats $CONTAINER_ID --no-stream --format "  CPU: {{.CPUPerc}}\t Memoria: {{.MemUsage}}\t Red I/O: {{.NetIO}}"
    sleep 2
done

echo ""
echo "--- Procesos dentro del contenedor ---"
docker top $CONTAINER_ID

echo ""
echo "--- Logs del contenedor ---"
docker logs $CONTAINER_ID --tail 20

echo ""
echo "✅ Monitoreo completado"
