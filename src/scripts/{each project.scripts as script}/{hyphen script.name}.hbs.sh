#!/usr/bin/env bash
{{~ define 'short_opts' (filter script.options '@it.short_name')}}
{{~ define 'interactive_opts' (filter script.options '@it.interactive')}}
set -e
PROJECT_BASE_DIR=$(cd $"${BASH_SOURCE%/*}/../" && pwd)

SCRIPT_BASE_DIR="$PROJECT_BASE_DIR/scripts"


OPT_NAMES='{{#each short_opts as |opt|}}{{opt.short_name}}{{if opt.flag "" ":"}}{{~/each}}-:'

ARGS=
{{#each script.options as |option| ~}}
{{upper-snake option.name}}={{if option.default_value (trim option.default_value)}}
{{/each}}

run_{{lower-snake script.name}}() {
  parse_args "$@"
  {{#if interactive_opts ~}}
  read_user_input
  {{/if}}
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
{{#if interactive_opts}}
read_user_input() {
  local input=
  {{#each interactive_opts as |opt| ~}}
  {{define 'var_name' (upper-snake opt.name)}}
  {{#if opt.flag ~}}
  read -p "Is {{opt.name}} $([ -z ${{var_name}} ] && printf '(y/N)' || printf '(Y/n)')? " input
  [[ $input == [yY] || $input == [yY][eE][sS] ]] && {{var_name}}='yes' || true
  [[ $input == [nN] || $input == [nN][oO] ]] && {{var_name}}= || true
  {{else}}
  read -p "Enter {{opt.name}}{{printf '${%s:+' var_name}}$(printf ' [%s]' ${{var_name}})}: " input
  {{var_name}}=${input:-"${{var_name}}"}
  {{/if}}
  {{/each}}
}
{{/if}}
show_usage () {
cat << 'END'
Usage: ./scripts/{{hyphen script.name}}.sh [OPTION]...
  {{#each script.options as |option| ~}}
  {{if option.short_name (printf '-%s, ' option.short_name)}}--{{hyphen option.name}}{{if option.flag '' ' [VALUE]'}}
    {{if option.description (shift option.description.en 4) option.name}}{{if option.default_value (printf ' (Default: %s)' (trim option.default_value))}}
  {{/each}}
END
}

source $SCRIPT_BASE_DIR/.{{hyphen script.name}}/main.sh
run_{{lower-snake script.name}} "$@"
