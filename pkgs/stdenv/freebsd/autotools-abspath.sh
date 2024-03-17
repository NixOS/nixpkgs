postPatchHooks+=(autotoolsAbspathHook)

autotoolsAbspathHook() {
    if [ -z "$dontAutopatchAutotools" ]; then
        AUTOTOOLS_FILES="configure config.guess"
        for filename in $AUTOTOOLS_FILES; do
            find . -name $filename -exec \
                sed -e 's@/usr/bin/uname@uname@g' -i '{}' ';'
        done
    fi
}
