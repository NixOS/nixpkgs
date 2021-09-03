fixupOutputHooks+=('checkTbdReexports')

checkTbdReexports() {
  local dir="$1"

  while IFS= read -r -d $'\0' tbd; do
    echo "checkTbdRexports: checking re-exports in $tbd"
    while read -r target; do
      local expected="${target%.dylib}.tbd"
      if ! [ -e "$expected" ]; then
        echo -e "Re-export missing:\n\t'$target'\n\t(expected '$expected')"
        echo -e "While processing\n\t'$tbd'"
        exit 1
      else
        echo "Re-exported target '$target' ok"
      fi
    done < <(print-reexports "$tbd")
  done < <(find $prefix -type f -name '*.tbd' -print0)
}
