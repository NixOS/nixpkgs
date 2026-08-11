# This setup hook calls patchelf to automatically remove unneeded
# directories from the RPATH of every library or executable in every
# output.

fixupOutputHooks+=('if [ -z "${dontPatchELF-}" ]; then patchELF "$prefix"; fi')

patchELF() {
    local dir="$1"
    [ -e "$dir" ] || return 0

    echo "shrinking RPATHs of ELF executables and libraries in $dir"

    local i
    while IFS= read -r -d $'\0' i; do
        if [[ "$i" =~ .build-id ]]; then continue; fi
        if ! isELF "$i"; then continue; fi
        echo "shrinking $i"
        patchelf --shrink-rpath "$i" || true

        if [[ -n "${patchelfRelativeRpaths-}" ]]; then
            local rpath
            if rpath=$(patchelf --print-rpath "$i") && [ -n "$rpath" ]; then
                local store_path="${NIX_STORE:-/nix/store}"
                local new_rpath=""
                local r
                local rpath_arr
                # Split by ':'
                IFS=':' read -r -a rpath_arr <<< "$rpath"
                for r in "${rpath_arr[@]}"; do
                    # Only convert to relative if both the binary and the dependency are in the store
                    if [[ "$i" == "$store_path"/* && "$r" == "$store_path"/* ]]; then
                        local rel
                        rel=$(realpath -m --relative-to="$(dirname "$i")" "$r")
                        rpath_entry='$ORIGIN/'"$rel"
                    else
                        rpath_entry="$r"
                    fi

                    if [ -z "$new_rpath" ]; then
                        new_rpath="$rpath_entry"
                    else
                        new_rpath="$new_rpath:$rpath_entry"
                    fi
                done

                # Check if the RPATH has actually changed to avoid redundant writes
                if [ "$rpath" != "$new_rpath" ]; then
                    echo "setting RPATH to: $new_rpath"
                    patchelf --set-rpath "$new_rpath" "$i"
                fi
            fi
        fi
    done < <(find "$dir" -type f -print0)
}
