#!/usr/bin/env bash
set -e
PROJECT_BASE_DIR=$(cd $"${BASH_SOURCE%/*}/../" && pwd)

SCRIPT_BASE_DIR="$PROJECT_BASE_DIR/scripts"

LOCAL_REPO_PATH={{#if project.module_repositories.local ~}}
"$PROJECT_BASE_DIR/{{project.module_repositories.local}}"
{{~/if}}

OPT_NAMES='{{#each script.options as |option| ~}}
{{~if option.short_name option.short_name ""}}{{~if option.flag "" ":"}}
{{~/each}}-:'

ARGS=
{{#each script.options as |option| ~}}
{{upper-snake option.name}}={{if option.default_value (trim option.default_value)}}
{{/each}}

run_{{lower-snake script.name}}() {
  parse_args "$@"
  ! [ -z $VERBOSE ] && set -x
  ! [ -z $HELP ] && show_usage && exit 0
  main
}

parse_args() {
  while getopts $OPT_NAMES OPTION;
  do
    case $OPTION in
    -)
      case $OPTARG in
      {{#each script.options as |option|}}
      {{hyphen option.name}})
        {{upper-snake option.name}}={{if option.flag "'yes'" '("${!OPTIND}"); OPTIND=$(($OPTIND+1))'}};;
      {{/each}}
      *)
        echo "ERROR: Unknown OPTION --$OPTARG" >&2
        exit 1
      esac
      ;;
    {{#each (filter script.options '@it.short_name') as |option|}}
    {{option.short_name}}) {{upper-snake option.name}}={{if option.flag "'yes'" '("${!OPTIND}"); OPTIND=$(($OPTIND+1))'}};;
    {{/each}}
    esac
  done
  ARGS=$@
}

show_usage () {
cat << END
Usage: $(basename "$0") [OPTION]...
  {{#each script.options as |option| ~}}
  {{if option.short_name (printf '-%s, ' option.short_name)}}--{{hyphen option.name}}{{if option.flag '' ' [VALUE]'}}
    {{if option.description (shift option.description.en 4) option.name}}{{if option.default_value (printf ' (Default: %s)' (trim option.default_value))}}
  {{/each}}
END
}

source $SCRIPT_BASE_DIR/.{{hyphen script.name}}/main.sh
run_{{lower-snake script.name}} "$@"
