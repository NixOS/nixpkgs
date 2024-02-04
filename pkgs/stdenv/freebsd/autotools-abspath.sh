postPatchHooks+=(autotoolsAbspathHook)

autotoolsAbspathHook() {
    if [ -z "$dontAutopatchAutotools" ]; then
        AUTOTOOLS_FILES="configure config.guess"
        for filename in $AUTOTOOLS_FILES; do
            for pathname in $(find . -name $filename); do
                sed -E -i -e "s_/usr/bin/uname_uname_g" "$pathname"
                #sed -E -i -e "s_(\w|^)/bin/sh_\\1sh_g" "$pathname"
            done
        done
    fi
}
