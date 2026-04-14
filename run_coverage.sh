#!/bin/bash
# run_coverage.sh — Ejecutar tests con cobertura y generar reporte lcov

set -e

echo "========================================="
echo "  Ejecutando tests con cobertura"
echo "========================================="

# 1. Limpiar cobertura anterior
rm -rf coverage/

# 2. Ejecutar tests con coverage
flutter test --coverage

# 3. Mostrar resumen rápido
echo ""
echo "========================================="
echo "  Resumen de cobertura"
echo "========================================="

if command -v lcov &> /dev/null; then
  lcov --summary coverage/lcov.info
else
  echo "ℹ️  Instala lcov para ver el resumen:"
  echo "    brew install lcov   (macOS)"
  echo "    apt install lcov    (Linux)"
fi

# 4. Generar reporte HTML (opcional, requiere lcov)
if command -v genhtml &> /dev/null; then
  genhtml coverage/lcov.info -o coverage/html
  echo ""
  echo "✅ Reporte HTML generado en: coverage/html/index.html"
fi

echo ""
echo "✅ Archivo lcov generado en: coverage/lcov.info"
echo "   (Úsalo en SonarQube con: sonar.dart.coverage.reportPaths=coverage/lcov.info)"