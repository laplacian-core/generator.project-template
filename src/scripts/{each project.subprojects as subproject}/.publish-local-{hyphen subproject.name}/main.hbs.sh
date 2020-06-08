#!/usr/bin/env bash

SCRIPTS_DIR='scripts'
PUBLISH_SCRIPT='publish-local.sh'
TARGET_PROJECT_DIR="${PROJECT_BASE_DIR}/{{subproject.base_dir}}"
TARGET_PUBLISH_SCRIPT="$TARGET_PROJECT_DIR/$SCRIPTS_DIR/$PUBLISH_SCRIPT"

main() {
  if ! [ -f $TARGET_PUBLISH_SCRIPT ]
  then
    run_generate
  fi
  $TARGET_PUBLISH_SCRIPT
}

run_generate() {
  $PROJECT_BASE_DIR/$SCRIPTS_DIR/generate-{{hyphen subproject.name}}.sh
}
