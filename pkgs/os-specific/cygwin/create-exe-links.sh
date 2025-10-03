linkEXEs() {
  if [ ! -d "$prefix" ]; then return; fi
  (
    set -e
    shopt -s globstar nullglob

    cd "$prefix"

    local target
    for target in {bin,libexec}/**/*.exe; do
      if [[ -f "$target" && ! -e "${target%.exe}" ]]; then
         local link
         link=$(basename "$target")
         echo "linkEXEs: creating link for $target" >&2
         ln -s "$link" "${target%.exe}"
      fi
    done
  )
}

fixupOutputHooks+=(linkEXEs)
