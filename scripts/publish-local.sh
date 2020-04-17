#!/usr/bin/env bash
set -e
SCRIPT_BASE_DIR=$(cd $"${BASH_SOURCE%/*}" && pwd)
PROJECT_BASE_DIR=$(cd $SCRIPT_BASE_DIR && cd .. && pwd)

GRADLE_DIR=${SCRIPT_BASE_DIR}/build/laplacian
GRADLE_BUILD_FILE="$GRADLE_DIR/build.gradle"
GRADLE_SETTINGS_FILE="$GRADLE_DIR/settings.gradle"

REMOTE_REPO_PATH='https://raw.github.com/nabla-squared/mvn-repo/master/'
LOCAL_REPO_PATH="$PROJECT_BASE_DIR/../mvn-repo"

DEST_DIR="$PROJECT_BASE_DIR/dest"

main() {
  generate
  create_settings_gradle
  create_build_gradle
  run_gradle
}

generate() {
  $SCRIPT_BASE_DIR/generate.sh
}

run_gradle() {
  (cd $GRADLE_DIR
    ./gradlew \
      --stacktrace \
      --build-file build.gradle \
      --settings-file settings.gradle \
      --project-dir $GRADLE_DIR \
      publish
  )
}

create_settings_gradle() {
  cat <<EOF > $GRADLE_SETTINGS_FILE
pluginManagement {
    repositories {
        maven {
            url '${LOCAL_REPO_PATH}'
        }
        maven {
            url '${REMOTE_REPO_PATH}'
        }
        gradlePluginPortal()
        jcenter()
    }
}
rootProject.name = "laplacian.project-base.template"
EOF
}

create_build_gradle() {
  cat <<EOF > $GRADLE_BUILD_FILE
plugins {
    id 'maven-publish'
    id 'org.jetbrains.kotlin.jvm' version '1.3.70'
}

group = 'laplacian'
version = '1.0.0'

repositories {
    maven {
        url '${LOCAL_REPO_PATH}'
    }
    maven {
        url '${REMOTE_REPO_PATH}'
    }
    jcenter()
}

task moduleJar(type: Jar) {
    from '${DEST_DIR}'
}

publishing {
    repositories {
        maven {
            url '${LOCAL_REPO_PATH}'
        }
    }
    publications {
        mavenJava(MavenPublication) {
            artifact moduleJar
        }
    }
}
EOF
}

main