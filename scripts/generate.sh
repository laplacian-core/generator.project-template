#!/usr/bin/env bash
set -e
PROJECT_BASE_DIR=$(cd $"${BASH_SOURCE%/*}/../" && pwd)

SCRIPT_BASE_DIR="$PROJECT_BASE_DIR/scripts"
LOCAL_REPO_PATH="$PROJECT_BASE_DIR/../mvn-repo"
if [[ -d "$PROJECT_BASE_DIR/subprojects/mvn-repo" ]]
then
  LOCAL_REPO_PATH="$PROJECT_BASE_DIR/subprojects/mvn-repo"
fi
PROJECT_MODEL_DIR="$PROJECT_BASE_DIR/model/project"
PROJECT_SOURCE_INDEX="$PROJECT_MODEL_DIR/sources.yaml"

DEST_DIR="$PROJECT_BASE_DIR/dest"
SRC_DIR="$PROJECT_BASE_DIR/src"

main() {
  create_dest_dir
  create_file_index
  generate
}

create_dest_dir() {
  mkdir -p $DEST_DIR
  rm -rf $DEST_DIR
  if [ -d $SRC_DIR ]
  then
    cp -rf $SRC_DIR $DEST_DIR
  else
    mkdir -p $DEST_DIR
  fi
}

normalize_path () {
  local path=$1
  if [[ $path == ./* ]]
  then
    echo "${PROJECT_BASE_DIR}/$path"
  else
    echo $path
  fi
}

create_file_index() {
  mkdir -p $PROJECT_MODEL_DIR
  cat <<EOF > $PROJECT_SOURCE_INDEX
project:
  sources:$(file_list | sort -d)
EOF
}

file_list() {
  local separator="\n  - "
  (cd $PROJECT_BASE_DIR
    find . -type d \( \
      -path './scripts' -o -path './.git' -o -path './dest' -o -path './subprojects' \
    \) -prune -o -type f -print
  ) | while read -r file
  do
    printf "$separator\"${file:2}\""
  done
  printf "\n"
}

#
# Generate resources for project.base-template project.
#
generate() {
  ${SCRIPT_BASE_DIR}/laplacian-generate.sh \
    --plugin 'laplacian:laplacian.project.schema-plugin:1.0.0' \
    --template 'laplacian:laplacian.project.base-template:1.0.0' \
    --model 'laplacian:laplacian.project.project-types:1.0.0' \
    --model 'laplacian:laplacian.project.document-content:1.0.0' \
    --model-files $(normalize_path 'model/project.yaml') \
    --model-files $(normalize_path 'model/project/') \
    --target-dir ./ \
    --local-repo "$LOCAL_REPO_PATH"
}

main