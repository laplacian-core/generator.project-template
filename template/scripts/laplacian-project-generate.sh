#!/usr/bin/env bash
set -e
SCRIPT_BASE_DIR=$(cd $"${BASH_SOURCE%/*}" && pwd)
PROJECT_BASE_DIR=$(cd $SCRIPT_BASE_DIR && cd .. && pwd)

${SCRIPT_BASE_DIR}/laplacian-generate.sh \
  --template 'laplacian:laplacian.template.project.base:1.0.0' \
  --model-files './model' \
  --template-files './template' \
  --target-dir './'
