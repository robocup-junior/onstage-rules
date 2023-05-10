#!/bin/bash
mkdir -p tmp rules_documents

set -euo pipefail

OUTPUT_FILE=$1
cp $1.adoc tmp/$1.adoc

cd tmp

cp $OUTPUT_FILE.adoc _$OUTPUT_FILE.adoc
python3 ../.ci/criticmarkup_to_adoc.py _$OUTPUT_FILE.adoc > $OUTPUT_FILE.adoc

asciidoctor $OUTPUT_FILE.adoc
asciidoctor -b docbook $OUTPUT_FILE.adoc

mv $OUTPUT_FILE.html ../rules_documents/