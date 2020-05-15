#!/usr/bin/env bash

TARGET_PROJECT_DIR="${PROJECT_BASE_DIR}/{{subproject.base_dir}}"

main() {

}

(cd $TARGET_PROJECT_DIR
  if [[ ! -f ./scripts/laplacian-generate.sh ]]
  then
    ./scripts/update-project.sh
  fi
  ./scripts/publish-local.sh
)