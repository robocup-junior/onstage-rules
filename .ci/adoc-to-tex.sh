#!/bin/bash

set -euo pipefail

INPUT_DIR=$1
OUTPUT_FOLDER=$(basename "$INPUT_DIR")
rm -rf "rules_documents/$OUTPUT_FOLDER/"
mkdir -p tmp "rules_documents/$OUTPUT_FOLDER/"

for FILE in "$INPUT_DIR"/*.adoc; do
    FILE_NAME=$(basename "$FILE" .adoc)
    
    cp "$FILE" "tmp/$FILE_NAME.adoc"
    
    cd tmp
    
    cp "$FILE_NAME.adoc" "_$FILE_NAME.adoc"
    python3 ../.ci/criticmarkup_to_adoc.py "_$FILE_NAME.adoc" > "$FILE_NAME.adoc"
    
    asciidoctor "$FILE_NAME.adoc"
    asciidoctor -b docbook "$FILE_NAME.adoc"
    
    NEW_FILE_NAME="$FILE_NAME"
    
    if [[ "$FILE_NAME" =~ ^[0-9]{2}_(.*) ]]; then
        NEW_FILE_NAME="${BASH_REMATCH[1]}"
    fi

    mv "$FILE_NAME.html" "../rules_documents/$OUTPUT_FOLDER/$NEW_FILE_NAME.html"
    
    cd ..

done