#!/usr/bin/env bash

main() {
  if ! [ -z $SKIP_GENERATION ]
  then
    generate
  fi
  publish
}

generate() {
  $SCRIPT_BASE_DIR/generate.sh
}