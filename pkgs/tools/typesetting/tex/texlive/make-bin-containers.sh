# load realpath
loadables="$(command -v bash)"
loadables="${loadables%/bin/bash}/lib/bash"
enable -f "$loadables/realpath" realpath
mkdir -p "$out/bin"

# find interpreters
export interpPerl="$(PATH="$HOST_PATH" command -v perl)"
export interpJava="$(PATH="$HOST_PATH" command -v java || :)"
export interpWish="$(PATH="$HOST_PATH" command -v wish || :)"

# prepare sed script
substituteAll "$patchScripts" patch-scripts.sed

for binname in $binfiles ; do
  # binlinks to be created last, after the other binaries are in place
  if [[ " $binlinks " == *" $binname "* ]] ; then
    continue
  fi

  output="$out/bin/$binname"

  # look for existing binary from bin.*
  target="$(PATH="$HOST_PATH" command -v "$binname" || :)"
  if [[ -n "$target" && -x "$target" ]] ; then
    ln -s "$(realpath "$target")" "$output"
    continue
  fi

  # look for scripts
  # the explicit list of extensions avoid non-scripts such as $binname.cmd, $binname.jar, $binname.pm
  # the order is relevant: $binname.sh is preferred to other $binname.*
  for folder in $scriptsFolder ; do
    for script in "$folder/$binname"{,.sh,.lua,.pl,.py,.rb,.sno,.tcl,.texlua,.tlu}; do
      if [[ -f "$script" ]] ; then
        sed -f patch-scripts.sed \
          -e 's/^scriptname=`basename "\$0"`$/'"scriptname='$(basename "$binname")'/" \
          -e 's/^scriptname=`basename "\$0" .sh`$'"/scriptname='$(basename "$binname" .sh)'/" \
          "$script" > "$output"
        chmod +x "$output"
        continue 3
      fi
    done
  done

  echo "error: could not find source for 'bin/$binname'" >&2
  exit 1
done

# patch shebangs
patchShebangs "$out/bin"

# generate links
# we canonicalise the source to avoid symlink chains, and to check that it exists
cd "$out"/bin
for alias in $binlinks ; do
  target="${bintargets%% *}"
  bintargets="${bintargets#* }"
  ln -s "$(realpath "$target")" "$out/bin/$alias"
done
