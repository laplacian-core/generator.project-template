#!/usr/bin/env bash

SCRIPTS='
{{~#each project.subprojects as |subproject| ~}}
generate-{{hyphen subproject.group}}-{{hyphen subproject.name}}
{{/each}}'

main() {
  $PROJECT_BASE_DIR/scripts/generate
  for script in $SCRIPTS
  do
    echo "
    === $script ===
    "
    $PROJECT_BASE_DIR/scripts/$script
  done
}