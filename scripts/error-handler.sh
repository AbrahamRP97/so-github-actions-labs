#!/bin/bash

# Script de demostración de manejo de errores y códigos de salida

set -e  # Salir si cualquier comando falla

echo "=== DEMOSTRACIÓN DE MANEJO DE ERRORES ==="
echo ""

# Función para manejo de errores
error_exit() {
    echo "❌ ERROR: $1" >&2
    exit "${2:-1}"
}

# Función para operaciones seguras
safe_operation() {
    local operation=$1
    echo "Ejecutando: $operation"
    
    if eval "$operation"; then
        echo "✓ Operación exitosa"
        return 0
    else
        local exit_code=$?
        echo "⚠ Operación falló con código: $exit_code"
        return $exit_code
    fi
}

# Validar que existe el directorio de trabajo
if [ ! -d "$HOME/workspace-test" ]; then
    error_exit "Directorio de trabajo no encontrado" 2
fi

# Operaciones con manejo de errores
echo ">>> Probando operaciones con archivos"
safe_operation "touch $HOME/workspace-test/test-file.txt" || echo "Continuando después del error..."

echo ""
echo ">>> Probando lectura de archivo"
if [ -f "$HOME/workspace-test/data/info.txt" ]; then
    cat "$HOME/workspace-test/data/info.txt"
    echo "✓ Archivo leído correctamente"
else
    echo "⚠ Archivo no encontrado, pero continuamos"
fi

echo ""
echo "=== Códigos de salida ==="
echo "0 = Éxito"
echo "1 = Error general"
echo "2 = Error de uso"
echo ""
echo "✅ Script de manejo de errores completado"
exit 0
