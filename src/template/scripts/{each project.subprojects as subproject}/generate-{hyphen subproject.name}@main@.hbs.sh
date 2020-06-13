MODEL_DIR='model'
PROJECT_MODEL_FILE="$MODEL_DIR/project.yaml"
MODEL_SCHEMA_PARTIAL='model-schema-partial.json'
MODEL_SCHEMA_FULL='model-schema-full.json'

SCRIPTS_DIR='scripts'
PROJECT_GENERATOR="$SCRIPTS_DIR/generate.sh"
LAPLACIAN_GENERATOR="$SCRIPTS_DIR/laplacian-generate.sh"
VSCODE_SETTING=".vscode/settings.json"

TARGET_PROJECT_DIR="$PROJECT_BASE_DIR/{{subproject.base_dir}}"
TARGET_MODEL_DIR="$TARGET_PROJECT_DIR/$MODEL_DIR"
TARGET_SCRIPT_DIR="$TARGET_PROJECT_DIR/$SCRIPTS_DIR"
TARGET_PROJECT_MODEL_FILE="$TARGET_MODEL_DIR/project.yaml"

main() {
  {{#if subproject.source_repository ~}}
  sync_source_with_repository
  {{/if}}
  create_project_model_file
  install_generator
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
    {{#unless project.document.languages}}
    en: |
      The {{subproject.name}} project
    {{/unless}}
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
  (cd $TARGET_PROJECT_DIR
    install_file $LAPLACIAN_GENERATOR
    install_file $PROJECT_GENERATOR
    install_file $VSCODE_SETTING
    install_file $MODEL_SCHEMA_FULL
    install_file $MODEL_SCHEMA_PARTIAL
  )
}

install_file() {
  local rel_path="$1"
  local dir_path=$(dirname $rel_path)
  if [ ! -z $dir_path ] && [ ! -d $dir_path ]
  then
    mkdir -p $dir_path
  fi
  cp "$PROJECT_BASE_DIR/$rel_path" $rel_path
}

run_generator() {
  $TARGET_PROJECT_DIR/$PROJECT_GENERATOR \
    --local-module-repository '../../{{repositories.local}}' \
    --updates-scripts-only

  # We need to run it twice as the generate.sh itself may be updated in the first run.
  $TARGET_PROJECT_DIR/$PROJECT_GENERATOR \
    --local-module-repository '../../{{repositories.local}}'
}
