#!/usr/bin/env bash

SCRIPTS_DIR='scripts'
GENERATOR_SCRIPT='generate.sh'
LAPLACIAN_GENERATOR="$SCRIPTS_DIR/laplacian-generate.sh"
TARGET_PROJECT_DIR="$PROJECT_BASE_DIR/{{subproject.base_dir}}"
TARGET_MODEL_DIR="$TARGET_PROJECT_DIR/model"
TARGET_SCRIPT_DIR="$TARGET_PROJECT_DIR/$SCRIPTS_DIR"
TARGET_PROJECT_MODEL_FILE="$TARGET_MODEL_DIR/project.yaml"

RAW_HOST='https://raw.githubusercontent.com/nabla-squared/laplacian.generator.project-template/master'

main() {
  {{#if subproject.source_repository ~}}
  sync_source_with_repository
  {{/if}}
  create_project_model_file
  if ! [ -f $TARGET_SCRIPT_DIR/$GENERATOR_SCRIPT ]
  then
    install_generator
  fi
  run_generator
}

{{#if subproject.source_repository ~}}
{{define 'repo' subproject.source_repository}}
sync_source_with_repository() {
  if [[ ! -d $TARGET_PROJECT_DIR/.git ]]
  then
    mkdir -p $TARGET_PROJECT_DIR
    rm -rf $TARGET_PROJECT_DIR
    git clone {{if repo.branch (printf '-b %s ' repo.branch)}}\
        {{repo.url}} \
        $TARGET_PROJECT_DIR
  else
    (cd $TARGET_PROJECT_DIR && git pull)
  fi
}
{{/if}}

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
      ../../{{repositories.local}}
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

install_generator() {
  local TMP_DIR=".TMP"
  mkdir -p $TARGET_SCRIPT_DIR
  (cd $TARGET_PROJECT_DIR
    curl -Ls -o ./$LAPLACIAN_GENERATOR $RAW_HOST/$LAPLACIAN_GENERATOR
    chmod 755 ./$LAPLACIAN_GENERATOR
    $LAPLACIAN_GENERATOR \
      --plugin 'laplacian:laplacian.project.domain-model-plugin:1.0.0' \
      --plugin 'laplacian:laplacian.common-model-plugin:1.0.0' \
      --template 'laplacian:laplacian.generator.project-template:1.0.0' \
      --model 'laplacian:laplacian.project.project-types:1.0.0' \
      --model-files 'model/project.yaml' \
      --model-files "$TMP_DIR/model/" \
      --local-repo '../../{{repositories.local}}' \
      --target-dir "$TMP_DIR"
    $LAPLACIAN_GENERATOR \
      --plugin 'laplacian:laplacian.project.domain-model-plugin:1.0.0' \
      --plugin 'laplacian:laplacian.common-model-plugin:1.0.0' \
      --template 'laplacian:laplacian.generator.project-template:1.0.0' \
      --model 'laplacian:laplacian.project.project-types:1.0.0' \
      --model-files 'model/project.yaml' \
      --model-files "$TMP_DIR/model/" \
      --local-repo '../../{{repositories.local}}' \
      --target-dir "$TMP_DIR"
  )
  trap "rm -rf $TARGET_PROJECT_DIR/$TMP_DIR" EXIT
  mkdir -p $TARGET_SCRIPT_DIR
  rm -rf $TARGET_SCRIPT_DIR
  mv "$TARGET_PROJECT_DIR/$TMP_DIR/scripts" $TARGET_SCRIPT_DIR
}

run_generator() {
  $TARGET_SCRIPT_DIR/$GENERATOR_SCRIPT
}
