SUBPROJECTS='
{{~#each project.subprojects as |subproject| ~}}
{{subproject.base_dir}}
{{/each}}'

main() {
  for subproject in $SUBPROJECTS
  do
    local path="$PROJECT_BASE_DIR/$subproject"
    echo "
    === $subproject ===
    "
    (cd $path
      $ARGS
    )
  done
}