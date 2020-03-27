#!/usr/bin/env bash
set -e
SCRIPT_BASE_DIR=$(cd $"${BASH_SOURCE%/*}" && pwd)
PROJECT_BASE_DIR=$(cd $SCRIPT_BASE_DIR && cd .. && pwd)

GRADLE_DIR=${SCRIPT_BASE_DIR}/build/laplacian
set -x
(cd $GRADLE_DIR
  ./gradlew \
    --stacktrace \
    --build-file build.gradle \
    --settings-file settings.gradle \
    --project-dir $GRADLE_DIR \
    publish
)