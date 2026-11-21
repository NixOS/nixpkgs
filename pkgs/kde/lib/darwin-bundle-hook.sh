# shellcheck shell=bash
# shellcheck disable=SC2154

fixDarwinBundles() {
    # Just in case it doesn't work with all of them
    if [ -n "${dontFixupDarwinBundle-}" ]; then
        return
    fi

    local prefix="${!outputBin}"
    local app name f

    for app in "$prefix"/bin/*.app; do
        [ -e "$app" ] || continue
        mkdir -p "$prefix/Applications"
        mv "$app" "$prefix/Applications/"
    done

    for app in "$prefix"/Applications/*.app; do
        [ -e "$app" ] || continue
        name="$(basename "$app" .app)"

        mkdir -p "$app/Contents/Resources"
        for f in "$prefix"/share/*; do
            if [ ! -e "$app/Contents/Resources/$(basename "$f")" ]; then
                ln -s "$f" "$app/Contents/Resources/"
            fi
        done

        for f in "$prefix"/bin/*; do
            if [ -f "$f" ] && [ -x "$f" ] && [ ! -e "$app/Contents/MacOS/$(basename "$f")" ]; then
                ln -s "$f" "$app/Contents/MacOS/"
            fi
        done

        if [ -e "$app/Contents/MacOS/$name" ] && [ ! -e "$prefix/bin/$name" ]; then
            mkdir -p "$prefix/bin"
            ln -s "$app/Contents/MacOS/$name" "$prefix/bin/$name"
        fi
    done
}

postInstallHooks+=('fixDarwinBundles')
