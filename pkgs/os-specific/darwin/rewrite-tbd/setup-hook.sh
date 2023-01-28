fixupOutputHooks+=('checkTbdReexports')

checkTbdReexports() {
  while IFS= read -r -d $'\0' tbd; do
    echo "checkTbdRexports: checking re-exports in $tbd"
    rewrite-tbd -r "$NIX_STORE" "$tbd"
  done < <(find "$prefix" -type f -name '*.tbd' -print0)
}
