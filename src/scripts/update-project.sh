#!/usr/bin/env bash
set -e
PROJECT_BASE_DIR=$(cd $"${BASH_SOURCE%/*}/../" && pwd)

SCRIPT_BASE_DIR="$PROJECT_BASE_DIR/scripts"

${SCRIPT_BASE_DIR}/laplacian-generate.sh \
  --plugin 'laplacian:laplacian.project.schema-plugin:1.0.0' \
  --plugin 'laplacian:laplacian.common-model-plugin:1.0.0' \
  --model 'laplacian:laplacian.project.project-types:1.0.0' \
  --model 'laplacian:laplacian.common-model:1.0.0' \
  --template 'laplacian:laplacian.generator.project-template:1.0.0' \
  --model-files './model/project.yaml' \
  --model-files './model/project' \
  --target-dir './'
