#!/bin/bash
set -euo pipefail

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Variables
SERVER_PORT=12345

# Functions
function print_error {
  echo -e "${RED}[ERROR] $1${RESET}"
}

function print_success {
  echo -e "${GREEN}[SUCCESS] $1${RESET}"
}

function print_info {
  echo -e "${BLUE}[INFO] $1${RESET}"
}

# Check if the first argument is provided
if [[ $# -lt 1 ]]; then
  print_error "No target file specified. Usage: $0 <target-file>"
  print_info "The target file is usually 'rules' or 'superteam_rules'."
  exit 1
fi

TARGET=$1

# Check if the target file exists
if [[ ! -f "$TARGET/rules.adoc" ]]; then
  print_error "Target file '$TARGET/rules.adoc' does not exist."
  exit 1
fi

# Check if dependencies are installed
for cmd in docker python; do
  if ! command -v "$cmd" &>/dev/null; then
    print_error "Dependency '$cmd' is not installed. Please install it and try again."
    exit 1
  fi
done

# Run Docker containers for processing
print_info "Converting Asciidoc to LaTeX..."
docker run -v "$(pwd)":/documents asciidoctor/docker-asciidoctor .ci/adoc-to-tex.sh "$TARGET"
print_success "Asciidoc conversion complete."

print_info "Converting LaTeX to PDF..."
docker run -v "$(pwd)":/documents mrshu/texlive-dblatex .ci/tex-to-pdf.sh "$TARGET"
print_success "PDF conversion complete."

# Serve the files using Python's HTTP server
echo -e "${YELLOW}See generated version at: ${BLUE}http://localhost:$SERVER_PORT/rules_documents${RESET}"

# Clean up ALL temporary files
print_info "Cleaning up temporary files..."
rm -f tmp_*.*
print_success "Temporary files cleaned up."

# Final output files are now in the source directory
SOURCE_DIR=$(dirname "$TARGET")
BASENAME=$(basename "$TARGET")
if [[ "$SOURCE_DIR" == "." ]]; then
    HTML_FILE="${BASENAME}.html"
    PDF_FILE="${BASENAME}.pdf"
else
    HTML_FILE="${SOURCE_DIR}/${BASENAME}.html"
    PDF_FILE="${SOURCE_DIR}/${BASENAME}.pdf"
fi

print_success "Build complete!"
echo -e "${YELLOW}HTML version: ${BLUE}${HTML_FILE}${RESET}"
echo -e "${YELLOW}PDF version: ${BLUE}${PDF_FILE}${RESET}"
echo -e "${YELLOW}To serve files, run: ${BLUE}python -m http.server $SERVER_PORT --directory rules_documents${RESET}"
