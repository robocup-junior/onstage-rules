#!/bin/bash
set -euo pipefail

INPUT_DIR=$1
OUTPUT_FOLDER=$(basename "$INPUT_DIR")

cp manual.sty tmp/
cp -r media tmp/
cd tmp

# Apply custom styling to DocBook
for FILE in *.xml; do
    dblatex -T db2latex "$FILE" -t tex --texstyle=./manual.sty -p ../custom.xsl
done

# Go through the generated .tex output, find the place where the preamble ends
# (marked by the \mainmatter command) and create a file without it.
for FILE in *.tex; do
    FILE_NAME=$(basename "$FILE" .tex)
    
    cat "$FILE" | awk 'f;/\\mainmatter/{f=1}'  > "${FILE_NAME}_without_preamble.tex"

    ORIGINAL_TITLE_LINE=$(grep -m 1 '^\\title' "$FILE")
    TITLE_LINE=$(echo "$ORIGINAL_TITLE_LINE" | sed 's/\\title{\(.*\)}/\\title{\\vspace{-5ex}\1\\vspace{-9ex}}/')

    # Concat the standardized preamble with the "without_preamble" version of the file + additional content
    if [[ "$FILE_NAME" == 00_* || ! "$FILE_NAME" =~ ^[0-9]{2}_ ]]; then
        # For file starting with "00_", include committee list
        cat "../preamble.tex" \
        "../${INPUT_DIR}/header_footer.tex" \
        <(echo "$TITLE_LINE") \
        <(echo "\maketitle") \
        "../committee_list.tex" \
        "${FILE_NAME}_without_preamble.tex" > "$FILE_NAME.tex"
    else
        # For other files, skip committee list
        cat "../preamble.tex" \
        "../${INPUT_DIR}/header_footer.tex" \
        <(echo "$TITLE_LINE") \
        <(echo "\maketitle") \
        "${FILE_NAME}_without_preamble.tex" > "$FILE_NAME.tex"
    fi

    texliveonfly $FILE_NAME.tex
    pdflatex $FILE_NAME.tex
    pdflatex $FILE_NAME.tex

    NEW_FILE_NAME="$FILE_NAME"
    
    if [[ "$FILE_NAME" =~ ^[0-9]{2}_(.*) ]]; then
        NEW_FILE_NAME="${BASH_REMATCH[1]}"
    fi

    cp $FILE_NAME.pdf "../rules_documents/$OUTPUT_FOLDER/$NEW_FILE_NAME.pdf"
done

cd ..
rm -r tmp