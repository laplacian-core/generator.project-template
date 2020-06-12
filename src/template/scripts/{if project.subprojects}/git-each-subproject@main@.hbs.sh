SUBPROJECTS='
{{~#each project.subprojects as |subproject| ~}}
{{subproject.base_dir}}
{{/each}}'

main() {
  for subproject in $SUBPROJECTS
  do
    local path="$PROJECT_BASE_DIR/$subproject"
    if [[ -d "$path/.git" ]]
    then
      echo "
      === $subproject ===
      "
      (cd $path
        git $ARGS
      )
    fi
  done
}