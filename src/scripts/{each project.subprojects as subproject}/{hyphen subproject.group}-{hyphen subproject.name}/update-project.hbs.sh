#!/usr/bin/env bash
set -e
PROJECT_BASE_DIR=$(cd $"${BASH_SOURCE%/*}/../../" && pwd)

SCRIPT_BASE_DIR="$PROJECT_BASE_DIR/scripts"
LOCAL_REPO_PATH={{#if project.module_repositories.local ~}}
"$PROJECT_BASE_DIR/{{project.module_repositories.local.path}}"
{{~/if}}

TARGET_PROJECT_DIR="$PROJECT_BASE_DIR/{{subproject.base_dir}}"
TARGET_MODEL_DIR="$TARGET_PROJECT_DIR/model"
TARGET_PROJECT_MODEL_FILE="$TARGET_MODEL_DIR/project.yaml"

GENERATOR_SCRIPT_FILE_NAME=generate.sh
TARGET_SCRIPT_DIR="$TARGET_PROJECT_DIR/scripts"
TARGET_PROJECT_GENERATOR_SCRIPT="$TARGET_SCRIPT_DIR/$GENERATOR_SCRIPT_FILE_NAME"

main() {
  {{#if subproject.source_repository ~}}
  checkout_from_code_repository
  {{/if}}
  create_project_model_file
  install_generator
  trap run_generator 0
}

create_project_model_file() {
  mkdir -p $TARGET_MODEL_DIR
  cat <<END_FILE > $TARGET_PROJECT_MODEL_FILE
project:
  group: {{subproject.group}}
  name: {{subproject.name}}
  type: {{subproject.type}}
  namespace: {{subproject.namespace}}
  version: '{{subproject.version}}'
  description:
    {{#each project.document.languages as |lang| ~}}
    {{lang.code}}: |
      {{shift (lookup subproject.description lang.code) 6}}
    {{/each}}
  {{#if subproject.source_repository ~}}
  source_repository:
    url: {{subproject.source_repository.url}}
    branch: {{subproject.source_repository.branch}}
  {{/if}}
  {{#if project.module_repositories ~}}
  {{define 'repositories' project.module_repositories}}
  module_repositories:
    {{#if repositories.local ~}}
    local:
      path: ../../{{repositories.local.path}}
      {{#if repositories.local.url ~}}
      url: {{repositories.local.url}}
      branch: {{repositories.local.branch}}
      {{/if}}
    {{/if}}
    {{#if repositories.remote ~}}
    remote:
    {{#each repositories.remote as |remote_url| ~}}
    - {{remote_url}}
    {{/each}}
    {{/if}}
  {{/if}}
  {{#if subproject.plugins ~}}
  plugins:
  {{#each subproject.plugins as |plugin| ~}}
  - group: {{plugin.group}}
    name: {{plugin.name}}
    version: '{{plugin.version}}'
  {{/each}}
  {{/if}}
  {{#if subproject.templates ~}}
  templates:
  {{#each subproject.templates as |template| ~}}
  - group: {{template.group}}
    name: {{template.name}}
    version: '{{template.version}}'
  {{/each}}
  {{/if}}
  {{#if subproject.models ~}}
  models:
  {{#each subproject.models as |model| ~}}
  - group: {{model.group}}
    name: {{model.name}}
    version: '{{model.version}}'
  {{/each}}
  {{/if}}
  {{#if subproject.model_files ~}}
  model_files:
  {{#each subproject.model_files as |files| ~}}
  - '{{files}}'
  {{/each}}
  {{/if}}
  {{#if subproject.template_files ~}}
  template_files:
  {{#each subproject.template_files as |files| ~}}
  - '{{files}}'
  {{/each}}
  {{/if}}
END_FILE
}

{{#if subproject.source_repository ~}}
checkout_from_code_repository() {
  if [[ ! -d $TARGET_PROJECT_DIR/.git ]]
  then
    mkdir -p $TARGET_PROJECT_DIR
    rm -rf $TARGET_PROJECT_DIR
    git clone \
        {{subproject.source_repository.url}} \
        $TARGET_PROJECT_DIR
  fi
  (cd $TARGET_PROJECT_DIR
    git checkout {{subproject.source_repository.branch}}
    git pull
  )
}
{{/if}}

install_generator() {
  mkdir -p $TARGET_SCRIPT_DIR
  (cd $TARGET_PROJECT_DIR
    curl -Ls https://git.io/fhxcl | bash
  )
}

run_generator() {
  ${TARGET_SCRIPT_DIR}/laplacian-generate.sh \
    --plugin 'laplacian:laplacian.project.schema-plugin:1.0.0' \
    --plugin 'laplacian:laplacian.common-model-plugin:1.0.0' \
    --model 'laplacian:laplacian.project.project-types:1.0.0' \
    --model 'laplacian:laplacian.common-model:1.0.0' \
    --template 'laplacian:laplacian.generator.project-template:1.0.0' \
    --model-files './model/project.yaml' \
    --model-files './model/project' \
    --target-dir './' \
    --local-repo "$LOCAL_REPO_PATH"
}

main
