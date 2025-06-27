#!/bin/bash

INPUT_DIR="/cygdrive/d/fypp/ejemploscvrs"
OUTPUT_DIR="/cygdrive/d/fypp/salidascvrs"

mkdir -p "$OUTPUT_DIR"

for file in "$INPUT_DIR"/*.f90; do
    base=$(basename "$file" .f90)
    ./fypp "$file" "$OUTPUT_DIR/${base}.py"
done

echo "✅ Todos los archivos han sido convertidos."
