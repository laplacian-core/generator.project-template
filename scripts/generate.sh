#!/usr/bin/env bash
set -e
SCRIPT_BASE_DIR=$(cd $"${BASH_SOURCE%/*}" && pwd)
PROJECT_BASE_DIR=$(cd $SCRIPT_BASE_DIR && cd .. && pwd)

LOCAL_REPO_PATH="$PROJECT_BASE_DIR/../mvn-repo"
PROJECT_MODEL_DIR="$PROJECT_BASE_DIR/model/project"
PROJECT_SOURCE_INDEX="$PROJECT_MODEL_DIR/sources.yaml"

main() {
  create_file_index
  generate
}

normalize_path () {
  local path=$1
  if [[ $path == /* ]]
  then
    echo $path
  else
    echo "${PROJECT_BASE_DIR}/$path"
  fi
}

create_file_index() {
  mkdir -p $PROJECT_MODEL_DIR
  cat <<EOF > $PROJECT_SOURCE_INDEX
project:
  sources:$(file_list)
EOF
}

file_list() {
  local separator="\n  - "
  (cd $PROJECT_BASE_DIR
    find . -type d \( \
      -path './scripts' -o -path './.git' -o -path './dest' \
    \) -prune -o -type f -print
  ) | while read -r file
  do
    printf "$separator\"${file:2}\""
  done
  printf "\n"
}

#
# Generate resources for project-base.template project.
#
generate() {
  ${SCRIPT_BASE_DIR}/laplacian-generate.sh \
    --template 'laplacian:laplacian.project-base.template:1.0.0' \
    --model 'laplacian:laplacian.project-doc.content:1.0.0' \
    --model-files $(normalize_path './model/project.yaml') \
    --model-files $(normalize_path './model/project/') \
    --target-dir ./ \
    --local-repo "$LOCAL_REPO_PATH"
}

main