GRADLE_DIR=${SCRIPT_BASE_DIR}/laplacian
GRADLE="./gradlew"
GRADLE_BUILD_FILE="$GRADLE_DIR/build.gradle"
GRADLE_SETTINGS_FILE="$GRADLE_DIR/settings.gradle"
DEST_DIR="$PROJECT_BASE_DIR/dest"

generate() {
  $SCRIPT_BASE_DIR/generate.sh
}

publish_local() {
  local module_dir="$1"
  trap clean EXIT
  {{#if project.module_repositories.local ~}}
  set_local_module_repo
  {{/if}}
  create_build_dir
  create_settings_gradle
  create_build_gradle $module_dir
  run_gradle
}

{{#if project.module_repositories.local ~}}
set_local_module_repo() {
  LOCAL_MODULE_REPOSITORY=${LOCAL_MODULE_REPOSITORY:-"$PROJECT_BASE_DIR/{{project.module_repositories.local}}"}
}
{{/if}}

create_build_dir() {
  mkdir -p $GRADLE_DIR
}

run_gradle() {
  (cd $GRADLE_DIR
    $GRADLE \
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
            url '${LOCAL_MODULE_REPOSITORY}'
        }
        maven {
            url '${REMOTE_REPO_PATH}'
        }
        gradlePluginPortal()
        jcenter()
    }
}
rootProject.name = "{{project.group}}.{{project.name}}"
EOF
}

create_build_gradle() {
  local module_dir="$1"
  cat <<EOF > $GRADLE_BUILD_FILE
plugins {
    id 'maven-publish'
    id 'org.jetbrains.kotlin.jvm' version '1.3.70'
}

group = '{{project.group}}'
version = '{{project.version}}'

repositories {
    maven {
        url '${LOCAL_MODULE_REPOSITORY}'
    }
    maven {
        url '${REMOTE_REPO_PATH}'
    }
    jcenter()
}

task moduleJar(type: Jar) {
    from '${DEST_DIR}/${module_dir}'
}

publishing {
    repositories {
        maven {
            url '${LOCAL_MODULE_REPOSITORY}'
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

clean() {
  rm -f $GRADLE_BUILD_FILE $GRADLE_SETTINGS_FILE 2> /dev/null || true
}

#@additional-declarations@
#@additional-declarations@