main() {
  if [ -z $SKIP_GENERATION ]
  then
    generate
  fi
  publish_local 'template'
}
